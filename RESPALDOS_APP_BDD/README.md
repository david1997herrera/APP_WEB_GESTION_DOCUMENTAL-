# RESPALDOS_APP_BDD

Respaldos **externos** (no tocan la lógica de la app):

1. **BDD** → `gestion_documental_YYYYMMDD_HHMMSS.sql` (`pg_dump`)
2. **Archivos** → `uploads_YYYYMMDD_HHMMSS.zip` (carpeta `uploads` del proyecto)

## Dónde se guardan (servidor Windows)

Por defecto el script escribe en el Escritorio:

```text
C:\Users\ServerDell\Desktop\RESPALDOS_APP_BDD\
  gestion_documental_....sql
  uploads_....zip
```

Variable opcional:

```bat
set BACKUP_DIR=D:\Backups\GestionDocumental
scripts\backup_db.bat
```

Los `.sql` / `.zip` **no se suben a git**.

## Cómo respaldar (Windows, sin Python)

```bat
scripts\backup_db.bat
```

## Programador de tareas (automático diario)

Misma tarea que antes; el `.bat` ahora respalda BDD **y** uploads:

- Programa: `C:\Users\ServerDell\Desktop\app_web_gestion_documental-\scripts\backup_db.bat`
- Iniciar en: `C:\Users\ServerDell\Desktop\app_web_gestion_documental-`
- Diario, p. ej. 02:00

## Cómo respaldar (Mac)

```bash
python3 scripts/backup_db.py --desktop --retain 14
```

## Restaurar

### Base de datos

```bat
docker exec -i gestion_documental_db psql -U postgres -d gestion_documental < C:\Users\ServerDell\Desktop\RESPALDOS_APP_BDD\gestion_documental_YYYYMMDD_HHMMSS.sql
```

### Archivos uploads

1. Detener app (opcional): `docker compose stop app`
2. Descomprimir el ZIP sobre la carpeta `uploads` del proyecto
3. `docker compose start app`

## Política sugerida

| Qué | Valor |
|-----|--------|
| Frecuencia | Diario |
| Retención | 14 de cada tipo (SQL y ZIP) |
| Contenedor BDD | `gestion_documental_db` |
| Carpeta archivos | `./uploads` (montada en Docker) |
| No usar | `docker compose down -v` |

## Qué NO hace

- No vacía ni reinicia la base.
- No cambia `RUN_DB_INIT`.
- No modifica código Flask ni el scheduler.
