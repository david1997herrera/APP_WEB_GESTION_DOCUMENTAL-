from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify
from flask_login import login_required, current_user
from app.models.user import User
from app.models.area import Area, AreaUser
from app.models.task import Task
from app.models.file import File
from app.models.scheduled_task import ScheduledTask
from app.config import db
from app.controllers.scheduled_task_controller import (
    eliminar_programacion_completa,
    marcar_corrida_atendida,
)
from app.services.borrado_tareas import eliminar_tareas
from app.services.email_service import EmailService
from app.services.avisos_borrado import armar_aviso_borrado, enviar_aviso_borrado
from datetime import datetime, timedelta

from app.dominio.reloj import ahora_ecuador
from sqlalchemy import and_, or_

admin_bp = Blueprint('admin', __name__)


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

@admin_bp.route('/dashboard')
@login_required
@admin_required
def dashboard():
    """Dashboard principal del administrador"""
    # Obtener estadísticas generales
    total_users = User.query.count()
    total_areas = Area.query.count()
    total_tasks = Task.query.count()
    pending_tasks = Task.query.filter(Task.status != 'completada').count()
    
    # Tareas vencidas
    ahora = ahora_ecuador()
    overdue_tasks = Task.query.filter(
        Task.due_date < ahora,
        Task.status != 'completada'
    ).count()
    
    # Tareas de hoy
    today = ahora.replace(hour=0, minute=0, second=0, microsecond=0)
    tomorrow = today + timedelta(days=1)
    today_tasks = Task.query.filter(
        Task.due_date >= today,
        Task.due_date < tomorrow
    ).count()
    
    # Obtener áreas con información detallada
    areas = Area.query.filter_by(is_active=True).all()
    areas_data = []
    
    for area in areas:
        area_info = {
            'area': area,
            'user_count': area.get_user_count(),
            'task_count': area.get_task_count(),
            'pending_tasks': area.get_pending_task_count(),
            'in_progress_tasks': area.get_in_progress_task_count(),
            'completed_tasks': area.get_completed_task_count(),
            'overdue_tasks': area.get_overdue_task_count(),
            'today_tasks': area.get_today_task_count(),
            'high_priority_tasks': area.get_high_priority_task_count(),
        }
        
        areas_data.append(area_info)
    
    # Obtener tareas recientes
    recent_tasks = Task.query.order_by(Task.created_at.desc()).limit(5).all()
    
    # Obtener usuarios recientes
    recent_users = User.query.order_by(User.created_at.desc()).limit(5).all()
    
    return render_template('admin/dashboard.html',
                         total_users=total_users,
                         total_areas=total_areas,
                         total_tasks=total_tasks,
                         pending_tasks=pending_tasks,
                         overdue_tasks=overdue_tasks,
                         today_tasks=today_tasks,
                         areas_data=areas_data,
                         recent_tasks=recent_tasks,
                         recent_users=recent_users)

@admin_bp.route('/users')
@login_required
@admin_required
def users():
    """Gestión de usuarios"""
    users = User.query.order_by(User.created_at.desc()).all()
    return render_template('admin/users.html', users=users)

@admin_bp.route('/areas')
@login_required
@admin_required
def areas():
    """Gestión de áreas"""
    areas = Area.query.order_by(Area.created_at.desc()).all()
    return render_template('admin/areas.html', areas=areas)

_ETIQUETAS_PLAZO = (
    ('vencida', 'Vencida'),
    ('siete_dias', 'Vence en 7 días'),
    ('treinta_dias', 'Vence en 30 días'),
    ('mas_de_30', 'Más de 30 días'),
    ('fecha_pasada', 'Fecha ya pasada'),
    ('sin_fecha', 'Sin fecha límite'),
)


def _fecha_de_corrida(tarea):
    momento = tarea.corrida_en or tarea.created_at
    if not momento:
        return None
    return momento.date()


def _clave_plazo(tarea, hoy):
    """Agrupa la fecha límite para el filtro de duración."""
    if not tarea.due_date:
        return 'sin_fecha'
    fecha = tarea.due_date.date()
    if fecha < hoy:
        if tarea.status != 'completada':
            return 'vencida'
        return 'fecha_pasada'
    dias = (fecha - hoy).days
    if dias <= 7:
        return 'siete_dias'
    if dias <= 30:
        return 'treinta_dias'
    return 'mas_de_30'


def _opciones_de_catalogo(claves, catalogo):
    presentes = set(claves)
    return [
        {'valor': valor, 'etiqueta': etiqueta}
        for valor, etiqueta in catalogo
        if valor in presentes
    ]


def _opciones_usuario(nombres, hay_sin_asignar):
    opciones = []
    if hay_sin_asignar:
        opciones.append({'valor': '__sin_asignar__', 'etiqueta': 'Sin asignar'})
    opciones.extend(
        {'valor': nombre, 'etiqueta': nombre}
        for nombre in sorted(nombres, key=str.lower)
    )
    return opciones


def _filtros_de_normales(tareas, hoy):
    for tarea in tareas:
        tarea.clave_duracion = _clave_plazo(tarea, hoy)
        tarea.usuario_filtro = tarea.assignee.username if tarea.assignee else ''
    return {
        'nombres': sorted({tarea.title for tarea in tareas}, key=str.lower),
        'duraciones': _opciones_de_catalogo(
            [tarea.clave_duracion for tarea in tareas],
            _ETIQUETAS_PLAZO,
        ),
        'usuarios': _opciones_usuario(
            {tarea.usuario_filtro for tarea in tareas if tarea.usuario_filtro},
            any(not tarea.usuario_filtro for tarea in tareas),
        ),
    }


def _filtros_de_periodicas(programadas):
    for item in programadas:
        item['clave_duracion'] = f"{item['frecuencia']}, cada {item['intervalo']}"
        item['usuarios_filtro'] = '|'.join(item['asignados'])
    duraciones = sorted({item['clave_duracion'] for item in programadas}, key=str.lower)
    return {
        'nombres': sorted({item['titulo'] for item in programadas}, key=str.lower),
        'duraciones': [{'valor': texto, 'etiqueta': texto} for texto in duraciones],
        'usuarios': _opciones_usuario(
            {nombre for item in programadas for nombre in item['asignados']},
            any(not item['asignados'] for item in programadas),
        ),
    }


def _agrupar_tareas(tareas, hoy):
    """Separa tareas normales de las copias de una misma programacion."""
    normales = []
    grupos = {}
    for tarea in tareas:
        if not tarea.scheduled_task_id:
            normales.append(tarea)
            continue
        grupo = grupos.setdefault(tarea.scheduled_task_id, [])
        grupo.append(tarea)

    programadas = []
    if grupos:
        programaciones = {
            item.id: item
            for item in ScheduledTask.query.filter(ScheduledTask.id.in_(grupos.keys())).all()
        }
    else:
        programaciones = {}

    for programacion_id, copias in grupos.items():
        programacion = programaciones.get(programacion_id)
        fechas = [fecha for fecha in (_fecha_de_corrida(copia) for copia in copias) if fecha]
        if programacion and programacion.assigned_users:
            asignados = [usuario.username for usuario in programacion.assigned_users]
        else:
            asignados = sorted({copia.assignee.username for copia in copias if copia.assignee})
        programadas.append({
            'id': programacion_id,
            'titulo': programacion.title if programacion else copias[0].title,
            'area': copias[0].area.name if copias[0].area else 'Sin área',
            'asignados': asignados,
            'frecuencia': programacion.get_frequency_display() if programacion else 'Periódica',
            'intervalo': programacion.interval if programacion else 1,
            'activa': bool(programacion and programacion.is_active),
            'cantidad': len(copias),
            'copias_hoy': sum(1 for copia in copias if _fecha_de_corrida(copia) == hoy),
            'desde': min(fechas) if fechas else None,
            'hasta': max(fechas) if fechas else None,
            'proxima': programacion.next_run_at if programacion else None,
        })
    programadas.sort(key=lambda item: item['titulo'].lower())
    return normales, programadas


@admin_bp.route('/tasks')
@login_required
@admin_required
def tasks():
    """Gestión de tareas, con las periódicas agrupadas."""
    tareas = Task.query.order_by(Task.created_at.desc()).all()
    hoy = ahora_ecuador().date()
    normales, programadas = _agrupar_tareas(tareas, hoy)
    return render_template(
        'admin/tasks.html',
        tasks=normales,
        programadas=programadas,
        hoy=hoy,
        filtros_normales=_filtros_de_normales(normales, hoy),
        filtros_periodicas=_filtros_de_periodicas(programadas),
    )


@admin_bp.route('/tasks/programacion/<int:programacion_id>/eliminar', methods=['POST'])
@login_required
@admin_required
def eliminar_programacion_desde_listado(programacion_id):
    """Borra solo las copias de hoy, o la programacion completa."""
    alcance = request.form.get('alcance')
    programacion = ScheduledTask.query.get_or_404(programacion_id)
    hoy = ahora_ecuador().date()

    try:
        if alcance == 'hoy':
            inicio = datetime.combine(hoy, datetime.min.time())
            fin = inicio + timedelta(days=1)
            copias = Task.query.filter(
                Task.scheduled_task_id == programacion.id,
                or_(
                    and_(Task.corrida_en.isnot(None), Task.corrida_en >= inicio, Task.corrida_en < fin),
                    and_(Task.corrida_en.is_(None), Task.created_at >= inicio, Task.created_at < fin),
                ),
            ).all()
            if not copias:
                flash(
                    f'No hay copias del {hoy.strftime("%d/%m/%Y")} para «{programacion.title}». El historial sigue igual.',
                    'warning',
                )
                return redirect(url_for('admin.tasks'))
            aviso = armar_aviso_borrado(copias)
            eliminar_tareas(copias)
            marcar_corrida_atendida(programacion, inicio)
            db.session.commit()
            enviar_aviso_borrado(aviso)
            flash(
                f'Se eliminaron {len(copias)} copias del {hoy.strftime("%d/%m/%Y")}. La programación sigue activa.',
                'success',
            )
        elif alcance == 'toda':
            titulo = programacion.title
            generadas = Task.query.filter_by(scheduled_task_id=programacion.id).all()
            aviso = armar_aviso_borrado(generadas, [programacion])
            cantidad = eliminar_programacion_completa(programacion)
            db.session.commit()
            enviar_aviso_borrado(aviso)
            flash(
                f'Se eliminó «{titulo}» y sus {cantidad} tareas generadas. No volverá a crearse.',
                'success',
            )
        else:
            flash('Elija si desea borrar solo las de hoy o toda la programación.', 'error')
    except Exception:
        db.session.rollback()
        flash('No se pudo eliminar la programación.', 'error')

    return redirect(url_for('admin.tasks'))


def _unir_avisos(destino, parcial):
    for correo, titulos in (parcial or {}).items():
        acumulado = destino.setdefault(correo, [])
        for titulo in titulos:
            if titulo not in acumulado:
                acumulado.append(titulo)


def _ids_marcados(nombre_campo, limite=300):
    """Lee identificadores repetidos del formulario, sin duplicados."""
    identificadores = []
    for crudo in request.form.getlist(nombre_campo):
        if not str(crudo).isdigit():
            continue
        valor = int(crudo)
        if valor in identificadores:
            continue
        identificadores.append(valor)
        if len(identificadores) >= limite:
            break
    return identificadores


@admin_bp.route('/tasks/eliminar-varias', methods=['POST'])
@login_required
@admin_required
def eliminar_tareas_normales_varias():
    """Borra las tareas normales marcadas. No toca las periódicas."""
    identificadores = _ids_marcados('tarea_id')
    if not identificadores:
        flash('No hay tareas marcadas.', 'warning')
        return redirect(url_for('admin.tasks'))

    tareas = Task.query.filter(
        Task.id.in_(identificadores),
        Task.scheduled_task_id.is_(None),
    ).all()
    if not tareas:
        flash('Esas filas no se pueden borrar desde la lista de tareas normales.', 'warning')
        return redirect(url_for('admin.tasks'))

    try:
        aviso = armar_aviso_borrado(tareas)
        eliminar_tareas(tareas)
        db.session.commit()
        enviar_aviso_borrado(aviso)
        if len(tareas) == 1:
            flash('Se eliminó 1 tarea normal.', 'success')
        else:
            flash(f'Se eliminaron {len(tareas)} tareas normales.', 'success')
    except Exception:
        db.session.rollback()
        flash('No se pudieron eliminar las tareas marcadas.', 'error')
    return redirect(url_for('admin.tasks'))


@admin_bp.route('/tasks/programacion/eliminar-varias', methods=['POST'])
@login_required
@admin_required
def eliminar_programaciones_varias():
    """Borra por completo cada programación marcada y las tareas que ya generó."""
    identificadores = _ids_marcados('programacion_id')
    if not identificadores:
        flash('No hay programaciones marcadas.', 'warning')
        return redirect(url_for('admin.tasks'))

    try:
        programaciones = 0
        generadas = 0
        aviso = {}
        for programacion_id in identificadores:
            programacion = ScheduledTask.query.get(programacion_id)
            if programacion:
                copias = Task.query.filter_by(scheduled_task_id=programacion.id).all()
                _unir_avisos(aviso, armar_aviso_borrado(copias, [programacion]))
                generadas += eliminar_programacion_completa(programacion)
                programaciones += 1
                continue
            huerfanas = Task.query.filter_by(scheduled_task_id=programacion_id).all()
            if not huerfanas:
                continue
            _unir_avisos(aviso, armar_aviso_borrado(huerfanas))
            eliminar_tareas(huerfanas)
            generadas += len(huerfanas)
            programaciones += 1
        if programaciones == 0:
            db.session.rollback()
            flash('No se encontraron esas programaciones.', 'warning')
            return redirect(url_for('admin.tasks'))
        db.session.commit()
        enviar_aviso_borrado(aviso)
        flash(
            f'Se eliminaron {programaciones} programaciones y {generadas} tareas generadas. No volverán a crearse.',
            'success',
        )
    except Exception:
        db.session.rollback()
        flash('No se pudieron eliminar las programaciones marcadas.', 'error')
    return redirect(url_for('admin.tasks'))


@admin_bp.route('/reports')
@login_required
@admin_required
def reports():
    """Reportes y estadísticas"""
    # Estadísticas por área
    areas_stats = []
    areas = Area.query.filter_by(is_active=True).all()
    
    for area in areas:
        tasks = Task.query.filter_by(area_id=area.id).all()
        completed_tasks = [t for t in tasks if t.status == 'completada']
        
        area_stats = {
            'area': area,
            'total_tasks': len(tasks),
            'completed_tasks': len(completed_tasks),
            'completion_rate': round((len(completed_tasks) / len(tasks)) * 100, 1) if tasks else 0,
            'users_count': area.get_user_count()
        }
        areas_stats.append(area_stats)
    
    return render_template('admin/reports.html', areas_stats=areas_stats)

# Redirección segura si alguien entra por GET a /create-user
@admin_bp.route('/create-user', methods=['GET'])
@login_required
@admin_required
def create_user_get():
    return redirect(url_for('admin.users'))

@admin_bp.route('/create-user', methods=['POST'])
@login_required
@admin_required
def create_user():
    """Crear nuevo usuario"""
    username = request.form.get('username')
    email = request.form.get('email')
    password = request.form.get('password')
    role = request.form.get('role')
    
    if not all([username, email, password, role]):
        flash('Todos los campos son requeridos', 'error')
        return redirect(url_for('admin.users'))
    
    # Verificar si el usuario ya existe
    existing_user = User.query.filter(
        (User.username == username) | (User.email == email)
    ).first()
    
    if existing_user:
        flash('Ya existe un usuario con ese nombre o email', 'error')
        return redirect(url_for('admin.users'))
    
    user = User(
        username=username,
        email=email,
        role=role,
        is_active=True
    )
    user.set_password(password)
    
    try:
        db.session.add(user)
        db.session.commit()
        
        # Enviar notificación de cuenta creada
        EmailService.notify_user_created(user.email, username, password, role)
        
        flash(f'Usuario "{username}" creado exitosamente', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Error al crear el usuario', 'error')
    
    return redirect(url_for('admin.users'))

@admin_bp.route('/edit-user/<int:user_id>')
@login_required
@admin_required
def edit_user_get(user_id):
    """Mostrar formulario de edición de usuario"""
    user = User.query.get_or_404(user_id)
    return render_template('admin/edit_user.html', user=user)

@admin_bp.route('/edit-user/<int:user_id>', methods=['POST'])
@login_required
@admin_required
def edit_user(user_id):
    """Actualizar usuario"""
    user = User.query.get_or_404(user_id)
    
    username = request.form.get('username')
    email = request.form.get('email')
    password = request.form.get('password')
    role = request.form.get('role')
    is_active = request.form.get('is_active') == 'on'
    
    if not all([username, email, role]):
        flash('Usuario, email y rol son requeridos', 'error')
        return redirect(url_for('admin.edit_user_get', user_id=user_id))
    
    # Verificar si el usuario ya existe (excluyendo el usuario actual)
    existing_user = User.query.filter(
        (User.username == username) | (User.email == email)
    ).filter(User.id != user_id).first()
    
    if existing_user:
        flash('Ya existe un usuario con ese nombre o email', 'error')
        return redirect(url_for('admin.edit_user_get', user_id=user_id))
    
    # Actualizar datos
    user.username = username
    user.email = email
    user.role = role
    user.is_active = is_active
    
    # Actualizar contraseña solo si se proporciona una nueva
    if password:
        user.set_password(password)
        # Notificar cambio de contraseña
        try:
            EmailService.notify_password_reset(user.email, user.username, password)
        except Exception:
            pass
    
    try:
        db.session.commit()
        flash(f'Usuario "{username}" actualizado exitosamente', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Error al actualizar el usuario', 'error')
    
    return redirect(url_for('admin.users'))

@admin_bp.route('/delete-user/<int:user_id>', methods=['POST'])
@login_required
@admin_required
def delete_user(user_id):
    """Eliminar usuario"""
    user = User.query.get_or_404(user_id)
    
    # No permitir eliminar el usuario admin principal
    if user.username == 'Admin':
        flash('No se puede eliminar el usuario administrador principal', 'error')
        return redirect(url_for('admin.users'))
    
    try:
        # Limpiar asignaciones de área primero para evitar violaciones NOT NULL
        AreaUser.query.filter_by(user_id=user.id).delete(synchronize_session=False)

        db.session.delete(user)
        db.session.commit()
        flash(f'Usuario "{user.username}" eliminado exitosamente', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Error al eliminar el usuario', 'error')
    
    return redirect(url_for('admin.users'))
