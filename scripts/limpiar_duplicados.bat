@echo off
setlocal EnableExtensions
REM Limpia tareas duplicadas del scheduler.
REM Uso:
REM   scripts\limpiar_duplicados.bat           -> solo PREVIEW (no borra)
REM   scripts\limpiar_duplicados.bat --aplicar -> borra duplicados (pide confirmacion)

cd /d "%~dp0.."
set "CONTAINER=gestion_documental_db"
set "DB_USER=postgres"
set "DB_NAME=gestion_documental"
set "MODE=preview"

if /I "%~1"=="--aplicar" set "MODE=aplicar"
if /I "%~1"=="aplicar" set "MODE=aplicar"

where docker >nul 2>&1
if errorlevel 1 (
  echo ERROR: docker no esta en el PATH.
  exit /b 1
)

docker inspect -f "{{.State.Running}}" %CONTAINER% 2>nul | findstr /I "true" >nul
if errorlevel 1 (
  echo ERROR: %CONTAINER% no esta en ejecucion.
  exit /b 1
)

if /I "%MODE%"=="preview" (
  echo ==== PREVIEW: tareas que SE ELIMINARIAN ^(no se borra nada^) ====
  type "scripts\limpiar_duplicados_preview.sql" | docker exec -i %CONTAINER% psql -U %DB_USER% -d %DB_NAME%
  echo.
  echo Si la lista es correcta y ya hiciste respaldo:
  echo   scripts\limpiar_duplicados.bat --aplicar
  exit /b 0
)

echo ==== APLICAR limpieza de duplicados ====
echo Antes de continuar DEBES tener un respaldo reciente.
echo Conserva el ID menor de cada grupo; elimina el resto.
echo.
pause

echo Ejecutando...
type "scripts\limpiar_duplicados_aplicar.sql" | docker exec -i %CONTAINER% psql -U %DB_USER% -d %DB_NAME% -v ON_ERROR_STOP=1
if errorlevel 1 (
  echo ERROR: fallo la limpieza.
  exit /b 1
)

echo.
echo Listo. Verifica de nuevo el preview ^(debe salir 0 filas^):
type "scripts\limpiar_duplicados_preview.sql" | docker exec -i %CONTAINER% psql -U %DB_USER% -d %DB_NAME%
endlocal
exit /b 0
