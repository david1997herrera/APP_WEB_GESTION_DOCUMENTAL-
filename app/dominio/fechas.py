"""Reglas de fechas de una programación, sin acceso a base de datos."""

from datetime import datetime


def _dia(valor):
    if isinstance(valor, datetime):
        return valor.date()
    return valor


def fin_es_anterior_al_inicio(inicio, fin) -> bool:
    """El fin no puede quedar en un día anterior al inicio."""
    if inicio is None or fin is None:
        return False
    return _dia(fin) < _dia(inicio)
