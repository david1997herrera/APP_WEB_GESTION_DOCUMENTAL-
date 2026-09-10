-- Diagnóstico: tareas de PMolina (12) y ATapia (13) ligadas a programaciones
-- Ejecutar en el servidor:
-- type scripts\diagnostico_pmolina_atapia.sql | docker exec -i gestion_documental_db psql -U postgres -d gestion_documental

\echo '=== Usuarios ==='
SELECT id, username, role FROM users WHERE id IN (12, 13);

\echo '=== Programaciones donde están asignados ==='
SELECT st.id, st.title, st.frequency, st.interval, st.next_run_at, st.is_active,
       string_agg(u.username, ', ' ORDER BY u.username) AS asignados
FROM scheduled_tasks st
JOIN scheduled_task_users stu ON stu.scheduled_task_id = st.id
JOIN users u ON u.id = stu.user_id
WHERE st.id IN (
  SELECT scheduled_task_id FROM scheduled_task_users WHERE user_id IN (12, 13)
)
GROUP BY st.id
ORDER BY st.id;

\echo '=== Tareas actuales de PMolina y ATapia (origen programado) ==='
SELECT t.id, t.title, u.username AS asignado, t.status, t.created_at::timestamp(0) AS creada,
       t.scheduled_task_id, st.frequency, st.interval, st.next_run_at
FROM tasks t
JOIN users u ON u.id = t.assigned_to
LEFT JOIN scheduled_tasks st ON st.id = t.scheduled_task_id
WHERE t.assigned_to IN (12, 13)
  AND t.scheduled_task_id IS NOT NULL
ORDER BY t.title, u.username, t.created_at DESC;

\echo '=== Conteo por titulo+usuario (si >1 mismo dia = problema) ==='
SELECT t.title, u.username, t.created_at::date AS dia, COUNT(*) AS cuantas, array_agg(t.id ORDER BY t.id) AS ids
FROM tasks t
JOIN users u ON u.id = t.assigned_to
WHERE t.assigned_to IN (12, 13)
  AND t.scheduled_task_id IS NOT NULL
GROUP BY t.title, u.username, t.created_at::date
HAVING COUNT(*) > 1
ORDER BY dia DESC;
