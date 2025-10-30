from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify, make_response
from flask_login import login_required, current_user
from app.models.task import Task
from app.models.area import Area
from app.models.user import User
from app.models.file import File
from app.config import db
from datetime import datetime, timedelta
import csv
import io

reports_bp = Blueprint('reports', __name__)

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

@reports_bp.route('/')
@login_required
@admin_required
def index():
    """Página principal de reportes"""
    return render_template('reports/index.html')

@reports_bp.route('/tasks')
@login_required
@admin_required
def tasks():
    """Reporte de tareas"""
    # Obtener parámetros de filtro
    area_id = request.args.get('area_id', type=int)
    user_id = request.args.get('user_id', type=int)
    status = request.args.get('status', '')
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    
    # Construir consulta base
    query = Task.query
    
    # Aplicar filtros
    if area_id:
        query = query.filter(Task.area_id == area_id)
    
    if user_id:
        query = query.filter(Task.assigned_to == user_id)
    
    if status:
        query = query.filter(Task.status == status)
    
    if date_from:
        try:
            date_from_obj = datetime.strptime(date_from, '%Y-%m-%d')
            query = query.filter(Task.created_at >= date_from_obj)
        except ValueError:
            pass
    
    if date_to:
        try:
            date_to_obj = datetime.strptime(date_to, '%Y-%m-%d')
            date_to_obj = date_to_obj + timedelta(days=1)
            query = query.filter(Task.created_at < date_to_obj)
        except ValueError:
            pass
    
    tasks = query.order_by(Task.created_at.desc()).all()
    
    # Estadísticas
    total_tasks = len(tasks)
    completed_tasks = len([t for t in tasks if t.status == 'completada'])
    pending_tasks = len([t for t in tasks if t.status == 'pendiente'])
    in_progress_tasks = len([t for t in tasks if t.status == 'en_progreso'])
    overdue_tasks = len([t for t in tasks if t.is_overdue()])
    
    # Datos para filtros
    areas = Area.query.filter_by(is_active=True).all()
    users = User.query.filter_by(is_active=True).all()
    
    return render_template('reports/tasks.html',
                         tasks=tasks,
                         areas=areas,
                         users=users,
                         total_tasks=total_tasks,
                         completed_tasks=completed_tasks,
                         pending_tasks=pending_tasks,
                         in_progress_tasks=in_progress_tasks,
                         overdue_tasks=overdue_tasks,
                         current_filters={
                             'area_id': area_id,
                             'user_id': user_id,
                             'status': status,
                             'date_from': date_from,
                             'date_to': date_to
                         })

@reports_bp.route('/users')
@login_required
@admin_required
def users():
    """Reporte de usuarios"""
    # Obtener parámetros de filtro
    area_id = request.args.get('area_id', type=int)
    role = request.args.get('role', '')
    
    # Construir consulta base
    query = User.query.filter_by(is_active=True)
    
    # Aplicar filtros
    if area_id:
        query = query.join(User.area_assignments).filter(User.area_assignments.any(area_id=area_id))
    
    if role:
        query = query.filter(User.role == role)
    
    users = query.order_by(User.created_at.desc()).all()
    
    # Estadísticas por usuario
    user_stats = []
    for user in users:
        # Tareas asignadas
        assigned_tasks = Task.query.filter(Task.assigned_to == user.id).all()
        completed_tasks = len([t for t in assigned_tasks if t.status == 'completada'])
        
        # Archivos subidos
        uploaded_files = File.query.filter(File.uploaded_by == user.id).count()
        
        # Áreas asignadas
        assigned_areas = len(user.area_assignments)
        
        user_stats.append({
            'user': user,
            'assigned_tasks': len(assigned_tasks),
            'completed_tasks': completed_tasks,
            'uploaded_files': uploaded_files,
            'assigned_areas': assigned_areas,
            'completion_rate': round((completed_tasks / len(assigned_tasks)) * 100, 1) if assigned_tasks else 0
        })
    
    # Datos para filtros
    areas = Area.query.filter_by(is_active=True).all()
    roles = ['admin', 'escritura', 'lectura', 'edicion']
    
    return render_template('reports/users.html',
                         user_stats=user_stats,
                         areas=areas,
                         roles=roles,
                         current_filters={
                             'area_id': area_id,
                             'role': role
                         })

@reports_bp.route('/areas')
@login_required
@admin_required
def areas():
    """Reporte de áreas"""
    areas = Area.query.filter_by(is_active=True).all()
    
    area_stats = []
    for area in areas:
        # Tareas del área
        area_tasks = Task.query.filter(Task.area_id == area.id).all()
        completed_tasks = len([t for t in area_tasks if t.status == 'completada'])
        pending_tasks = len([t for t in area_tasks if t.status == 'pendiente'])
        in_progress_tasks = len([t for t in area_tasks if t.status == 'en_progreso'])
        overdue_tasks = len([t for t in area_tasks if t.is_overdue()])
        
        # Archivos del área
        area_files = File.query.join(Task).filter(Task.area_id == area.id).all()
        total_size = sum(file.file_size for file in area_files)
        
        # Usuarios asignados
        assigned_users = len(area.user_assignments)
        
        area_stats.append({
            'area': area,
            'total_tasks': len(area_tasks),
            'completed_tasks': completed_tasks,
            'pending_tasks': pending_tasks,
            'in_progress_tasks': in_progress_tasks,
            'overdue_tasks': overdue_tasks,
            'total_files': len(area_files),
            'total_size': total_size,
            'assigned_users': assigned_users,
            'completion_rate': round((completed_tasks / len(area_tasks)) * 100, 1) if area_tasks else 0
        })
    
    return render_template('reports/areas.html', area_stats=area_stats)

@reports_bp.route('/files')
@login_required
@admin_required
def files():
    """Reporte de archivos"""
    # Obtener parámetros de filtro
    area_id = request.args.get('area_id', type=int)
    file_type = request.args.get('file_type', '')
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    
    # Construir consulta base
    query = File.query.join(Task).join(Area)
    
    # Aplicar filtros
    if area_id:
        query = query.filter(Task.area_id == area_id)
    
    if file_type:
        query = query.filter(File.file_type.like(f'%{file_type}%'))
    
    if date_from:
        try:
            date_from_obj = datetime.strptime(date_from, '%Y-%m-%d')
            query = query.filter(File.uploaded_at >= date_from_obj)
        except ValueError:
            pass
    
    if date_to:
        try:
            date_to_obj = datetime.strptime(date_to, '%Y-%m-%d')
            date_to_obj = date_to_obj + timedelta(days=1)
            query = query.filter(File.uploaded_at < date_to_obj)
        except ValueError:
            pass
    
    files = query.order_by(File.uploaded_at.desc()).all()
    
    # Estadísticas
    total_files = len(files)
    total_size = sum(file.file_size for file in files)
    
    # Archivos por tipo
    file_types = {}
    for file in files:
        file_type = file.file_type.split('/')[0] if '/' in file.file_type else 'other'
        file_types[file_type] = file_types.get(file_type, 0) + 1
    
    # Archivos por área
    area_files = {}
    for file in files:
        area_name = file.task.area.name
        if area_name not in area_files:
            area_files[area_name] = 0
        area_files[area_name] += 1
    
    # Datos para filtros
    areas = Area.query.filter_by(is_active=True).all()
    
    return render_template('reports/files.html',
                         files=files,
                         areas=areas,
                         total_files=total_files,
                         total_size=total_size,
                         file_types=file_types,
                         area_files=area_files,
                         current_filters={
                             'area_id': area_id,
                             'file_type': file_type,
                             'date_from': date_from,
                             'date_to': date_to
                         })

@reports_bp.route('/export/tasks/csv')
@login_required
@admin_required
def export_tasks_csv():
    """Exportar reporte de tareas a CSV"""
    # Obtener parámetros de filtro (mismos que en tasks())
    area_id = request.args.get('area_id', type=int)
    user_id = request.args.get('user_id', type=int)
    status = request.args.get('status', '')
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    
    # Construir consulta base
    query = Task.query
    
    # Aplicar filtros
    if area_id:
        query = query.filter(Task.area_id == area_id)
    if user_id:
        query = query.filter(Task.assigned_to == user_id)
    if status:
        query = query.filter(Task.status == status)
    if date_from:
        try:
            date_from_obj = datetime.strptime(date_from, '%Y-%m-%d')
            query = query.filter(Task.created_at >= date_from_obj)
        except ValueError:
            pass
    if date_to:
        try:
            date_to_obj = datetime.strptime(date_to, '%Y-%m-%d')
            date_to_obj = date_to_obj + timedelta(days=1)
            query = query.filter(Task.created_at < date_to_obj)
        except ValueError:
            pass
    
    tasks = query.order_by(Task.created_at.desc()).all()
    
    # Crear CSV
    output = io.StringIO()
    writer = csv.writer(output)
    
    # Escribir encabezados
    writer.writerow([
        'ID', 'Título', 'Descripción', 'Área', 'Asignado a', 'Creado por',
        'Estado', 'Prioridad', 'Archivos Requeridos', 'Archivos Subidos',
        'Fecha Límite', 'Fecha Creación', 'Fecha Completada'
    ])
    
    # Escribir datos
    for task in tasks:
        writer.writerow([
            task.id,
            task.title,
            task.description or '',
            task.area.name,
            task.assignee.username if task.assignee else '',
            task.creator.username if task.creator else '',
            task.status,
            task.priority,
            task.required_files,
            task.uploaded_files,
            task.due_date.strftime('%Y-%m-%d') if task.due_date else '',
            task.created_at.strftime('%Y-%m-%d %H:%M'),
            task.completed_at.strftime('%Y-%m-%d %H:%M') if task.completed_at else ''
        ])
    
    # Preparar respuesta
    output.seek(0)
    response = make_response(output.getvalue())
    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-Disposition'] = f'attachment; filename=tareas_{datetime.now().strftime("%Y%m%d_%H%M%S")}.csv'
    
    return response

@reports_bp.route('/export/users/csv')
@login_required
@admin_required
def export_users_csv():
    """Exportar reporte de usuarios a CSV"""
    users = User.query.filter_by(is_active=True).all()
    
    # Crear CSV
    output = io.StringIO()
    writer = csv.writer(output)
    
    # Escribir encabezados
    writer.writerow([
        'ID', 'Usuario', 'Email', 'Rol', 'Áreas Asignadas',
        'Tareas Asignadas', 'Tareas Completadas', 'Archivos Subidos',
        'Tasa de Finalización (%)', 'Fecha Creación'
    ])
    
    # Escribir datos
    for user in users:
        assigned_tasks = Task.query.filter(Task.assigned_to == user.id).all()
        completed_tasks = len([t for t in assigned_tasks if t.status == 'completada'])
        uploaded_files = File.query.filter(File.uploaded_by == user.id).count()
        assigned_areas = len(user.area_assignments)
        completion_rate = round((completed_tasks / len(assigned_tasks)) * 100, 1) if assigned_tasks else 0
        
        writer.writerow([
            user.id,
            user.username,
            user.email,
            user.role,
            assigned_areas,
            len(assigned_tasks),
            completed_tasks,
            uploaded_files,
            completion_rate,
            user.created_at.strftime('%Y-%m-%d %H:%M')
        ])
    
    # Preparar respuesta
    output.seek(0)
    response = make_response(output.getvalue())
    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-Disposition'] = f'attachment; filename=usuarios_{datetime.now().strftime("%Y%m%d_%H%M%S")}.csv'
    
    return response
