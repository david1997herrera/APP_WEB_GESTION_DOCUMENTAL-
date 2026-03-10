from datetime import datetime
from app.config import db

class Task(db.Model):
    __tablename__ = 'tasks'
    
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    area_id = db.Column(db.Integer, db.ForeignKey('areas.id'), nullable=False)
    created_by = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    assigned_to = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    status = db.Column(db.String(20), default='pendiente')  # pendiente, en_progreso, completada
    priority = db.Column(db.String(10), default='media')  # baja, media, alta
    required_files = db.Column(db.Integer, default=0)  # Cantidad de archivos requeridos
    uploaded_files = db.Column(db.Integer, default=0)  # Cantidad de archivos subidos
    due_date = db.Column(db.DateTime, nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    completed_at = db.Column(db.DateTime, nullable=True)
    # Origen: tarea programada (opcional)
    scheduled_task_id = db.Column(db.Integer, db.ForeignKey('scheduled_tasks.id'), nullable=True)
    
    # Relaciones
    files = db.relationship('File', lazy=True, cascade='all, delete-orphan', overlaps="files")
    # Relación con usuarios (creador y asignado)
    creator = db.relationship('User', foreign_keys=[created_by], backref='created_tasks', lazy=True)
    assignee = db.relationship('User', foreign_keys=[assigned_to], backref='assigned_tasks', lazy=True)
    
    def get_progress_percentage(self):
        """Calcular porcentaje de progreso basado en archivos subidos"""
        if self.required_files == 0:
            return 0
        return min(100, int((self.uploaded_files / self.required_files) * 100))
    
    def get_display_uploaded_files(self):
        """Devuelve el número de archivos subidos, limitado por required_files"""
        return min(self.uploaded_files, self.required_files)
    
    def is_overdue(self):
        """Verificar si la tarea está vencida"""
        if not self.due_date:
            return False
        return datetime.utcnow() > self.due_date and self.status != 'completada'
    
    def get_overdue_days(self):
        """Obtener días de retraso"""
        if not self.due_date or not self.is_overdue():
            return 0
        return (datetime.utcnow() - self.due_date).days
    
    def update_file_count(self):
        """Actualizar contador de archivos subidos"""
        self.uploaded_files = len(self.files)
        if self.uploaded_files >= self.required_files and self.status != 'completada':
            self.status = 'completada'
            self.completed_at = datetime.utcnow()
        elif self.uploaded_files > 0 and self.status == 'pendiente':
            self.status = 'en_progreso'
        db.session.commit()
    
    def get_limited_uploaded_count(self):
        """Devuelve el conteo mostrado de archivos subidos limitado al requerido.
        Evita mostrar '3 de 2' cuando se han cargado más archivos de los requeridos.
        """
        if self.required_files is None:
            return self.uploaded_files
        return min(self.uploaded_files, self.required_files)
    
    def get_status_badge_class(self):
        """Obtener clase CSS para el badge de estado"""
        status_classes = {
            'pendiente': 'badge-secondary',
            'en_progreso': 'badge-warning',
            'completada': 'badge-success'
        }
        return status_classes.get(self.status, 'badge-secondary')
    
    def get_priority_badge_class(self):
        """Obtener clase CSS para el badge de prioridad"""
        priority_classes = {
            # Usar clases Bootstrap 5 (bg-*)
            'baja': 'bg-info',
            'media': 'bg-primary',
            'alta': 'bg-danger'
        }
        return priority_classes.get(self.priority, 'badge-primary')
    
    def __repr__(self):
        return f'<Task {self.title}>'
