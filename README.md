# Sistema de Gestión Documental

Una aplicación web moderna para la gestión de documentos y tareas, desarrollada con Flask, Bootstrap y PostgreSQL, ejecutándose en Docker.

## 🚀 Características

- **Dashboard Administrativo**: Vista general con estadísticas y métricas
- **Gestión de Usuarios**: Creación y administración de usuarios con roles
- **Gestión de Áreas**: Organización por departamentos o secciones
- **Sistema de Tareas**: Asignación y seguimiento de tareas con archivos
- **Seguimiento de Progreso**: Barra de progreso basada en archivos subidos
- **Sistema de Roles**: Admin, Escritura y Lectura
- **Subida de Archivos**: Soporte para múltiples tipos de archivos
- **Notificaciones por Email**: Configurado con Gmail

## 🛠️ Tecnologías

- **Backend**: Flask (Python)
- **Frontend**: HTML5, Bootstrap 5, JavaScript
- **Base de Datos**: PostgreSQL
- **Contenedorización**: Docker & Docker Compose
- **Autenticación**: Flask-Login
- **Email**: Flask-Mail con Gmail

## 📋 Requisitos

- Docker
- Docker Compose
- Puerto 3110 disponible

## 🚀 Instalación y Ejecución

1. **Clonar el repositorio**:
   ```bash
   git clone <repository-url>
   cd APP_WEB_GESTION_DOCUMENTAL
   ```

2. **Ejecutar con Docker Compose**:
   ```bash
   docker-compose up --build
   ```

3. **Acceder a la aplicación**:
   - URL: http://localhost:3110
   - Usuario admin: `Admin`
   - Contraseña: `uml57vli60`

## 📁 Estructura del Proyecto

```
APP_WEB_GESTION_DOCUMENTAL/
├── app/
│   ├── controllers/          # Controladores (Microservicios)
│   │   ├── admin_controller.py
│   │   ├── area_controller.py
│   │   ├── auth_controller.py
│   │   ├── file_controller.py
│   │   └── task_controller.py
│   ├── models/              # Modelos de datos
│   │   ├── user.py
│   │   ├── area.py
│   │   ├── task.py
│   │   └── file.py
│   ├── templates/           # Plantillas HTML
│   │   ├── layouts/
│   │   ├── auth/
│   │   ├── admin/
│   │   ├── area/
│   │   └── task/
│   ├── static/              # Archivos estáticos
│   │   ├── css/
│   │   └── js/
│   └── uploads/             # Archivos subidos
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
└── app.py
```

## 👥 Roles de Usuario

### Administrador
- Crear y gestionar usuarios
- Crear y gestionar áreas
- Asignar usuarios a áreas
- Crear y gestionar tareas
- Ver reportes y estadísticas
- Acceso completo al sistema

### Escritura
- Ver tareas asignadas
- Subir archivos a tareas
- Actualizar estado de tareas
- Acceso limitado según área asignada

### Lectura
- Ver tareas asignadas
- Descargar archivos
- Solo lectura, sin permisos de edición

## 🔧 Configuración

### Variables de Entorno

El sistema utiliza las siguientes variables de entorno:

```env
FLASK_ENV=development
DATABASE_URL=postgresql://postgres:password@db:5432/gestion_documental
EMAIL_SENDER=estadisticatessa@gmail.com
EMAIL_PASSWORD=rxcd epqr gebp myhj
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=True
SECRET_KEY=your-secret-key-here
```

### Base de Datos

La aplicación se conecta automáticamente a PostgreSQL y crea las tablas necesarias al iniciar.

## 📊 Funcionalidades Principales

### Dashboard
- Estadísticas generales (usuarios, áreas, tareas)
- Vista de áreas con métricas
- Tareas recientes
- Usuarios recientes

### Gestión de Áreas
- Crear, editar y eliminar áreas
- Asignar usuarios a áreas
- Ver estadísticas por área

### Gestión de Tareas
- Crear tareas con archivos requeridos
- Asignar tareas a usuarios
- Seguimiento de progreso
- Estados: Pendiente, En Progreso, Completada

### Gestión de Archivos
- Subida de múltiples tipos de archivos
- Descarga segura
- Seguimiento de progreso basado en archivos

## 🔒 Seguridad

- Autenticación con Flask-Login
- Contraseñas hasheadas con Werkzeug
- Validación de permisos por rol
- Protección CSRF en formularios
- Validación de tipos de archivos

## 📱 Responsive Design

La aplicación está completamente optimizada para dispositivos móviles y tablets usando Bootstrap 5.

## 🐳 Docker

### Comandos Útiles

```bash
# Construir y ejecutar
docker-compose up --build

# Ejecutar en segundo plano
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener servicios
docker-compose down

# Reconstruir sin caché
docker-compose build --no-cache
```

## 📧 Notificaciones

El sistema está configurado para enviar notificaciones por email usando Gmail SMTP. Las credenciales están configuradas en las variables de entorno.

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Soporte

Para soporte técnico o preguntas, contactar a:
- Email: david.herrera@tessacorporation.com
- Usuario admin: Admin / uml57vli60

---

**Desarrollado con ❤️ para la gestión eficiente de documentos y tareas**
