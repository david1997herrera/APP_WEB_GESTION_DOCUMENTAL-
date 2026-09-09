@echo off
REM Respaldo BDD - Windows. No altera la app; solo ejecuta pg_dump vía Docker.
cd /d "%~dp0.."
python scripts\backup_db.py --desktop --retain 14 %*
if errorlevel 1 (
  echo Fallo el respaldo.
  exit /b 1
)
echo Respaldo completado.
