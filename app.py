import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
# from flask_migrate import Migrate  # Comentado temporalmente
from flask_login import LoginManager
from flask_mail import Mail
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

# Inicializar Flask
app = Flask(__name__)

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
db = SQLAlchemy(app)
# migrate = Migrate(app, db)  # Comentado temporalmente
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'auth.login'
login_manager.login_message = 'Por favor inicia sesión para acceder a esta página.'
mail = Mail(app)

# Importar modelos
from app.models.user import User
from app.models.area import Area, AreaUser
from app.models.task import Task
from app.models.file import File

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

app.register_blueprint(auth_bp, url_prefix='/auth')
app.register_blueprint(admin_bp, url_prefix='/admin')
app.register_blueprint(area_bp, url_prefix='/areas')
app.register_blueprint(task_bp, url_prefix='/tasks')
app.register_blueprint(file_bp, url_prefix='/files')

# Ruta principal
@app.route('/')
def index():
    from flask import redirect, url_for
    return redirect(url_for('auth.login'))

# Función para inicializar la base de datos
def init_db():
    """Inicializar la base de datos con datos básicos"""
    with app.app_context():
        db.create_all()
        
        # Crear usuario admin por defecto
        admin_user = User.query.filter_by(username='Admin').first()
        if not admin_user:
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
            print("✅ Usuario admin ya existe")
        
        # Crear algunas áreas de ejemplo
        areas_data = [
            {'name': 'Sanidad Vegetal', 'description': 'Gestión de documentos de sanidad vegetal y fumigaciones'},
            {'name': 'Recursos Humanos', 'description': 'Gestión de personal y documentación laboral'},
            {'name': 'Contabilidad', 'description': 'Documentos financieros y contables'},
            {'name': 'Ventas', 'description': 'Documentación comercial y de ventas'},
            {'name': 'Producción', 'description': 'Documentos de procesos productivos'}
        ]
        
        for area_data in areas_data:
            existing_area = Area.query.filter_by(name=area_data['name']).first()
            if not existing_area:
                area = Area(
                    name=area_data['name'],
                    description=area_data['description'],
                    is_active=True
                )
                db.session.add(area)
                print(f"✅ Área creada: {area_data['name']}")
        
        db.session.commit()
        print("✅ Base de datos inicializada correctamente")

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=3110, debug=True)
