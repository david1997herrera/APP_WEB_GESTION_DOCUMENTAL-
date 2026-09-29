"""Tabla del enlace de restablecimiento sobre una base ya existente."""

from sqlalchemy import text

from app.config import db


def asegurar_esquema_cuentas():
    if db.engine.dialect.name != 'postgresql':
        return
    existe = db.session.execute(
        text(
            """
            SELECT 1
            FROM information_schema.tables
            WHERE table_schema = 'public' AND table_name = 'users'
            """
        )
    ).first()
    if not existe:
        return
    db.session.execute(
        text(
            """
            CREATE TABLE IF NOT EXISTS restablecimientos_contrasena (
                id SERIAL PRIMARY KEY,
                user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                token_hash VARCHAR(64) NOT NULL UNIQUE,
                expira_en TIMESTAMP NOT NULL,
                usado_en TIMESTAMP NULL,
                creado_en TIMESTAMP NOT NULL
            )
            """
        )
    )
    db.session.commit()
