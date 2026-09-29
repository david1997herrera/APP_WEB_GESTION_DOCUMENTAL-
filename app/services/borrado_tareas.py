"""Borrado de tareas y de los archivos que les pertenecen."""

from app.config import db
from app.models.file import File


def eliminar_tareas(tareas):
    """Quita las tareas y sus archivos. No confirma la transaccion."""
    for tarea in tareas:
        archivos = list(tarea.files) if tarea.files else []
        if not archivos and tarea.id:
            archivos = File.query.filter_by(task_id=tarea.id).all()
        for archivo in archivos:
            archivo.delete_file()
            db.session.delete(archivo)
        db.session.delete(tarea)
