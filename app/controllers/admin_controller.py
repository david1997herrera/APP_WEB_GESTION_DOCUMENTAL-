from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify
from flask_login import login_required, current_user
from app.models.user import User
from app.models.area import Area, AreaUser
from app.models.task import Task
from app.models.file import File
from app.config import db
from app.services.email_service import EmailService
from datetime import datetime

admin_bp = Blueprint('admin', __name__)


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

@admin_bp.route('/dashboard')
@login_required
@admin_required
def dashboard():
    """Dashboard principal del administrador"""
    # Obtener estadísticas generales
    total_users = User.query.count()
    total_areas = Area.query.count()
    total_tasks = Task.query.count()
    pending_tasks = Task.query.filter(Task.status != 'completada').count()
    
    # Tareas vencidas
    from datetime import datetime
    overdue_tasks = Task.query.filter(
        Task.due_date < datetime.utcnow(),
        Task.status != 'completada'
    ).count()
    
    # Tareas de hoy
    today = datetime.utcnow().date()
    today_tasks = Task.query.filter(
        Task.due_date >= today,
        Task.due_date < today.replace(day=today.day + 1)
    ).count()
    
    # Obtener áreas con información detallada
    areas = Area.query.filter_by(is_active=True).all()
    areas_data = []
    
    for area in areas:
        area_info = {
            'area': area,
            'user_count': area.get_user_count(),
            'task_count': area.get_task_count(),
            'pending_tasks': area.get_pending_task_count(),
            'in_progress_tasks': area.get_in_progress_task_count(),
            'completed_tasks': area.get_completed_task_count(),
            'overdue_tasks': area.get_overdue_task_count(),
            'today_tasks': area.get_today_task_count(),
            'high_priority_tasks': area.get_high_priority_task_count(),
            'completion_rate': area.get_completion_rate()
        }
        
        areas_data.append(area_info)
    
    # Obtener tareas recientes
    recent_tasks = Task.query.order_by(Task.created_at.desc()).limit(5).all()
    
    # Obtener usuarios recientes
    recent_users = User.query.order_by(User.created_at.desc()).limit(5).all()
    
    return render_template('admin/dashboard.html',
                         total_users=total_users,
                         total_areas=total_areas,
                         total_tasks=total_tasks,
                         pending_tasks=pending_tasks,
                         overdue_tasks=overdue_tasks,
                         today_tasks=today_tasks,
                         areas_data=areas_data,
                         recent_tasks=recent_tasks,
                         recent_users=recent_users)

@admin_bp.route('/users')
@login_required
@admin_required
def users():
    """Gestión de usuarios"""
    users = User.query.order_by(User.created_at.desc()).all()
    return render_template('admin/users.html', users=users)

@admin_bp.route('/areas')
@login_required
@admin_required
def areas():
    """Gestión de áreas"""
    areas = Area.query.order_by(Area.created_at.desc()).all()
    return render_template('admin/areas.html', areas=areas)

@admin_bp.route('/tasks')
@login_required
@admin_required
def tasks():
    """Gestión de tareas"""
    tasks = Task.query.order_by(Task.created_at.desc()).all()
    return render_template('admin/tasks.html', tasks=tasks)

@admin_bp.route('/reports')
@login_required
@admin_required
def reports():
    """Reportes y estadísticas"""
    # Estadísticas por área
    areas_stats = []
    areas = Area.query.filter_by(is_active=True).all()
    
    for area in areas:
        tasks = Task.query.filter_by(area_id=area.id).all()
        completed_tasks = [t for t in tasks if t.status == 'completada']
        
        area_stats = {
            'area': area,
            'total_tasks': len(tasks),
            'completed_tasks': len(completed_tasks),
            'completion_rate': round((len(completed_tasks) / len(tasks)) * 100, 1) if tasks else 0,
            'users_count': area.get_user_count()
        }
        areas_stats.append(area_stats)
    
    return render_template('admin/reports.html', areas_stats=areas_stats)

# Redirección segura si alguien entra por GET a /create-user
@admin_bp.route('/create-user', methods=['GET'])
@login_required
@admin_required
def create_user_get():
    return redirect(url_for('admin.users'))

@admin_bp.route('/create-user', methods=['POST'])
@login_required
@admin_required
def create_user():
    """Crear nuevo usuario"""
    username = request.form.get('username')
    email = request.form.get('email')
    password = request.form.get('password')
    role = request.form.get('role')
    
    if not all([username, email, password, role]):
        flash('Todos los campos son requeridos', 'error')
        return redirect(url_for('admin.users'))
    
    # Verificar si el usuario ya existe
    existing_user = User.query.filter(
        (User.username == username) | (User.email == email)
    ).first()
    
    if existing_user:
        flash('Ya existe un usuario con ese nombre o email', 'error')
        return redirect(url_for('admin.users'))
    
    user = User(
        username=username,
        email=email,
        role=role,
        is_active=True
    )
    user.set_password(password)
    
    try:
        db.session.add(user)
        db.session.commit()
        
        # Enviar notificación de cuenta creada
        EmailService.notify_user_created(user.email, username, password, role)
        
        flash(f'Usuario "{username}" creado exitosamente', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Error al crear el usuario', 'error')
    
    return redirect(url_for('admin.users'))

@admin_bp.route('/edit-user/<int:user_id>')
@login_required
@admin_required
def edit_user_get(user_id):
    """Mostrar formulario de edición de usuario"""
    user = User.query.get_or_404(user_id)
    return render_template('admin/edit_user.html', user=user)

@admin_bp.route('/edit-user/<int:user_id>', methods=['POST'])
@login_required
@admin_required
def edit_user(user_id):
    """Actualizar usuario"""
    user = User.query.get_or_404(user_id)
    
    username = request.form.get('username')
    email = request.form.get('email')
    password = request.form.get('password')
    role = request.form.get('role')
    is_active = request.form.get('is_active') == 'on'
    
    if not all([username, email, role]):
        flash('Usuario, email y rol son requeridos', 'error')
        return redirect(url_for('admin.edit_user_get', user_id=user_id))
    
    # Verificar si el usuario ya existe (excluyendo el usuario actual)
    existing_user = User.query.filter(
        (User.username == username) | (User.email == email)
    ).filter(User.id != user_id).first()
    
    if existing_user:
        flash('Ya existe un usuario con ese nombre o email', 'error')
        return redirect(url_for('admin.edit_user_get', user_id=user_id))
    
    # Actualizar datos
    user.username = username
    user.email = email
    user.role = role
    user.is_active = is_active
    
    # Actualizar contraseña solo si se proporciona una nueva
    if password:
        user.set_password(password)
        # Notificar cambio de contraseña
        try:
            EmailService.notify_password_reset(user.email, user.username, password)
        except Exception:
            pass
    
    try:
        db.session.commit()
        flash(f'Usuario "{username}" actualizado exitosamente', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Error al actualizar el usuario', 'error')
    
    return redirect(url_for('admin.users'))

@admin_bp.route('/delete-user/<int:user_id>', methods=['POST'])
@login_required
@admin_required
def delete_user(user_id):
    """Eliminar usuario"""
    user = User.query.get_or_404(user_id)
    
    # No permitir eliminar el usuario admin principal
    if user.username == 'Admin':
        flash('No se puede eliminar el usuario administrador principal', 'error')
        return redirect(url_for('admin.users'))
    
    try:
        db.session.delete(user)
        db.session.commit()
        flash(f'Usuario "{user.username}" eliminado exitosamente', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Error al eliminar el usuario', 'error')
    
    return redirect(url_for('admin.users'))
