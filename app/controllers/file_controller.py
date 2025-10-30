from flask import Blueprint, render_template, request, redirect, url_for, flash, send_file, jsonify
from flask_login import login_required, current_user
from werkzeug.utils import secure_filename
from app.models.file import File
from app.models.task import Task
from app.config import db
import os
import uuid
from datetime import datetime

file_bp = Blueprint('file', __name__)

# Configuración de archivos permitidos
ALLOWED_EXTENSIONS = {
    'txt', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx',
    'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp',
    'zip', 'rar', '7z'
}

def allowed_file(filename):
    """Verificar si el archivo tiene una extensión permitida"""
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

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

@file_bp.route('/upload/<int:task_id>', methods=['POST'])
@login_required
def upload(task_id):
    """Subir archivo a una tarea"""
    task = Task.query.get_or_404(task_id)
    
    # Verificar permisos de subida
    if not current_user.can_upload_files():
        flash('No tienes permisos para subir archivos', 'error')
        return redirect(url_for('task.my_tasks'))
    
    # Verificar acceso al área
    if not current_user.is_admin():
        user_areas = [assignment.area_id for assignment in current_user.area_assignments]
        if task.area_id not in user_areas:
            flash('No tienes permisos para subir archivos a esta tarea', 'error')
            return redirect(url_for('task.my_tasks'))

    # Bloquear subida si ya se alcanzó el número de archivos requeridos
    if task.required_files > 0 and task.uploaded_files >= task.required_files:
        flash('Ya se ha alcanzado el número máximo de archivos requeridos para esta tarea.', 'warning')
        return redirect(url_for('task.view', task_id=task_id))
    
    if 'file' not in request.files:
        flash('No se seleccionó ningún archivo', 'error')
        return redirect(url_for('task.view', task_id=task_id))
    
    file = request.files['file']
    
    if file.filename == '':
        flash('No se seleccionó ningún archivo', 'error')
        return redirect(url_for('task.view', task_id=task_id))
    
    if file and allowed_file(file.filename):
        # Generar nombre único para el archivo
        filename = secure_filename(file.filename)
        unique_filename = f"{uuid.uuid4()}_{filename}"
        
        # Crear directorio si no existe
        upload_dir = os.path.join('uploads', 'tasks', str(task_id))
        os.makedirs(upload_dir, exist_ok=True)
        
        file_path = os.path.join(upload_dir, unique_filename)
        file.save(file_path)
        
        # Obtener información del archivo
        file_size = os.path.getsize(file_path)
        file_type = file.content_type or 'application/octet-stream'
        
        # Crear registro en la base de datos
        file_record = File(
            filename=unique_filename,
            original_filename=filename,
            file_path=file_path,
            file_size=file_size,
            file_type=file_type,
            task_id=task_id,
            uploaded_by=current_user.id
        )
        
        try:
            db.session.add(file_record)
            db.session.commit()
            
            # Actualizar contador de archivos de la tarea
            task.update_file_count()
            
            # Notificar al admin sobre la subida del archivo
            from app.services.email_service import EmailService
            EmailService.notify_file_uploaded(task_id, current_user.id, filename)
            
            flash(f'Archivo "{filename}" subido exitosamente', 'success')
        except Exception as e:
            db.session.rollback()
            # Eliminar archivo físico si hay error en la BD
            if os.path.exists(file_path):
                os.remove(file_path)
            flash('Error al guardar el archivo', 'error')
    else:
        flash('Tipo de archivo no permitido', 'error')
    
    return redirect(url_for('task.view', task_id=task_id))

@file_bp.route('/download/<int:file_id>')
@login_required
def download(file_id):
    """Descargar archivo"""
    file_record = File.query.get_or_404(file_id)
    
    # Verificar permisos de descarga
    if not current_user.can_download_files():
        flash('No tienes permisos para descargar archivos', 'error')
        return redirect(url_for('task.my_tasks'))
    
    # Verificar acceso al área
    if not current_user.is_admin():
        user_areas = [assignment.area_id for assignment in current_user.area_assignments]
        if file_record.task and file_record.task.area_id not in user_areas:
            flash('No tienes permisos para descargar este archivo', 'error')
            return redirect(url_for('task.my_tasks'))
    
    if not os.path.exists(file_record.path):
        flash('El archivo no existe en el servidor', 'error')
        return redirect(url_for('admin.dashboard'))
    
    return send_file(
        file_record.path,
        as_attachment=True,
        download_name=file_record.original_filename,
        mimetype=file_record.file_type
    )

@file_bp.route('/delete/<int:file_id>', methods=['POST'])
@login_required
def delete(file_id):
    """Eliminar archivo"""
    file_record = File.query.get_or_404(file_id)
    task_id = file_record.task_id
    
    # Verificar permisos de eliminación (solo admin y edición)
    if not current_user.is_admin() and not current_user.can_edit():
        flash('No tienes permisos para eliminar archivos', 'error')
        return redirect(url_for('task.my_tasks'))
    
    # Verificar acceso al área
    if not current_user.is_admin():
        user_areas = [assignment.area_id for assignment in current_user.area_assignments]
        if file_record.task and file_record.task.area_id not in user_areas:
            flash('No tienes permisos para eliminar este archivo', 'error')
            return redirect(url_for('task.my_tasks'))
    
    try:
        # Eliminar archivo físico
        if os.path.exists(file_record.path):
            os.remove(file_record.path)
        
        # Eliminar registro de la base de datos
        db.session.delete(file_record)
        db.session.commit()
        
        # Actualizar contador de archivos de la tarea
        if task_id:
            task = Task.query.get(task_id)
            if task:
                task.update_file_count()
        
        flash('Archivo eliminado exitosamente', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Error al eliminar el archivo', 'error')
    
    if task_id:
        return redirect(url_for('task.view', task_id=task_id))
    else:
        return redirect(url_for('admin.dashboard'))

@file_bp.route('/view/<int:file_id>')
@login_required
def view(file_id):
    """Ver información del archivo"""
    file_record = File.query.get_or_404(file_id)
    
    # Verificar permisos de visualización
    if not current_user.can_download_files():
        flash('No tienes permisos para ver este archivo', 'error')
        return redirect(url_for('task.my_tasks'))
    
    # Verificar acceso al área
    if not current_user.is_admin():
        user_areas = [assignment.area_id for assignment in current_user.area_assignments]
        if file_record.task and file_record.task.area_id not in user_areas:
            flash('No tienes permisos para ver este archivo', 'error')
            return redirect(url_for('task.my_tasks'))
    
    return render_template('file/view.html', file_record=file_record)
