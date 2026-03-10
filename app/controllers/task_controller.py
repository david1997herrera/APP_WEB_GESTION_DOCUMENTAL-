from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify
from flask_login import login_required, current_user
from app.models.task import Task
from app.models.area import Area
from app.models.user import User
from app.models.file import File
from app.config import db
from app.services.email_service import EmailService
from datetime import datetime
from sqlalchemy import or_

task_bp = Blueprint('task', __name__)

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

@task_bp.route('/create', methods=['GET', 'POST'])
@login_required
@admin_required
def create():
    """Crear nueva tarea"""
    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')
        area_id = request.form.get('area_id')
        assigned_to = request.form.get('assigned_to')
        priority = request.form.get('priority')
        required_files = request.form.get('required_files', 0)
        due_date = request.form.get('due_date')
        
        if not all([title, area_id]):
            flash('El título y el área son requeridos', 'error')
            return render_template('task/create.html', areas=Area.query.filter_by(is_active=True).all())
        
        # Convertir fecha si se proporciona
        due_date_obj = None
        if due_date:
            try:
                due_date_obj = datetime.strptime(due_date, '%Y-%m-%d')
            except ValueError:
                flash('Formato de fecha inválido', 'error')
                return render_template('task/create.html', areas=Area.query.filter_by(is_active=True).all())
        
        task = Task(
            title=title,
            description=description,
            area_id=int(area_id),
            created_by=current_user.id,
            assigned_to=int(assigned_to) if assigned_to else None,
            priority=priority,
            required_files=int(required_files) if required_files else 0,
            due_date=due_date_obj
        )
        
        try:
            db.session.add(task)
            db.session.commit()
            
            # Enviar notificación si la tarea tiene asignado
            if task.assigned_to:
                EmailService.notify_task_assigned(task.id, task.assigned_to)
            
            flash('Tarea creada exitosamente', 'success')
            return redirect(url_for('task.view', task_id=task.id))
        except Exception as e:
            db.session.rollback()
            flash('Error al crear la tarea', 'error')
    
    areas = Area.query.filter_by(is_active=True).all()
    # Solo mostrar usuarios activos para asignación
    users = User.query.filter_by(is_active=True).all()
    return render_template('task/create.html', areas=areas, users=users)

@task_bp.route('/<int:task_id>')
@login_required
def view(task_id):
    """Ver detalles de una tarea"""
    task = Task.query.get_or_404(task_id)
    
    # Verificar permisos
    if not current_user.is_admin():
        # Verificar si el usuario tiene acceso al área de la tarea
        user_areas = [assignment.area_id for assignment in current_user.area_assignments]
        if task.area_id not in user_areas:
            flash('No tienes permisos para ver esta tarea', 'error')
            return redirect(url_for('task.my_tasks'))
    
    files = File.query.filter_by(task_id=task_id).all()
    return render_template('task/view.html', task=task, files=files)

@task_bp.route('/my')
@login_required
def my_tasks():
    """Listado de tareas asignadas al usuario actual"""
    if current_user.is_admin():
        return redirect(url_for('admin.dashboard'))
    
    # Obtener áreas del usuario
    user_areas = [assignment.area_id for assignment in current_user.area_assignments]
    
    if not user_areas:
        flash('No tienes áreas asignadas. Contacta al administrador.', 'warning')
        return render_template('task/my_tasks.html', tasks=[])
    
    # Obtener tareas de las áreas del usuario:
    # - Asignadas explícitamente al usuario, o
    # - Sin asignar (visibles por área)
    tasks = Task.query.filter(
        Task.area_id.in_(user_areas),
        or_(Task.assigned_to == current_user.id, Task.assigned_to.is_(None))
    ).order_by(Task.created_at.desc()).all()
    
    return render_template('task/my_tasks.html', tasks=tasks)

@task_bp.route('/<int:task_id>/edit', methods=['GET', 'POST'])
@login_required
@admin_required
def edit(task_id):
    """Editar tarea"""
    task = Task.query.get_or_404(task_id)
    
    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')
        area_id = request.form.get('area_id')
        assigned_to = request.form.get('assigned_to')
        priority = request.form.get('priority')
        status = request.form.get('status')
        required_files = request.form.get('required_files', 0)
        due_date = request.form.get('due_date')
        
        if not all([title, area_id]):
            flash('El título y el área son requeridos', 'error')
            return render_template('task/edit.html', task=task, areas=Area.query.filter_by(is_active=True).all())
        
        # Convertir fecha si se proporciona
        due_date_obj = None
        if due_date:
            try:
                due_date_obj = datetime.strptime(due_date, '%Y-%m-%d')
            except ValueError:
                flash('Formato de fecha inválido', 'error')
                return render_template('task/edit.html', task=task, areas=Area.query.filter_by(is_active=True).all())
        
        task.title = title
        task.description = description
        task.area_id = int(area_id)
        task.assigned_to = int(assigned_to) if assigned_to else None
        task.priority = priority
        task.status = status
        task.required_files = int(required_files) if required_files else 0
        task.due_date = due_date_obj
        task.updated_at = datetime.utcnow()
        
        # Actualizar estado si se marca como completada
        if status == 'completada' and task.status != 'completada':
            task.completed_at = datetime.utcnow()
        
        try:
            db.session.commit()
            flash('Tarea actualizada exitosamente', 'success')
            return redirect(url_for('task.view', task_id=task_id))
        except Exception as e:
            db.session.rollback()
            flash('Error al actualizar la tarea', 'error')
    
    areas = Area.query.filter_by(is_active=True).all()
    users = User.query.filter_by(is_active=True).all()
    return render_template('task/edit.html', task=task, areas=areas, users=users)

@task_bp.route('/<int:task_id>/delete', methods=['POST'])
@login_required
@admin_required
def delete(task_id):
    """Eliminar tarea"""
    task = Task.query.get_or_404(task_id)
    
    try:
        # Eliminar archivos asociados
        for file in task.files:
            file.delete_file()
            db.session.delete(file)
        
        db.session.delete(task)
        db.session.commit()
        flash('Tarea eliminada exitosamente', 'success')
        return redirect(url_for('admin.tasks'))
    except Exception as e:
        db.session.rollback()
        flash('Error al eliminar la tarea', 'error')
        return redirect(url_for('task.view', task_id=task_id))

@task_bp.route('/<int:task_id>/update-status', methods=['POST'])
@login_required
def update_status(task_id):
    """Actualizar estado de la tarea"""
    task = Task.query.get_or_404(task_id)
    new_status = request.form.get('status')
    
    # Verificar permisos
    if not current_user.is_admin():
        # Verificar si el usuario tiene acceso al área de la tarea
        user_areas = [assignment.area_id for assignment in current_user.area_assignments]
        if task.area_id not in user_areas:
            flash('No tienes permisos para actualizar esta tarea', 'error')
            return redirect(url_for('task.my_tasks'))
    
    if new_status in ['pendiente', 'en_progreso', 'completada']:
        old_status = task.status
        task.status = new_status
        if new_status == 'completada':
            task.completed_at = datetime.utcnow()
        task.updated_at = datetime.utcnow()
        
        try:
            db.session.commit()
            
            # Enviar notificación si la tarea se completó
            if new_status == 'completada' and old_status != 'completada':
                EmailService.notify_task_completed(task.id)
            
            flash('Estado de la tarea actualizado', 'success')
        except Exception as e:
            db.session.rollback()
            flash('Error al actualizar el estado', 'error')
    
    return redirect(url_for('task.view', task_id=task_id))
