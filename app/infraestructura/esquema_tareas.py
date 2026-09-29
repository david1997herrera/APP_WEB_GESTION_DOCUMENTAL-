"""Ajustes aditivos del esquema de tareas sobre una base ya existente."""

from sqlalchemy import text

from app.config import db
from app.dominio.reloj import ahora_ecuador


def asegurar_esquema_tareas():
    """Agrega columnas de corrida, limpia duplicados y evita que el indice falle."""
    if not _tabla_existe('tasks') or not _tabla_existe('scheduled_tasks'):
        return 0

    _agregar_columna('tasks', 'corrida_en', 'TIMESTAMP')
    _agregar_columna('scheduled_tasks', 'ultima_corrida_en', 'TIMESTAMP')
    retiradas = _retirar_duplicados_de_la_misma_persona()
    _rellenar_corridas_heredadas()
    _marcar_programaciones_ya_emitidas()
    _crear_indice_de_corrida()
    return retiradas


def _tabla_existe(nombre):
    fila = db.session.execute(
        text(
            """
            SELECT 1
            FROM information_schema.tables
            WHERE table_schema = 'public' AND table_name = :nombre
            """
        ),
        {'nombre': nombre},
    ).first()
    return fila is not None


def _agregar_columna(tabla, columna, tipo):
    existe = db.session.execute(
        text(
            """
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = 'public'
              AND table_name = :tabla
              AND column_name = :columna
            """
        ),
        {'tabla': tabla, 'columna': columna},
    ).first()
    if existe:
        return
    db.session.execute(text(f'ALTER TABLE {tabla} ADD COLUMN {columna} {tipo}'))
    db.session.commit()


def _retirar_duplicados_de_la_misma_persona():
    """Conserva la fila mas antigua de cada persona, programacion y dia."""
    filas = db.session.execute(
        text(
            """
            SELECT id
            FROM (
                SELECT
                    id,
                    ROW_NUMBER() OVER (
                        PARTITION BY scheduled_task_id, assigned_to, (created_at::date)
                        ORDER BY id ASC
                    ) AS rn
                FROM tasks
                WHERE scheduled_task_id IS NOT NULL
                  AND assigned_to IS NOT NULL
                  AND created_at IS NOT NULL
            ) ranked
            WHERE rn > 1
            """
        )
    ).fetchall()
    identificadores = [fila[0] for fila in filas]
    if not identificadores:
        return 0

    from app.models.file import File
    from app.models.task import Task

    for archivo in File.query.filter(File.task_id.in_(identificadores)).all():
        archivo.delete_file()
        db.session.delete(archivo)
    Task.query.filter(Task.id.in_(identificadores)).delete(synchronize_session=False)
    db.session.commit()
    return len(identificadores)


def _rellenar_corridas_heredadas():
    """Las tareas viejas no guardaban la corrida: el dia de creacion las agrupa."""
    db.session.execute(
        text(
            """
            UPDATE tasks
            SET corrida_en = date_trunc('day', created_at)
            WHERE scheduled_task_id IS NOT NULL
              AND corrida_en IS NULL
              AND created_at IS NOT NULL
            """
        )
    )
    db.session.commit()


def _marcar_programaciones_ya_emitidas():
    """Si la corrida ya genero tareas, o quedo vencida, no se vuelve a disparar."""
    db.session.execute(
        text(
            """
            UPDATE scheduled_tasks AS programacion
            SET ultima_corrida_en = origen.max_creada
            FROM (
                SELECT scheduled_task_id, MAX(created_at) AS max_creada
                FROM tasks
                WHERE scheduled_task_id IS NOT NULL
                GROUP BY scheduled_task_id
            ) AS origen
            WHERE programacion.id = origen.scheduled_task_id
              AND (
                    programacion.ultima_corrida_en IS NULL
                    OR programacion.ultima_corrida_en < origen.max_creada
              )
            """
        )
    )
    db.session.execute(
        text(
            """
            UPDATE scheduled_tasks
            SET ultima_corrida_en = next_run_at
            WHERE next_run_at IS NOT NULL
              AND next_run_at <= :ahora
              AND (
                    ultima_corrida_en IS NULL
                    OR ultima_corrida_en < next_run_at
              )
            """
        ),
        {'ahora': ahora_ecuador()},
    )
    db.session.commit()


def _crear_indice_de_corrida():
    try:
        db.session.execute(
            text(
                """
                CREATE UNIQUE INDEX IF NOT EXISTS uq_tarea_programada_corrida
                ON tasks (scheduled_task_id, assigned_to, corrida_en)
                WHERE scheduled_task_id IS NOT NULL
                  AND assigned_to IS NOT NULL
                  AND corrida_en IS NOT NULL
                """
            )
        )
        db.session.commit()
    except Exception:
        db.session.rollback()
