"""Dirección pública de la aplicación, para enlaces que salen por correo."""

import os

DIRECCION_PUBLICA = "http://131.196.8.22:3110"


def url_publica(camino=""):
    """Arma un enlace absoluto. No usa el host de quien abrió la página."""
    configurada = (os.getenv("APP_BASE_URL") or "").strip().rstrip("/")
    base = configurada or DIRECCION_PUBLICA
    if not camino:
        return base
    if camino.startswith("http://") or camino.startswith("https://"):
        return camino
    if not camino.startswith("/"):
        camino = "/" + camino
    return f"{base}{camino}"
