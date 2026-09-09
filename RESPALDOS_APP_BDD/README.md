# RESPALDOS_APP_BDD

Carpeta de respaldos de PostgreSQL. **No forma parte de la lógica de la aplicación**: solo scripts externos que hacen `pg_dump` del contenedor `gestion_documental_db`.

## Dónde se guardan

Por defecto:

```text
<carpeta_del_proyecto>/RESPALDOS_APP_BDD/
```

Opcional (escritorio del usuario actual, Mac o Windows):

```bash
python scripts/backup_db.py --desktop
```

O con variable de entorno:

```bash
# Windows (PowerShell)
$env:BACKUP_DIR="$env:USERPROFILE\Desktop\RESPALDOS_APP_BDD"
python scripts/backup_db.py

# Mac
export BACKUP_DIR="$HOME/Desktop/RESPALDOS_APP_BDD"
python scripts/backup_db.py
```

Los archivos `.sql` / `.dump` de esta carpeta **no se suben a git** (están en `.gitignore`).

## Cómo respaldar (servidor Windows)

1. Docker Desktop con `gestion_documental_db` en ejecución.
2. Desde la carpeta del proyecto:

```bat
scripts\backup_db.bat
```

o:

```bat
python scripts\backup_db.py --desktop
```

3. Programar en **Programador de tareas de Windows** (diario, p. ej. 02:00):

- Programa: `python` (o ruta completa a `python.exe`)
- Argumentos: `scripts\backup_db.py --desktop --retain 14`
- Iniciar en: ruta del repo (donde está `docker-compose.yml`)

## Cómo respaldar (Mac)

```bash
python3 scripts/backup_db.py --desktop --retain 14
```

## Restaurar (solo si hace falta)

```bash
# CUIDADO: sobrescribe datos actuales de la BDD del contenedor
docker exec -i gestion_documental_db psql -U postgres -d gestion_documental < RESPALDOS_APP_BDD\gestion_documental_YYYYMMDD_HHMMSS.sql
```

En Mac/Linux usa `/` en la ruta.

## Política sugerida

| Qué | Valor |
|-----|--------|
| Frecuencia | Diario |
| Retención | 14 días (`--retain 14`) |
| Contenedor | `gestion_documental_db` |
| No usar | `docker compose down -v` (borra el volumen) |

## Qué NO hace este respaldo

- No vacía ni reinicia la base.
- No cambia `RUN_DB_INIT`.
- No modifica código Flask ni el scheduler.
