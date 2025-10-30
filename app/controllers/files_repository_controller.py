from flask import Blueprint, render_template, request, redirect, url_for, flash, send_file, jsonify
from flask_login import login_required, current_user
from app.models.file import File
from app.models.task import Task
from app.models.area import Area
from app.models.user import User
from app.config import db
from datetime import datetime, timedelta
import os

files_repo_bp = Blueprint('files_repo', __name__)

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

@files_repo_bp.route('/')
@login_required
@admin_required
def index():
    """Repositorio principal de archivos"""
    # Obtener parámetros de filtro
    area_id = request.args.get('area_id', type=int)
    user_id = request.args.get('user_id', type=int)
    file_type = request.args.get('file_type', '')
    date_from = request.args.get('date_from', '')
    date_to = request.args.get('date_to', '')
    search = request.args.get('search', '')
    
    # Construir consulta base
    query = File.query.join(Task).join(Area)
    
    # Aplicar filtros
    if area_id:
        query = query.filter(Task.area_id == area_id)
    
    if user_id:
        query = query.filter(File.uploaded_by == user_id)
    
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
            # Agregar un día para incluir todo el día
            date_to_obj = date_to_obj + timedelta(days=1)
            query = query.filter(File.uploaded_at < date_to_obj)
        except ValueError:
            pass
    
    if search:
        query = query.filter(
            File.original_filename.ilike(f'%{search}%')
        )
    
    # Ordenar por fecha de creación (más recientes primero)
    files = query.order_by(File.uploaded_at.desc()).all()
    
    # Obtener datos para filtros
    areas = Area.query.filter_by(is_active=True).all()
    users = User.query.filter_by(is_active=True).all()
    
    # Estadísticas generales
    total_files = File.query.count()
    total_size = sum(file.file_size for file in File.query.all())
    
    # Estadísticas por área
    area_stats = []
    for area in areas:
        area_files = File.query.join(Task).filter(Task.area_id == area.id).all()
        area_size = sum(file.file_size for file in area_files)
        area_stats.append({
            'area': area,
            'file_count': len(area_files),
            'total_size': area_size
        })
    
    return render_template('files_repository/index.html',
                         files=files,
                         areas=areas,
                         users=users,
                         area_stats=area_stats,
                         total_files=total_files,
                         total_size=total_size,
                         current_filters={
                             'area_id': area_id,
                             'user_id': user_id,
                             'file_type': file_type,
                             'date_from': date_from,
                             'date_to': date_to,
                             'search': search
                         })

@files_repo_bp.route('/area/<int:area_id>')
@login_required
@admin_required
def by_area(area_id):
    """Archivos por área específica"""
    area = Area.query.get_or_404(area_id)
    
    # Obtener archivos del área
    files = File.query.join(Task).filter(Task.area_id == area_id).order_by(File.uploaded_at.desc()).all()
    
    # Estadísticas del área
    total_size = sum(file.file_size for file in files)
    
    # Archivos por tipo
    file_types = {}
    for file in files:
        file_type = file.file_type.split('/')[0] if '/' in file.file_type else 'other'
        file_types[file_type] = file_types.get(file_type, 0) + 1
    
    return render_template('files_repository/by_area.html',
                         area=area,
                         files=files,
                         total_size=total_size,
                         file_types=file_types)

@files_repo_bp.route('/download/<int:file_id>')
@login_required
@admin_required
def download(file_id):
    """Descargar archivo desde el repositorio"""
    file_record = File.query.get_or_404(file_id)
    
    if not os.path.exists(file_record.path):
        flash('El archivo no existe en el servidor', 'error')
        return redirect(url_for('files_repo.index'))
    
    return send_file(
        file_record.path,
        as_attachment=True,
        download_name=file_record.original_filename,
        mimetype=file_record.file_type
    )

@files_repo_bp.route('/delete/<int:file_id>', methods=['POST'])
@login_required
@admin_required
def delete(file_id):
    """Eliminar archivo desde el repositorio"""
    file_record = File.query.get_or_404(file_id)
    
    try:
        # Eliminar archivo físico
        if os.path.exists(file_record.path):
            os.remove(file_record.path)
        
        # Eliminar registro de la base de datos
        db.session.delete(file_record)
        db.session.commit()
        
        # Actualizar contador de archivos de la tarea
        if file_record.task_id:
            task = Task.query.get(file_record.task_id)
            if task:
                task.update_file_count()
        
        flash('Archivo eliminado exitosamente', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Error al eliminar el archivo', 'error')
    
    return redirect(url_for('files_repo.index'))

@files_repo_bp.route('/bulk-download', methods=['POST'])
@login_required
@admin_required
def bulk_download():
    """Descargar múltiples archivos como ZIP"""
    file_ids = request.form.getlist('file_ids')
    
    if not file_ids:
        flash('No se seleccionaron archivos para descargar', 'warning')
        return redirect(url_for('files_repo.index'))
    
    # TODO: Implementar descarga masiva como ZIP
    flash('Funcionalidad de descarga masiva en desarrollo', 'info')
    return redirect(url_for('files_repo.index'))

@files_repo_bp.route('/bulk-delete', methods=['POST'])
@login_required
@admin_required
def bulk_delete():
    """Eliminar múltiples archivos"""
    file_ids = request.form.getlist('file_ids')
    
    if not file_ids:
        flash('No se seleccionaron archivos para eliminar', 'warning')
        return redirect(url_for('files_repo.index'))
    
    deleted_count = 0
    try:
        for file_id in file_ids:
            file_record = File.query.get(file_id)
            if file_record:
                # Eliminar archivo físico
                if os.path.exists(file_record.path):
                    os.remove(file_record.path)
                
                # Eliminar registro de la base de datos
                db.session.delete(file_record)
                deleted_count += 1
        
        db.session.commit()
        flash(f'{deleted_count} archivos eliminados exitosamente', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Error al eliminar algunos archivos', 'error')
    
    return redirect(url_for('files_repo.index'))

@files_repo_bp.route('/stats')
@login_required
@admin_required
def stats():
    """Estadísticas detalladas de archivos"""
    # Estadísticas generales
    total_files = File.query.count()
    total_size = sum(file.file_size for file in File.query.all())
    
    # Archivos por tipo
    file_types = {}
    for file in File.query.all():
        file_type = file.file_type.split('/')[0] if '/' in file.file_type else 'other'
        file_types[file_type] = file_types.get(file_type, 0) + 1
    
    # Archivos por área
    area_stats = []
    areas = Area.query.filter_by(is_active=True).all()
    for area in areas:
        area_files = File.query.join(Task).filter(Task.area_id == area.id).all()
        area_size = sum(file.file_size for file in area_files)
        area_stats.append({
            'area': area,
            'file_count': len(area_files),
            'total_size': area_size
        })
    
    # Archivos por usuario
    user_stats = []
    users = User.query.filter_by(is_active=True).all()
    for user in users:
        user_files = File.query.filter(File.uploaded_by == user.id).all()
        user_size = sum(file.file_size for file in user_files)
        user_stats.append({
            'user': user,
            'file_count': len(user_files),
            'total_size': user_size
        })
    
    # Archivos recientes (últimos 30 días)
    thirty_days_ago = datetime.utcnow() - timedelta(days=30)
    recent_files = File.query.filter(File.uploaded_at >= thirty_days_ago).count()
    
    return render_template('files_repository/stats.html',
                         total_files=total_files,
                         total_size=total_size,
                         file_types=file_types,
                         area_stats=area_stats,
                         user_stats=user_stats,
                         recent_files=recent_files)
