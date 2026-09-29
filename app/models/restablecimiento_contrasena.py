"""Enlace de un solo uso para cambiar la contraseña."""

from datetime import datetime

from app.config import db


class RestablecimientoContrasena(db.Model):
    __tablename__ = 'restablecimientos_contrasena'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    token_hash = db.Column(db.String(64), nullable=False, unique=True)
    expira_en = db.Column(db.DateTime, nullable=False)
    usado_en = db.Column(db.DateTime, nullable=True)
    creado_en = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    usuario = db.relationship('User', lazy=True)
