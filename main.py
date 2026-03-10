import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
# from flask_migrate import Migrate  # Comentado temporalmente
from flask_login import LoginManager
from flask_mail import Mail
from dotenv import load_dotenv
from apscheduler.schedulers.background import BackgroundScheduler

# Cargar variables de entorno
load_dotenv()

# Inicializar Flask
app = Flask(__name__, 
           template_folder='app/templates',
           static_folder='app/static',
           static_url_path='/static')

# Configuración de la aplicación
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'postgresql://postgres:password@localhost:5432/gestion_documental')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Configuración de email
EMAIL_SENDER = os.getenv('EMAIL_SENDER', "harvest.hero.app@gmail.com")
EMAIL_PASSWORD = os.getenv('EMAIL_PASSWORD', "bhyu xsdt vmyl pejo")

app.config['MAIL_SERVER'] = os.environ.get('MAIL_SERVER', 'smtp.gmail.com')
app.config['MAIL_PORT'] = int(os.environ.get('MAIL_PORT', 587))
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = EMAIL_SENDER
app.config['MAIL_PASSWORD'] = EMAIL_PASSWORD

# Inicializar extensiones
from app.config import db
# migrate = Migrate(app, db)  # Comentado temporalmente
login_manager = LoginManager()
mail = Mail()

# Inicializar extensiones con la app
db.init_app(app)
login_manager.init_app(app)
login_manager.login_view = 'auth.login'
login_manager.login_message = 'Por favor inicia sesión para acceder a esta página.'
mail.init_app(app)

# Importar modelos
from app.models.user import User
from app.models.area import Area, AreaUser
from app.models.task import Task
from app.models.file import File
from app.models.scheduled_task import ScheduledTask

# Importar todas las clases para que SQLAlchemy las registre
from app.models import user, area, task, file, scheduled_task

# Configurar user_loader para Flask-Login
@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# Registrar blueprints
from app.controllers.auth_controller import auth_bp
from app.controllers.admin_controller import admin_bp
from app.controllers.area_controller import area_bp
from app.controllers.task_controller import task_bp
from app.controllers.file_controller import file_bp
from app.controllers.files_repository_controller import files_repo_bp
from app.controllers.reports_controller import reports_bp
from app.controllers.scheduled_task_controller import scheduled_task_bp, process_scheduled_tasks

app.register_blueprint(auth_bp, url_prefix='/auth')
app.register_blueprint(admin_bp, url_prefix='/admin')
app.register_blueprint(area_bp, url_prefix='/areas')
app.register_blueprint(task_bp, url_prefix='/tasks')
app.register_blueprint(file_bp, url_prefix='/files')
app.register_blueprint(files_repo_bp, url_prefix='/files-repo')
app.register_blueprint(reports_bp, url_prefix='/reports')
app.register_blueprint(scheduled_task_bp, url_prefix='/scheduled-tasks')


def start_scheduler():
    """Inicia el scheduler en segundo plano para procesar tareas programadas."""
    scheduler = BackgroundScheduler(timezone='UTC')

    def _job():
        with app.app_context():
            process_scheduled_tasks()

    # Ejecutar cada minuto por defecto (configurable)
    interval_minutes = int(os.getenv('SCHEDULED_TASKS_INTERVAL_MINUTES', '1'))
    scheduler.add_job(_job, 'interval', minutes=interval_minutes, id='scheduled_tasks_runner', replace_existing=True)
    scheduler.start()

# Ruta principal
@app.route('/')
def index():
    from flask import redirect, url_for
    return redirect(url_for('auth.login'))

# Función para inicializar la base de datos
def init_db():
    """Inicializar la base de datos con datos básicos"""
    with app.app_context():
        try:
            # Crear tablas si no existen
            print("📊 Verificando y creando tablas (si faltan)...")
            db.create_all()
            print("✅ Tablas listas")

            # Crear usuario admin por defecto si no existe
            admin_user = User.query.filter_by(username='Admin').first()
            if not admin_user:
                print("👤 Creando usuario administrador por defecto...")
                admin_user = User(
                    username='Admin',
                    email='david.herrera@tessacorporation.com',
                    role='admin',
                    is_active=True
                )
                admin_user.set_password('uml57vli60')
                db.session.add(admin_user)
                db.session.commit()
                print("✅ Usuario admin creado: Admin / uml57vli60")
            else:
                print("ℹ️ Usuario admin ya existe, se omite creación")
            
            print("✅ Base de datos inicializada correctamente")
            print("🚀 La aplicación está lista para usar")
            print("📝 Puedes crear áreas y usuarios desde el dashboard del administrador")
            
        except Exception as e:
            print(f"❌ Error al inicializar la base de datos: {e}")
            db.session.rollback()
            raise

if __name__ == '__main__':
    # Ejecutar init solo si variable RUN_DB_INIT=true
    if os.getenv('RUN_DB_INIT', 'false').lower() == 'true':
        init_db()
    # Iniciar scheduler de tareas programadas si está habilitado
    if os.getenv('RUN_SCHEDULER', 'true').lower() == 'true':
        # Evitar doble scheduler con el reloader de Flask
        if os.environ.get('WERKZEUG_RUN_MAIN') == 'true' or not app.debug:
            start_scheduler()
    app.run(host='0.0.0.0', port=3110, debug=True)
