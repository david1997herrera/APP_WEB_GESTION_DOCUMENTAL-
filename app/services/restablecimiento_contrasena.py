"""Solicitud y uso del enlace para cambiar la contraseña."""

import hashlib
import secrets
from datetime import datetime, timedelta

from flask import url_for

from app.config import db
from app.dominio.restablecimiento import (
    contrasena_aceptable,
    enlace_sigue_vigente,
    momento_de_vencimiento,
)
from app.models.restablecimiento_contrasena import RestablecimientoContrasena
from app.models.user import User
from app.infraestructura.url_publica import url_publica
from app.services.email_service import EmailService

MENSAJE_GENERICO = (
    'Si el usuario existe, enviamos un enlace a su correo. Vence en 5 minutos.'
)
SEGUNDOS_ENTRE_ENVIOS = 60


def _resumen(token):
    return hashlib.sha256(token.encode('utf-8')).hexdigest()


def solicitar_enlace(nombre_usuario):
    """Envía el enlace si el usuario está activo. La respuesta no revela si existe."""
    nombre = (nombre_usuario or '').strip()
    if not nombre:
        return MENSAJE_GENERICO

    usuario = User.query.filter_by(username=nombre, is_active=True).first()
    if not usuario or not usuario.email:
        return MENSAJE_GENERICO

    ahora = datetime.utcnow()
    reciente = RestablecimientoContrasena.query.filter(
        RestablecimientoContrasena.user_id == usuario.id,
        RestablecimientoContrasena.usado_en.is_(None),
        RestablecimientoContrasena.creado_en >= ahora - timedelta(seconds=SEGUNDOS_ENTRE_ENVIOS),
    ).first()
    if reciente:
        return MENSAJE_GENERICO

    RestablecimientoContrasena.query.filter(
        RestablecimientoContrasena.user_id == usuario.id,
        RestablecimientoContrasena.usado_en.is_(None),
    ).update({'usado_en': ahora}, synchronize_session=False)

    token = secrets.token_urlsafe(32)
    db.session.add(RestablecimientoContrasena(
        user_id=usuario.id,
        token_hash=_resumen(token),
        expira_en=momento_de_vencimiento(ahora),
        creado_en=ahora,
    ))
    db.session.commit()

    enlace = url_publica(url_for('auth.restablecer_contrasena', token=token))
    EmailService.enviar_enlace_restablecimiento(usuario.email, usuario.username, enlace)
    return MENSAJE_GENERICO


def cambiar_con_enlace(token, contrasena, confirmacion):
    """Cambia la contraseña si el enlace sigue vigente. Devuelve un mensaje de error o None."""
    if not contrasena_aceptable(contrasena, confirmacion):
        return 'La contraseña debe tener al menos 8 caracteres y coincidir en ambos campos.'

    registro = RestablecimientoContrasena.query.filter_by(token_hash=_resumen(token or '')).first()
    ahora = datetime.utcnow()
    if not registro or not enlace_sigue_vigente(registro.expira_en, registro.usado_en, ahora):
        return 'El enlace venció o ya se usó. Solicite uno nuevo.'

    usuario = User.query.get(registro.user_id)
    if not usuario or not usuario.is_active:
        return 'El enlace venció o ya se usó. Solicite uno nuevo.'

    usuario.set_password(contrasena)
    registro.usado_en = ahora
    db.session.commit()
    return None
