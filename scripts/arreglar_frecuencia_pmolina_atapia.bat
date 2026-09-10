@echo off
setlocal EnableExtensions
cd /d "%~dp0.."
set "CONTAINER=gestion_documental_db"
set "DB_USER=postgres"
set "DB_NAME=gestion_documental"

echo ==== Ajustar frecuencias programaciones 17/18 ====
echo Envases -^> trimestral
echo Flora/Fauna -^> semestral
echo Empuja next_run_at al futuro para evitar borrar-y-recrear
echo.
pause

type "scripts\arreglar_frecuencia_pmolina_atapia.sql" | docker exec -i %CONTAINER% psql -U %DB_USER% -d %DB_NAME% -v ON_ERROR_STOP=1
if errorlevel 1 (
  echo ERROR al aplicar.
  exit /b 1
)
echo Listo.
endlocal
