"""Correo a las personas afectadas cuando se borra una tarea o una programación."""

from html import escape

from flask_login import current_user

from app.services.email_service import EmailService


def armar_aviso_borrado(tareas=None, programaciones=None):
    """Lee correos y títulos antes de borrar las filas."""
    por_correo = {}

    def agregar(correo, titulo):
        if not correo or correo == _correo_de_quien_borra():
            return
        titulos = por_correo.setdefault(correo, [])
        if titulo not in titulos:
            titulos.append(titulo)

    for tarea in tareas or []:
        titulo = tarea.title or 'Tarea sin título'
        if getattr(tarea, 'assignee', None) and tarea.assignee.email:
            agregar(tarea.assignee.email, titulo)
        if getattr(tarea, 'creator', None) and tarea.creator.email:
            agregar(tarea.creator.email, titulo)

    for programacion in programaciones or []:
        titulo = programacion.title or 'Programación sin título'
        for usuario in list(programacion.assigned_users or []):
            agregar(getattr(usuario, 'email', None), titulo)

    return por_correo


def enviar_aviso_borrado(por_correo):
    """Envía un correo por persona. Un fallo de correo no revierte el borrado."""
    if not por_correo:
        return
    quien = _nombre_de_quien_borra()
    for correo, titulos in por_correo.items():
        visibles = titulos[:15]
        resto = len(titulos) - len(visibles)
        lista = '\n'.join(f'- {titulo}' for titulo in visibles)
        if resto:
            lista += f'\n- y {resto} más'
        cuerpo = (
            f'Hola,\n\n'
            f'{quien} eliminó lo siguiente en Gestión Documental:\n\n'
            f'{lista}\n\n'
            f'Esta acción ya quedó aplicada.\n'
        )
        elementos = ''.join(f'<li>{escape(titulo)}</li>' for titulo in visibles)
        if resto:
            elementos += f'<li>y {resto} más</li>'
        html = (
            '<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">'
            f'<p>{escape(quien)} eliminó lo siguiente en Gestión Documental:</p>'
            f'<ul>{elementos}</ul>'
            '<p>Esta acción ya quedó aplicada.</p>'
            '</div>'
        )
        EmailService.send_email(correo, 'Se eliminó una tarea - Gestión Documental', cuerpo, html)


def _correo_de_quien_borra():
    try:
        if current_user.is_authenticated:
            return current_user.email
    except Exception:
        return None
    return None


def _nombre_de_quien_borra():
    try:
        if current_user.is_authenticated and current_user.username:
            return current_user.username
    except Exception:
        return 'El sistema'
    return 'El sistema'
