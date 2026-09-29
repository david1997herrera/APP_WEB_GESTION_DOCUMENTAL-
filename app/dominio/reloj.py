"""Hora civil de Ecuador. UTC-5, sin horario de verano."""

from datetime import datetime, timedelta, timezone

ZONA_ECUADOR = timezone(timedelta(hours=-5))


def ahora_ecuador():
    """Ahora en Ecuador, sin zona, para compararlo con las fechas guardadas."""
    return datetime.now(ZONA_ECUADOR).replace(tzinfo=None)
