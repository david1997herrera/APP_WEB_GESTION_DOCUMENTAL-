from flask import Blueprint, render_template, request, redirect, url_for, flash, send_file
from flask_login import login_required, current_user
from app.models.task import Task
from app.models.area import Area
from app.models.user import User
from app.models.file import File
from app.services.hoja_calculo import construir_libro
from datetime import datetime, timedelta

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
    tasks = _tareas_filtradas()
    area_id = request.args.get('area_id', type=int)
    status = request.args.get('status', '')
    priority = request.args.get('priority', '')
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    
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
                         selected_area_id=area_id,
                         selected_status=status,
                         selected_priority=priority,
                         selected_date_from=date_from,
                         selected_date_to=date_to)

@reports_bp.route('/users')
@login_required
@admin_required
def users():
    """Reporte de usuarios"""
    users = _usuarios_filtrados()
    stats = {usuario.id: _estadistica_usuario(usuario) for usuario in users}
    areas = Area.query.filter_by(is_active=True).all()
    return render_template(
        'reports/users.html',
        users=users,
        user_stats=stats,
        areas=areas,
        selected_role=request.args.get('role', ''),
        selected_area_id=request.args.get('area_id', type=int),
        selected_status=request.args.get('status', ''),
        total_users=len(users),
        active_users=len([usuario for usuario in users if usuario.is_active]),
        inactive_users=len([usuario for usuario in users if not usuario.is_active]),
        total_files=sum(dato['uploaded_files'] for dato in stats.values()),
    )

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
    
    areas = []
    stats_por_id = {}
    total_tasks = 0
    total_files = 0
    for stat in area_stats:
        area = stat['area']
        areas.append(area)
        stats_por_id[area.id] = {
            'user_count': stat['assigned_users'],
            'task_count': stat['total_tasks'],
            'file_count': stat['total_files'],
            'completion_rate': stat['completion_rate'],
        }
        total_tasks += stat['total_tasks']
        total_files += stat['total_files']

    return render_template(
        'reports/areas.html',
        areas=areas,
        area_stats=stats_por_id,
        total_areas=len(areas),
        total_users=User.query.filter_by(is_active=True).count(),
        total_tasks=total_tasks,
        total_files=total_files,
    )

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
    
    area_files = {}
    for file in files:
        area_name = file.task.area.name if file.task and file.task.area else 'Sin área'
        actual = area_files.setdefault(area_name, {'count': 0, 'size': 0})
        actual['count'] += 1
        actual['size'] += file.file_size or 0
    for datos in area_files.values():
        datos['size_mb'] = round(datos['size'] / (1024 * 1024), 2)

    areas = Area.query.filter_by(is_active=True).all()

    return render_template(
        'reports/files.html',
        files=files,
        areas=areas,
        total_files=total_files,
        total_size=total_size,
        total_size_mb=round((total_size or 0) / (1024 * 1024), 1),
        file_types=file_types,
        area_files=area_files,
        selected_area_id=area_id,
        selected_file_type=file_type,
        selected_date_from=date_from,
        selected_date_to=date_to,
    )

def _responder_excel(titulo, columnas, filas, nombre):
    libro = construir_libro(titulo, columnas, filas)
    marca = datetime.now().strftime('%Y%m%d_%H%M%S')
    return send_file(
        libro,
        as_attachment=True,
        download_name=f'{nombre}_{marca}.xlsx',
        mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    )


@reports_bp.route('/export/tasks/xlsx')
@login_required
@admin_required
def exportar_tareas():
    """Descarga el reporte de tareas en Excel, con el banner de la empresa."""
    filas = []
    for tarea in _tareas_filtradas():
        filas.append([
            tarea.id,
            tarea.title,
            tarea.description or '',
            tarea.area.name if tarea.area else '',
            tarea.assignee.username if tarea.assignee else '',
            tarea.creator.username if tarea.creator else '',
            (tarea.status or '').replace('_', ' '),
            tarea.priority or '',
            tarea.required_files,
            tarea.uploaded_files,
            tarea.due_date.strftime('%d/%m/%Y') if tarea.due_date else '',
            tarea.created_at.strftime('%d/%m/%Y %H:%M') if tarea.created_at else '',
            tarea.completed_at.strftime('%d/%m/%Y %H:%M') if tarea.completed_at else '',
        ])
    return _responder_excel(
        'Reporte de tareas',
        ['ID', 'Título', 'Descripción', 'Área', 'Asignado a', 'Creado por',
         'Estado', 'Prioridad', 'Archivos requeridos', 'Archivos subidos',
         'Fecha límite', 'Fecha de creación', 'Fecha completada'],
        filas,
        'tareas',
    )


@reports_bp.route('/export/users/xlsx')
@login_required
@admin_required
def exportar_usuarios():
    """Descarga el reporte de usuarios en Excel."""
    filas = []
    for usuario in _usuarios_filtrados():
        dato = _estadistica_usuario(usuario)
        filas.append([
            usuario.id,
            usuario.username,
            usuario.email,
            usuario.role,
            'Activo' if usuario.is_active else 'Inactivo',
            dato['assigned_areas'],
            dato['assigned_tasks'],
            dato['completed_tasks'],
            dato['uploaded_files'],
            dato['completion_rate'],
            usuario.created_at.strftime('%d/%m/%Y') if usuario.created_at else '',
        ])
    return _responder_excel(
        'Reporte de usuarios',
        ['ID', 'Usuario', 'Correo', 'Rol', 'Estado', 'Áreas',
         'Tareas asignadas', 'Tareas completadas', 'Archivos subidos',
         'Avance (%)', 'Fecha de creación'],
        filas,
        'usuarios',
    )


@reports_bp.route('/export/areas/xlsx')
@login_required
@admin_required
def exportar_areas():
    """Descarga el reporte de áreas en Excel."""
    filas = []
    for stat in _estadisticas_areas():
        area = stat['area']
        filas.append([
            area.id,
            area.name,
            area.description or '',
            stat['assigned_users'],
            stat['total_tasks'],
            stat['completed_tasks'],
            stat['pending_tasks'],
            stat['in_progress_tasks'],
            stat['overdue_tasks'],
            stat['total_files'],
            round((stat['total_size'] or 0) / (1024 * 1024), 2),
            stat['completion_rate'],
            'Activa' if area.is_active else 'Inactiva',
        ])
    return _responder_excel(
        'Reporte de áreas',
        ['ID', 'Área', 'Descripción', 'Usuarios', 'Tareas', 'Completadas',
         'Pendientes', 'En progreso', 'Vencidas', 'Archivos', 'Tamaño (MB)',
         'Avance (%)', 'Estado'],
        filas,
        'areas',
    )


@reports_bp.route('/export/files/xlsx')
@login_required
@admin_required
def exportar_archivos():
    """Descarga el reporte de archivos en Excel."""
    filas = []
    for archivo in _archivos_filtrados():
        filas.append([
            archivo.id,
            archivo.original_filename,
            archivo.file_type or '',
            archivo.get_file_size_mb(),
            archivo.task.area.name if archivo.task and archivo.task.area else '',
            archivo.task.title if archivo.task else '',
            archivo.uploader.username if archivo.uploader else '',
            archivo.uploaded_at.strftime('%d/%m/%Y %H:%M') if archivo.uploaded_at else '',
        ])
    return _responder_excel(
        'Reporte de archivos',
        ['ID', 'Nombre', 'Tipo', 'Tamaño (MB)', 'Área', 'Tarea', 'Subido por', 'Fecha'],
        filas,
        'archivos',
    )


@reports_bp.route('/export/tasks/csv')
@login_required
@admin_required
def export_tasks_csv():
    return exportar_tareas()


@reports_bp.route('/export/users/csv')
@login_required
@admin_required
def export_users_csv():
    return exportar_usuarios()


def _tareas_filtradas():
    area_id = request.args.get('area_id', type=int)
    user_id = request.args.get('user_id', type=int)
    status = request.args.get('status', '')
    priority = request.args.get('priority', '')
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    consulta = Task.query
    if area_id:
        consulta = consulta.filter(Task.area_id == area_id)
    if user_id:
        consulta = consulta.filter(Task.assigned_to == user_id)
    if status:
        consulta = consulta.filter(Task.status == status)
    if priority:
        consulta = consulta.filter(Task.priority == priority)
    if date_from:
        try:
            consulta = consulta.filter(Task.created_at >= datetime.strptime(date_from, '%Y-%m-%d'))
        except ValueError:
            pass
    if date_to:
        try:
            limite = datetime.strptime(date_to, '%Y-%m-%d') + timedelta(days=1)
            consulta = consulta.filter(Task.created_at < limite)
        except ValueError:
            pass
    return consulta.order_by(Task.created_at.desc()).all()


def _usuarios_filtrados():
    area_id = request.args.get('area_id', type=int)
    role = request.args.get('role', '')
    status = request.args.get('status', '')
    consulta = User.query
    if status == 'inactive':
        consulta = consulta.filter(User.is_active.is_(False))
    elif status == 'active':
        consulta = consulta.filter(User.is_active.is_(True))
    if role:
        consulta = consulta.filter(User.role == role)
    if area_id:
        consulta = consulta.filter(User.area_assignments.any(area_id=area_id))
    return consulta.order_by(User.created_at.desc()).all()


def _estadistica_usuario(usuario):
    asignadas = Task.query.filter(Task.assigned_to == usuario.id).all()
    completadas = len([tarea for tarea in asignadas if tarea.status == 'completada'])
    return {
        'assigned_tasks': len(asignadas),
        'completed_tasks': completadas,
        'uploaded_files': File.query.filter(File.uploaded_by == usuario.id).count(),
        'assigned_areas': len(usuario.area_assignments),
        'completion_rate': round((completadas / len(asignadas)) * 100, 1) if asignadas else 0,
    }


def _estadisticas_areas():
    resumen = []
    for area in Area.query.filter_by(is_active=True).all():
        tareas = Task.query.filter(Task.area_id == area.id).all()
        completadas = len([tarea for tarea in tareas if tarea.status == 'completada'])
        archivos = File.query.join(Task).filter(Task.area_id == area.id).all()
        resumen.append({
            'area': area,
            'total_tasks': len(tareas),
            'completed_tasks': completadas,
            'pending_tasks': len([tarea for tarea in tareas if tarea.status == 'pendiente']),
            'in_progress_tasks': len([tarea for tarea in tareas if tarea.status == 'en_progreso']),
            'overdue_tasks': len([tarea for tarea in tareas if tarea.is_overdue()]),
            'total_files': len(archivos),
            'total_size': sum(archivo.file_size or 0 for archivo in archivos),
            'assigned_users': len(area.user_assignments),
            'completion_rate': round((completadas / len(tareas)) * 100, 1) if tareas else 0,
        })
    return resumen


def _archivos_filtrados():
    area_id = request.args.get('area_id', type=int)
    file_type = request.args.get('file_type', '')
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    consulta = File.query.join(Task).join(Area)
    if area_id:
        consulta = consulta.filter(Task.area_id == area_id)
    if file_type:
        consulta = consulta.filter(File.file_type.like(f'%{file_type}%'))
    if date_from:
        try:
            consulta = consulta.filter(File.uploaded_at >= datetime.strptime(date_from, '%Y-%m-%d'))
        except ValueError:
            pass
    if date_to:
        try:
            limite = datetime.strptime(date_to, '%Y-%m-%d') + timedelta(days=1)
            consulta = consulta.filter(File.uploaded_at < limite)
        except ValueError:
            pass
    return consulta.order_by(File.uploaded_at.desc()).all()
