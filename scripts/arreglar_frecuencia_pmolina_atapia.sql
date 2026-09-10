-- Ajuste de frecuencias mal configuradas para PMolina/ATapia (y similares).
-- Envases = cada 3 meses → trimestral
-- Flora/fauna = semestral
-- Además deja next_run_at en el futuro para que no regeneren al borrar.

BEGIN;

UPDATE scheduled_tasks
SET frequency = 'trimestral',
    "interval" = 1,
    next_run_at = GREATEST(next_run_at, NOW() + INTERVAL '1 day'),
    updated_at = NOW()
WHERE id = 17
  AND title ILIKE '%ENVASES%';

UPDATE scheduled_tasks
SET frequency = 'semestral',
    "interval" = 1,
    next_run_at = GREATEST(next_run_at, NOW() + INTERVAL '1 day'),
    updated_at = NOW()
WHERE id = 18
  AND title ILIKE '%FLORA%FAUNA%';

-- Cualquier otra programación "personalizada" con intervalo 1 que ya disparó:
-- empuja next_run_at al futuro inmediato para cortar el ciclo borrar→recrear
UPDATE scheduled_tasks
SET next_run_at = NOW() + INTERVAL '1 day',
    updated_at = NOW()
WHERE is_active IS TRUE
  AND frequency = 'personalizada'
  AND "interval" = 1
  AND next_run_at IS NOT NULL
  AND next_run_at <= NOW();

COMMIT;

\echo '=== Estado actualizado (17 y 18) ==='
SELECT id, title, frequency, "interval", next_run_at, is_active
FROM scheduled_tasks
WHERE id IN (17, 18);
