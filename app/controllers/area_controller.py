from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify
from flask_login import login_required, current_user
import re
import unicodedata
from app.models.area import Area, AreaUser
from app.models.user import User
from app.models.task import Task
from app.models.scheduled_task import ScheduledTask
from app.config import db
from datetime import datetime
from app.services.email_service import EmailService

area_bp = Blueprint('area', __name__)

def admin_required(f):
    """Decorador para requerir permisos de administrador"""
    from functools import wraps
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated:
            flash('Por favor inicia sesión para acceder a esta página', 'error')
            return redirect(url_for('auth.login'))
        elif not current_user.is_admin():
            flash('No tienes permisos para acceder a esta página', 'error')
            return redirect(url_for('task.my_tasks'))
        return f(*args, **kwargs)
    return decorated_function


def area_scope_required(f):
    """Permitir acceso a global admin o admin asignado a un área concreta."""
    from functools import wraps
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated:
            flash('Por favor inicia sesión para acceder a esta página', 'error')
            return redirect(url_for('auth.login'))

        area_id = kwargs.get('area_id')
        if current_user.is_admin():
            return f(*args, **kwargs)

        if area_id is not None and current_user.can_manage_area(area_id):
            return f(*args, **kwargs)

        flash('No tienes permisos para acceder a esta área', 'error')
        return redirect(url_for('task.my_tasks'))

    return decorated_function


def _slugify_area_name(area_name: str) -> str:
    normalized = unicodedata.normalize('NFKD', (area_name or '').strip())
    ascii_name = normalized.encode('ascii', 'ignore').decode('ascii').lower()
    slug = re.sub(r'[^a-z0-9]+', '_', ascii_name).strip('_')
    return slug or 'general'


def _build_area_admin_identity(area_name: str):
    base = _slugify_area_name(area_name)
    username = f'area_admin_{base}'
    email = f'{username}@example.com'
    suffix = 2

    while User.query.filter((User.username == username) | (User.email == email)).first():
        username = f'area_admin_{base}_{suffix}'
        email = f'{username}@example.com'
        suffix += 1

    return username, email

@area_bp.route('/create', methods=['GET', 'POST'])
@login_required
@admin_required
def create():
    """Crear nueva área"""
    if request.method == 'POST':
        name = request.form.get('name')
        description = request.form.get('description')
        
        if not name:
            flash('El nombre del área es requerido', 'error')
            return render_template('area/create.html')
        
        # Verificar si el área ya existe
        existing_area = Area.query.filter_by(name=name).first()
        if existing_area:
            flash('Ya existe un área con ese nombre', 'error')
            return render_template('area/create.html')
        
        area = Area(
            name=name,
            description=description,
            is_active=True
        )
        
        try:
            db.session.add(area)
            db.session.commit()

            # Crear automáticamente un usuario admin por área
            # (rol: area_admin) y asignarlo a la recién creada.
            area_admin_username, area_admin_email = _build_area_admin_identity(area.name)
            existing = User.query.filter_by(username=area_admin_username).first()
            if not existing:
                area_admin = User(
                    username=area_admin_username,
                    email=area_admin_email,
                    role='area_admin',
                    is_active=True
                )
                area_admin.set_password('uml57vli60')
                db.session.add(area_admin)
                db.session.flush()

                assignment = AreaUser.query.filter_by(area_id=area.id, user_id=area_admin.id).first()
                if not assignment:
                    db.session.add(AreaUser(area_id=area.id, user_id=area_admin.id))
                db.session.commit()

            flash(f'Área "{name}" creada exitosamente', 'success')
            return redirect(url_for('admin.areas'))
        except Exception as e:
            db.session.rollback()
            flash('Error al crear el área', 'error')
    
    return render_template('area/create.html')

def _momento_de_corrida(tarea):
    return tarea.corrida_en or tarea.created_at or datetime(1970, 1, 1)


def _texto_cantidad(cantidad, singular, plural):
    return f"{cantidad} {singular if cantidad == 1 else plural}"


def _agrupar_tareas_del_area(tareas):
    """Una fila por programación. Las corridas quedan dentro, no en la tabla larga."""
    normales = []
    grupos = {}
    for tarea in tareas:
        if not tarea.scheduled_task_id:
            normales.append(tarea)
            continue
        grupos.setdefault(tarea.scheduled_task_id, []).append(tarea)

    if grupos:
        programaciones = {
            item.id: item
            for item in ScheduledTask.query.filter(ScheduledTask.id.in_(grupos)).all()
        }
    else:
        programaciones = {}

    periodicas = []
    for programacion_id, copias in grupos.items():
        programacion = programaciones.get(programacion_id)
        copias.sort(key=lambda tarea: (
            -_momento_de_corrida(tarea).timestamp(),
            (tarea.assignee.username if tarea.assignee else '').lower(),
        ))
        pendientes = sum(1 for copia in copias if copia.status == 'pendiente')
        en_progreso = sum(1 for copia in copias if copia.status == 'en_progreso')
        completadas = sum(1 for copia in copias if copia.status == 'completada')
        resumen = []
        if pendientes:
            resumen.append(_texto_cantidad(pendientes, 'pendiente', 'pendientes'))
        if en_progreso:
            resumen.append(_texto_cantidad(en_progreso, 'en progreso', 'en progreso'))
        if completadas:
            resumen.append(_texto_cantidad(completadas, 'completada', 'completadas'))
        if programacion and programacion.assigned_users:
            asignados = [usuario.username for usuario in programacion.assigned_users]
        else:
            asignados = sorted({copia.assignee.username for copia in copias if copia.assignee})
        fechas = [_momento_de_corrida(copia).date() for copia in copias]
        prioridades = {copia.priority for copia in copias}
        if programacion and programacion.interval and programacion.interval > 1:
            ciclo = f"{programacion.get_frequency_display()}, cada {programacion.interval}"
        elif programacion:
            ciclo = programacion.get_frequency_display()
        else:
            ciclo = 'Periódica'
        periodicas.append({
            'id': programacion_id,
            'titulo': programacion.title if programacion else copias[0].title,
            'asignados': asignados,
            'ciclo': ciclo,
            'prioridad': next(iter(prioridades)) if len(prioridades) == 1 else None,
            'cantidad': len(copias),
            'desde': min(fechas) if fechas else None,
            'hasta': max(fechas) if fechas else None,
            'resumen_estado': ' · '.join(resumen),
            'copias': copias,
            'hay_programacion': programacion is not None,
        })
    periodicas.sort(key=lambda item: item['titulo'].lower())
    return normales, periodicas


@area_bp.route('/<int:area_id>')
@login_required
@area_scope_required
def view(area_id):
    """Ver detalles de un área"""
    area = Area.query.get_or_404(area_id)
    users = area.get_users()
    tareas = Task.query.filter_by(area_id=area_id).order_by(Task.created_at.desc()).all()
    normales, periodicas = _agrupar_tareas_del_area(tareas)

    return render_template(
        'area/view.html',
        area=area,
        users=users,
        tasks=normales,
        periodicas=periodicas,
    )

@area_bp.route('/<int:area_id>/edit', methods=['GET', 'POST'])
@login_required
@area_scope_required
def edit(area_id):
    """Editar área"""
    area = Area.query.get_or_404(area_id)
    
    if request.method == 'POST':
        name = request.form.get('name')
        description = request.form.get('description')
        is_active = request.form.get('is_active') == 'on'
        
        if not name:
            flash('El nombre del área es requerido', 'error')
            return render_template('area/edit.html', area=area)
        
        # Verificar si el nombre ya existe en otra área
        existing_area = Area.query.filter(Area.name == name, Area.id != area_id).first()
        if existing_area:
            flash('Ya existe un área con ese nombre', 'error')
            return render_template('area/edit.html', area=area)
        
        area.name = name
        area.description = description
        area.is_active = is_active
        area.updated_at = datetime.utcnow()
        
        try:
            db.session.commit()
            flash('Área actualizada exitosamente', 'success')
            return redirect(url_for('area.view', area_id=area_id))
        except Exception as e:
            db.session.rollback()
            flash('Error al actualizar el área', 'error')
    
    return render_template('area/edit.html', area=area)

@area_bp.route('/<int:area_id>/assign-users', methods=['GET', 'POST'])
@login_required
@admin_required
def assign_users(area_id):
    """Asignar usuarios a un área"""
    area = Area.query.get_or_404(area_id)
    
    if request.method == 'POST':
        user_ids = request.form.getlist('user_ids')
        
        # Obtener asignaciones actuales para no duplicar ni eliminar las existentes
        current_assignments = AreaUser.query.filter_by(area_id=area_id).all()
        current_user_ids = {au.user_id for au in current_assignments}

        # Crear solo las nuevas asignaciones sin borrar las anteriores
        for user_id in user_ids:
            user_id_int = int(user_id)
            if user_id_int not in current_user_ids:
                area_user = AreaUser(area_id=area_id, user_id=user_id_int)
                db.session.add(area_user)
                # Notificar nueva asignación a área
                EmailService.notify_user_assigned_to_area(user_id_int, area_id)
        
        try:
            db.session.commit()
            flash('Usuarios asignados exitosamente', 'success')
            return redirect(url_for('area.view', area_id=area_id))
        except Exception as e:
            db.session.rollback()
            flash('Error al asignar usuarios', 'error')
    
    # Obtener usuarios disponibles
    assigned_user_ids = [au.user_id for au in area.user_assignments]
    available_users = User.query.filter(User.id.notin_(assigned_user_ids), User.is_active == True).all()
    assigned_users = area.get_users()
    
    return render_template('area/assign_users.html', 
                         area=area, 
                         available_users=available_users, 
                         assigned_users=assigned_users)

@area_bp.route('/<int:area_id>/remove-user/<int:user_id>', methods=['POST'])
@login_required
@admin_required
def remove_user(area_id, user_id):
    """Quitar la asignación de un usuario a un área"""
    area = Area.query.get_or_404(area_id)
    
    assignment = AreaUser.query.filter_by(area_id=area_id, user_id=user_id).first()
    if not assignment:
        flash('La asignación no existe', 'error')
        return redirect(url_for('area.assign_users', area_id=area_id))
    
    try:
        db.session.delete(assignment)
        db.session.commit()
        flash('Usuario removido del área exitosamente', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Error al remover el usuario del área', 'error')
    
    return redirect(url_for('area.assign_users', area_id=area_id))

@area_bp.route('/<int:area_id>/delete', methods=['POST'])
@login_required
@admin_required
def delete(area_id):
    """Eliminar área"""
    area = Area.query.get_or_404(area_id)
    
    # Verificar si tiene tareas asociadas
    if area.tasks:
        flash('No se puede eliminar un área que tiene tareas asociadas', 'error')
        return redirect(url_for('area.view', area_id=area_id))
    
    try:
        db.session.delete(area)
        db.session.commit()
        flash('Área eliminada exitosamente', 'success')
        return redirect(url_for('admin.areas'))
    except Exception as e:
        db.session.rollback()
        flash('Error al eliminar el área', 'error')
        return redirect(url_for('area.view', area_id=area_id))
