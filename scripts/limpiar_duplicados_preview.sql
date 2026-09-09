-- Limpieza de tareas duplicadas generadas por el scheduler.
-- Conserva el ID menor de cada grupo (misma programación + mismo asignado + mismo día).
-- NO borra tareas manuales (scheduled_task_id IS NULL).

-- 1) Vista previa (qué se eliminaría)
WITH ranked AS (
  SELECT
    t.id,
    t.title,
    t.scheduled_task_id,
    t.assigned_to,
    t.status,
    t.created_at,
    (t.created_at::date) AS dia,
    ROW_NUMBER() OVER (
      PARTITION BY t.scheduled_task_id, t.assigned_to, (t.created_at::date)
      ORDER BY t.id ASC
    ) AS rn
  FROM tasks t
  WHERE t.scheduled_task_id IS NOT NULL
)
SELECT
  id AS id_a_eliminar,
  title,
  scheduled_task_id,
  assigned_to,
  status,
  created_at,
  dia
FROM ranked
WHERE rn > 1
ORDER BY dia, scheduled_task_id, id;
