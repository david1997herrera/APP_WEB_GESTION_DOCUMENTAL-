"""Reglas del enlace para cambiar la contraseña."""

from datetime import datetime, timedelta

MINUTOS_DE_VIGENCIA = 5
LONGITUD_MINIMA = 8


def momento_de_vencimiento(ahora):
    return ahora + timedelta(minutes=MINUTOS_DE_VIGENCIA)


def enlace_sigue_vigente(expira_en, usado_en, ahora):
    if usado_en is not None or expira_en is None or ahora is None:
        return False
    return ahora <= expira_en


def contrasena_aceptable(contrasena, confirmacion):
    if not contrasena or contrasena != confirmacion:
        return False
    return len(contrasena) >= LONGITUD_MINIMA
