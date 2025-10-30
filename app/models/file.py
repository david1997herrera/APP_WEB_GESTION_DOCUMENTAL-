from datetime import datetime
import os
from app.config import db

class File(db.Model):
    __tablename__ = 'files'
    
    id = db.Column(db.Integer, primary_key=True)
    filename = db.Column(db.String(255), nullable=False)
    original_filename = db.Column(db.String(255), nullable=False)
    file_path = db.Column(db.String(500), nullable=False)
    file_size = db.Column(db.Integer, nullable=False)  # Tamaño en bytes
    file_type = db.Column(db.String(100), nullable=False)  # MIME type
    task_id = db.Column(db.Integer, db.ForeignKey('tasks.id'), nullable=True)
    uploaded_by = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    uploaded_at = db.Column(db.DateTime, default=datetime.utcnow)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    is_active = db.Column(db.Boolean, default=True)
    
    # Relaciones
    task = db.relationship('Task', foreign_keys=[task_id])
    uploader = db.relationship('User', foreign_keys=[uploaded_by])
    
    def get_file_size_mb(self):
        """Obtener tamaño del archivo en MB"""
        return round(self.file_size / (1024 * 1024), 2)
    
    def get_file_extension(self):
        """Obtener extensión del archivo"""
        return os.path.splitext(self.original_filename)[1].lower()
    
    def is_image(self):
        """Verificar si es una imagen"""
        image_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp']
        return self.get_file_extension() in image_extensions
    
    def is_document(self):
        """Verificar si es un documento"""
        doc_extensions = ['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.txt']
        return self.get_file_extension() in doc_extensions
    
    def get_icon_class(self):
        """Obtener clase de icono según el tipo de archivo"""
        ext = self.get_file_extension()
        icon_map = {
            '.pdf': 'fas fa-file-pdf text-danger',
            '.doc': 'fas fa-file-word text-primary',
            '.docx': 'fas fa-file-word text-primary',
            '.xls': 'fas fa-file-excel text-success',
            '.xlsx': 'fas fa-file-excel text-success',
            '.ppt': 'fas fa-file-powerpoint text-warning',
            '.pptx': 'fas fa-file-powerpoint text-warning',
            '.txt': 'fas fa-file-alt text-secondary',
            '.jpg': 'fas fa-file-image text-info',
            '.jpeg': 'fas fa-file-image text-info',
            '.png': 'fas fa-file-image text-info',
            '.gif': 'fas fa-file-image text-info',
            '.zip': 'fas fa-file-archive text-dark',
            '.rar': 'fas fa-file-archive text-dark'
        }
        return icon_map.get(ext, 'fas fa-file text-secondary')
    
    def delete_file(self):
        """Eliminar archivo físico del sistema"""
        try:
            if os.path.exists(self.file_path):
                os.remove(self.file_path)
                return True
        except Exception as e:
            print(f"Error eliminando archivo {self.file_path}: {e}")
        return False
    
    def __repr__(self):
        return f'<File {self.original_filename}>'
