# RESPALDOS_APP_BDD

Respaldos **externos** (no tocan la lógica de la app).

Cada ejecución genera **un solo ZIP**:

```text
respaldo_completo_YYYYMMDD_HHMMSS.zip
  ├── gestion_documental.sql    ← dump de la BDD
  └── uploads\                  ← archivos subidos
        └── ...
```

## Dónde se guardan (servidor Windows)

```text
C:\Users\ServerDell\Desktop\RESPALDOS_APP_BDD\respaldo_completo_....zip
```

## Cómo respaldar

```bat
scripts\backup_db.bat
```

## Programador de tareas

Misma ruta de siempre:

- Programa: `...\app_web_gestion_documental-\scripts\backup_db.bat`
- Iniciar en: `...\app_web_gestion_documental-`
- Diario (p. ej. 02:00)
- Retiene los **14** ZIP más recientes

## Restaurar

1. Descomprimir el ZIP.
2. BDD:
   ```bat
   docker exec -i gestion_documental_db psql -U postgres -d gestion_documental < gestion_documental.sql
   ```
3. Archivos: copiar el contenido de `uploads\` del ZIP sobre la carpeta `uploads` del proyecto.

## Qué NO hace

- No vacía la base.
- No cambia `RUN_DB_INIT`.
- No modifica código Flask.
