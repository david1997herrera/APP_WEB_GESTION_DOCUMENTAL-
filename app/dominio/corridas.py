"""Reglas de una corrida de tarea programada, sin acceso a base de datos."""

from datetime import datetime


def debe_omitir_creacion(ultima_corrida_en, run_at) -> bool:
    """La corrida ya se emitio. Borrar las tareas no autoriza a crearla otra vez."""
    if ultima_corrida_en is None or run_at is None:
        return False
    return run_at <= ultima_corrida_en


def momento_consumido(ultima_corrida_en, corrida, proxima_ejecucion, ahora: datetime):
    """Marca hasta donde queda atendida la programacion despues de un borrado."""
    candidatos = [valor for valor in (ultima_corrida_en, corrida) if valor is not None]
    if proxima_ejecucion is not None and proxima_ejecucion <= ahora:
        candidatos.append(proxima_ejecucion)
    if not candidatos:
        return ultima_corrida_en
    return max(candidatos)
