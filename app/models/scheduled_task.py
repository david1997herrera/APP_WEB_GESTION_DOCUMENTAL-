from datetime import datetime, time
from app.config import db


class ScheduledTask(db.Model):
    __tablename__ = 'scheduled_tasks'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)

    area_id = db.Column(db.Integer, db.ForeignKey('areas.id'), nullable=False)
    created_by = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # Tipo de frecuencia: diaria, semanal, mensual, personalizada
    frequency = db.Column(
        db.String(20),
        nullable=False,
        default='diaria'
    )  # diaria, semanal, mensual, personalizada

    # Cada cuántas unidades de frecuencia se repite (por ejemplo, cada 2 semanas)
    interval = db.Column(db.Integer, nullable=False, default=1)
    # Prioridad: baja, media, alta
    priority = db.Column(db.String(10), nullable=False, default='media')

    # Fecha desde la que se empieza a generar
    start_date = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    # Hora del día para ejecutar la tarea (opcional)
    run_time = db.Column(db.Time, nullable=True)
    end_date = db.Column(db.DateTime, nullable=True)

    # Siguiente fecha de ejecución sugerida (para futuros automatismos)
    next_run_at = db.Column(db.DateTime, nullable=True)

    is_active = db.Column(db.Boolean, default=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relaciones
    area = db.relationship('Area', backref='scheduled_tasks', lazy=True)
    creator = db.relationship('User', backref='created_scheduled_tasks', lazy=True)
    # Tareas generadas a partir de esta programación
    generated_tasks = db.relationship('Task', backref='scheduled_task', lazy=True)
    assigned_users = db.relationship(
        'User',
        secondary='scheduled_task_users',
        backref='scheduled_tasks',
        lazy='subquery'
    )

    def get_frequency_display(self):
        mapping = {
            'diaria': 'Diaria',
            'semanal': 'Semanal',
            'mensual': 'Mensual',
            'personalizada': 'Personalizada',
        }
        return mapping.get(self.frequency, self.frequency.title())

    def __repr__(self):
        return f'<ScheduledTask {self.title}>'


class ScheduledTaskUser(db.Model):
    __tablename__ = 'scheduled_task_users'

    id = db.Column(db.Integer, primary_key=True)
    scheduled_task_id = db.Column(db.Integer, db.ForeignKey('scheduled_tasks.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    assigned_at = db.Column(db.DateTime, default=datetime.utcnow)

    __table_args__ = (db.UniqueConstraint('scheduled_task_id', 'user_id', name='uq_scheduled_task_user'),)

