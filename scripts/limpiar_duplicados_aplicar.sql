-- APLICAR limpieza de duplicados (ejecutar solo después de revisar el preview y tener respaldo).
BEGIN;

-- Borrar archivos ligados a tareas duplicadas (si existieran)
WITH ranked AS (
  SELECT
    t.id,
    ROW_NUMBER() OVER (
      PARTITION BY t.scheduled_task_id, t.assigned_to, (t.created_at::date)
      ORDER BY t.id ASC
    ) AS rn
  FROM tasks t
  WHERE t.scheduled_task_id IS NOT NULL
),
dupes AS (
  SELECT id FROM ranked WHERE rn > 1
)
DELETE FROM files
WHERE task_id IN (SELECT id FROM dupes);

-- Borrar las tareas duplicadas (conserva rn = 1)
WITH ranked AS (
  SELECT
    t.id,
    ROW_NUMBER() OVER (
      PARTITION BY t.scheduled_task_id, t.assigned_to, (t.created_at::date)
      ORDER BY t.id ASC
    ) AS rn
  FROM tasks t
  WHERE t.scheduled_task_id IS NOT NULL
),
dupes AS (
  SELECT id FROM ranked WHERE rn > 1
)
DELETE FROM tasks
WHERE id IN (SELECT id FROM dupes);

COMMIT;
