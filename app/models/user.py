from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import UserMixin
from datetime import datetime
from app.config import db

class User(UserMixin, db.Model):
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128))
    role = db.Column(db.String(20), nullable=False, default='lectura')  # admin, escritura, lectura
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relaciones (comentadas temporalmente para evitar problemas de importación circular)
    # area_assignments = db.relationship('AreaUser', backref='user', lazy=True, cascade='all, delete-orphan')
    # created_tasks = db.relationship('Task', foreign_keys='Task.created_by', backref='creator', lazy=True)
    # assigned_tasks = db.relationship('Task', foreign_keys='Task.assigned_to', backref='assignee', lazy=True)
    # uploaded_files = db.relationship('File', backref='uploader', lazy=True)
    
    def set_password(self, password):
        """Establecer contraseña hasheada"""
        self.password_hash = generate_password_hash(password)
    
    def check_password(self, password):
        """Verificar contraseña"""
        return check_password_hash(self.password_hash, password)
    
    def is_admin(self):
        """Verificar si es administrador"""
        return self.role == 'admin'
    
    def can_write(self):
        """Verificar si puede escribir"""
        return self.role in ['admin', 'escritura']
    
    def can_read(self):
        """Verificar si puede leer"""
        return self.role in ['admin', 'escritura', 'lectura']
    
    def can_edit(self):
        """Verificar si puede editar"""
        return self.role in ['admin', 'edicion']
    
    def can_upload_files(self):
        """Verificar si puede subir archivos"""
        return self.role in ['admin', 'escritura', 'edicion']
    
    def can_download_files(self):
        """Verificar si puede descargar archivos"""
        return self.role in ['admin', 'escritura', 'edicion', 'lectura']
    
    def get_areas(self):
        """Obtener áreas asignadas al usuario"""
        return [assignment.area for assignment in self.area_assignments]
    
    def __repr__(self):
        return f'<User {self.username}>'
