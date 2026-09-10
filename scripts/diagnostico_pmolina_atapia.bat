@echo off
setlocal EnableExtensions
cd /d "%~dp0.."
set "CONTAINER=gestion_documental_db"
set "DB_USER=postgres"
set "DB_NAME=gestion_documental"

echo ==== Diagnostico PMolina / ATapia ====
type "scripts\diagnostico_pmolina_atapia.sql" | docker exec -i %CONTAINER% psql -U %DB_USER% -d %DB_NAME%
echo.
echo Si confirmas el ajuste de frecuencias (trimestral/semestral), ejecuta:
echo   scripts\arreglar_frecuencia_pmolina_atapia.bat
endlocal
