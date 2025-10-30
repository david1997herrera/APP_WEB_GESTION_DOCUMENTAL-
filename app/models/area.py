from datetime import datetime
from app.config import db

class Area(db.Model):
    __tablename__ = 'areas'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False, unique=True)
    description = db.Column(db.Text)
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relaciones
    user_assignments = db.relationship('AreaUser', backref='area', lazy=True, cascade='all, delete-orphan')
    tasks = db.relationship('Task', backref='area', lazy=True, cascade='all, delete-orphan')
    
    def get_users(self):
        """Obtener usuarios asignados al área"""
        return [assignment.user for assignment in self.user_assignments]
    
    def get_user_count(self):
        """Obtener cantidad de usuarios asignados"""
        return len(self.user_assignments)
    
    def get_task_count(self):
        """Obtener cantidad de tareas del área"""
        return len(self.tasks)
    
    def get_pending_tasks(self):
        """Obtener tareas pendientes del área"""
        return [task for task in self.tasks if task.status != 'completada']
    
    def get_pending_task_count(self):
        """Obtener cantidad de tareas pendientes"""
        return len(self.get_pending_tasks())
    
    def get_tasks_by_status(self, status):
        """Obtener tareas por estado específico"""
        return [task for task in self.tasks if task.status == status]
    
    def get_in_progress_task_count(self):
        """Obtener cantidad de tareas en progreso"""
        return len(self.get_tasks_by_status('en_progreso'))
    
    def get_completed_task_count(self):
        """Obtener cantidad de tareas completadas"""
        return len(self.get_tasks_by_status('completada'))
    
    def get_overdue_task_count(self):
        """Obtener cantidad de tareas vencidas"""
        from datetime import datetime
        return len([task for task in self.tasks if task.is_overdue()])
    
    def get_today_task_count(self):
        """Obtener cantidad de tareas que vencen hoy"""
        from datetime import datetime
        today = datetime.utcnow().date()
        return len([task for task in self.tasks 
                   if task.due_date and task.due_date.date() == today and task.status != 'completada'])
    
    def get_high_priority_task_count(self):
        """Obtener cantidad de tareas de alta prioridad"""
        return len([task for task in self.tasks if task.priority == 'alta' and task.status != 'completada'])
    
    def get_completion_rate(self):
        """Calcular tasa de finalización de tareas"""
        total_tasks = len(self.tasks)
        if total_tasks == 0:
            return 0
        completed = self.get_completed_task_count()
        return round((completed / total_tasks) * 100, 1)
    
    def __repr__(self):
        return f'<Area {self.name}>'

class AreaUser(db.Model):
    __tablename__ = 'area_users'
    
    id = db.Column(db.Integer, primary_key=True)
    area_id = db.Column(db.Integer, db.ForeignKey('areas.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    assigned_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relaciones
    user = db.relationship('User', backref='area_assignments')
    
    # Restricción única para evitar duplicados
    __table_args__ = (db.UniqueConstraint('area_id', 'user_id', name='unique_area_user'),)
    
    def __repr__(self):
        return f'<AreaUser {self.area.name} - {self.user.username}>'
