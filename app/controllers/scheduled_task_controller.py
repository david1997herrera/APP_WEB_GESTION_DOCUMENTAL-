from datetime import datetime, timedelta

from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user

from app.config import db
from app.models.area import Area
from app.models.scheduled_task import ScheduledTask
from app.models.task import Task
from app.models.user import User


scheduled_task_bp = Blueprint('scheduled_task', __name__)


def admin_required(f):
    from functools import wraps

    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated:
            flash('Por favor inicia sesión para acceder a esta página', 'error')
            return redirect(url_for('auth.login'))
        if not current_user.is_admin():
            flash('No tienes permisos para acceder a esta página', 'error')
            return redirect(url_for('task.my_tasks'))
        return f(*args, **kwargs)

    return decorated_function


def _align_datetime_with_run_time(base_dt: datetime, run_time):
    """Alinear fecha base con hora de ejecución si existe."""
    if not base_dt:
        return None
    if not run_time:
        return base_dt.replace(second=0, microsecond=0)
    return base_dt.replace(
        hour=run_time.hour,
        minute=run_time.minute,
        second=0,
        microsecond=0,
    )


def _add_frequency_interval(current: datetime, frequency: str, interval: int) -> datetime:
    """Avanzar fecha actual según frecuencia/intervalo."""
    safe_interval = max(1, int(interval or 1))
    if frequency == 'diaria':
        return current + timedelta(days=safe_interval)
    if frequency == 'semanal':
        return current + timedelta(weeks=safe_interval)
    if frequency == 'mensual':
        # Aproximación actual del proyecto: 30 días por mes
        return current + timedelta(days=30 * safe_interval)
    # Por defecto, personalizada se trata como diaria
    return current + timedelta(days=safe_interval)


def _create_generated_tasks_for_schedule(scheduled: ScheduledTask) -> bool:
    """Crear tareas derivadas para todos los usuarios asignados."""
    if not scheduled.assigned_users:
        return False

    for user in scheduled.assigned_users:
        task = Task(
            title=scheduled.title,
            description=scheduled.description,
            area_id=scheduled.area_id,
            created_by=scheduled.created_by,
            assigned_to=user.id,
            priority=scheduled.priority or 'media',
            scheduled_task_id=scheduled.id,
        )
        db.session.add(task)
    return True


def _process_single_scheduled_task(scheduled: ScheduledTask, reference: datetime) -> bool:
    """Procesar una tarea programada puntual; devuelve True si generó tareas."""
    # Respetar fecha de inicio
    if scheduled.start_date and scheduled.start_date > reference:
        return False

    # Respetar fecha de fin
    if scheduled.end_date and reference > scheduled.end_date:
        return False

    run_at = scheduled.next_run_at or _align_datetime_with_run_time(scheduled.start_date, scheduled.run_time)
    if not run_at:
        return False

    # Si aún no toca, no generar
    if run_at > reference:
        return False

    generated = _create_generated_tasks_for_schedule(scheduled)
    if generated:
        scheduled.next_run_at = _calculate_next_run_at(scheduled, reference)
        scheduled.updated_at = reference
    return generated


@scheduled_task_bp.route('/')
@login_required
@admin_required
def index():
    """Listado de tareas programadas"""
    tasks = ScheduledTask.query.order_by(ScheduledTask.created_at.desc()).all()
    return render_template('scheduled_tasks/index.html', tasks=tasks)


@scheduled_task_bp.route('/<int:task_id>')
@login_required
@admin_required
def view(task_id):
    """Ver detalles de una tarea programada"""
    task = ScheduledTask.query.get_or_404(task_id)
    return render_template('scheduled_tasks/view.html', task=task)


@scheduled_task_bp.route('/create', methods=['GET', 'POST'])
@login_required
@admin_required
def create():
    """Crear nueva tarea programada"""
    areas = Area.query.filter_by(is_active=True).all()
    users = User.query.filter_by(is_active=True).all()

    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')
        area_id = request.form.get('area_id')
        frequency = request.form.get('frequency')
        priority = request.form.get('priority', 'media')
        interval = request.form.get('interval') or 1
        start_date = request.form.get('start_date')
        run_time = request.form.get('run_time')
        end_date = request.form.get('end_date')
        assigned_user_ids = request.form.getlist('assigned_users')

        if not title or not area_id or not frequency:
            flash('El título, el área y la frecuencia son obligatorios.', 'error')
            return render_template('scheduled_tasks/create.html', areas=areas, users=users)

        try:
            start_date_obj = datetime.strptime(start_date, '%Y-%m-%d') if start_date else datetime.utcnow()
        except ValueError:
            flash('Formato de fecha de inicio inválido.', 'error')
            return render_template('scheduled_tasks/create.html', areas=areas, users=users)

        run_time_obj = None
        if run_time:
            try:
                run_time_obj = datetime.strptime(run_time, '%H:%M').time()
            except ValueError:
                flash('Formato de hora inválido.', 'error')
                return render_template('scheduled_tasks/create.html', areas=areas, users=users)

        end_date_obj = None
        if end_date:
            try:
                end_date_obj = datetime.strptime(end_date, '%Y-%m-%d')
            except ValueError:
                flash('Formato de fecha de fin inválido.', 'error')
                return render_template('scheduled_tasks/create.html', areas=areas, users=users)

        scheduled_task = ScheduledTask(
            title=title,
            description=description,
            area_id=int(area_id),
            created_by=current_user.id,
            frequency=frequency,
            priority=priority,
            interval=int(interval),
            start_date=start_date_obj,
            run_time=run_time_obj,
            end_date=end_date_obj,
            next_run_at=_align_datetime_with_run_time(start_date_obj, run_time_obj),
            is_active=True,
        )

        if assigned_user_ids:
            scheduled_task.assigned_users = User.query.filter(User.id.in_(assigned_user_ids)).all()

        try:
            db.session.add(scheduled_task)
            db.session.commit()

            # Catch-up inmediato: si la hora/fecha ya pasó, crear tareas ahora mismo.
            now = datetime.utcnow()
            if _process_single_scheduled_task(scheduled_task, now):
                db.session.commit()

            flash('Tarea programada creada correctamente.', 'success')
            return redirect(url_for('scheduled_task.index'))
        except Exception:
            db.session.rollback()
            flash('Error al crear la tarea programada.', 'error')

    return render_template('scheduled_tasks/create.html', areas=areas, users=users)


@scheduled_task_bp.route('/<int:task_id>/edit', methods=['GET', 'POST'])
@login_required
@admin_required
def edit(task_id):
    """Editar tarea programada"""
    task = ScheduledTask.query.get_or_404(task_id)
    areas = Area.query.filter_by(is_active=True).all()
    users = User.query.filter_by(is_active=True).all()

    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')
        area_id = request.form.get('area_id')
        frequency = request.form.get('frequency')
        priority = request.form.get('priority', 'media')
        interval = request.form.get('interval') or 1
        start_date = request.form.get('start_date')
        run_time = request.form.get('run_time')
        end_date = request.form.get('end_date')
        is_active = request.form.get('is_active') == 'on'
        assigned_user_ids = request.form.getlist('assigned_users')

        if not title or not area_id or not frequency:
            flash('El título, el área y la frecuencia son obligatorios.', 'error')
            return render_template('scheduled_tasks/edit.html', task=task, areas=areas, users=users)

        try:
            start_date_obj = datetime.strptime(start_date, '%Y-%m-%d') if start_date else datetime.utcnow()
        except ValueError:
            flash('Formato de fecha de inicio inválido.', 'error')
            return render_template('scheduled_tasks/edit.html', task=task, areas=areas, users=users)

        run_time_obj = None
        if run_time:
            try:
                run_time_obj = datetime.strptime(run_time, '%H:%M').time()
            except ValueError:
                flash('Formato de hora inválido.', 'error')
                return render_template('scheduled_tasks/edit.html', task=task, areas=areas, users=users)

        end_date_obj = None
        if end_date:
            try:
                end_date_obj = datetime.strptime(end_date, '%Y-%m-%d')
            except ValueError:
                flash('Formato de fecha de fin inválido.', 'error')
                return render_template('scheduled_tasks/edit.html', task=task, areas=areas, users=users)

        task.title = title
        task.description = description
        task.area_id = int(area_id)
        task.frequency = frequency
        task.priority = priority
        task.interval = int(interval)
        task.start_date = start_date_obj
        task.run_time = run_time_obj
        task.end_date = end_date_obj
        task.is_active = is_active
        task.next_run_at = _align_datetime_with_run_time(start_date_obj, run_time_obj)
        task.updated_at = datetime.utcnow()

        if assigned_user_ids:
            task.assigned_users = User.query.filter(User.id.in_(assigned_user_ids)).all()
        else:
            task.assigned_users = []

        try:
            db.session.commit()

            # Catch-up al editar: si ya tocaba correr, generar al guardar.
            now = datetime.utcnow()
            if _process_single_scheduled_task(task, now):
                db.session.commit()

            flash('Tarea programada actualizada correctamente.', 'success')
            return redirect(url_for('scheduled_task.index'))
        except Exception:
            db.session.rollback()
            flash('Error al actualizar la tarea programada.', 'error')

    return render_template('scheduled_tasks/edit.html', task=task, areas=areas, users=users)


@scheduled_task_bp.route('/<int:task_id>/delete', methods=['POST'])
@login_required
@admin_required
def delete(task_id):
    """Eliminar tarea programada"""
    task = ScheduledTask.query.get_or_404(task_id)

    try:
        db.session.delete(task)
        db.session.commit()
        flash('Tarea programada eliminada correctamente.', 'success')
    except Exception:
        db.session.rollback()
        flash('Error al eliminar la tarea programada.', 'error')

    return redirect(url_for('scheduled_task.index'))


def _calculate_next_run_at(scheduled_task: ScheduledTask, reference: datetime) -> datetime:
    """Calcular próxima ejecución en base a frecuencia e intervalo."""
    current = scheduled_task.next_run_at or _align_datetime_with_run_time(
        scheduled_task.start_date,
        scheduled_task.run_time,
    )
    if not current:
        return reference

    if current <= reference:
        # Avanzar hasta que quede en el futuro
        while current <= reference:
            current = _add_frequency_interval(
                current,
                scheduled_task.frequency,
                scheduled_task.interval,
            )

    return current


def process_scheduled_tasks():
    """Generar tareas normales a partir de tareas programadas que toquen hoy/ahora."""
    now = datetime.utcnow()

    active_tasks = ScheduledTask.query.filter(
        ScheduledTask.is_active.is_(True),
        ScheduledTask.start_date <= now,
    ).all()

    for scheduled in active_tasks:
        _process_single_scheduled_task(scheduled, now)

    db.session.commit()

