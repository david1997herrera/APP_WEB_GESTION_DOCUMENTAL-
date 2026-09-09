@echo off
setlocal EnableExtensions
REM Respaldo BDD sin Python: usa docker exec + pg_dump.
REM Guarda en el Escritorio\RESPALDOS_APP_BDD (o BACKUP_DIR si esta definido).

cd /d "%~dp0.."

set "CONTAINER=gestion_documental_db"
set "DB_NAME=gestion_documental"
set "DB_USER=postgres"
set "RETAIN=14"

if defined BACKUP_DIR (
  set "OUTDIR=%BACKUP_DIR%"
) else (
  set "OUTDIR=%USERPROFILE%\Desktop\RESPALDOS_APP_BDD"
)

where docker >nul 2>&1
if errorlevel 1 (
  echo ERROR: docker no esta en el PATH.
  exit /b 1
)

docker inspect -f "{{.State.Running}}" %CONTAINER% 2>nul | findstr /I "true" >nul
if errorlevel 1 (
  echo ERROR: el contenedor %CONTAINER% no esta en ejecucion.
  echo Levanta el stack con: docker compose up -d
  exit /b 1
)

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "STAMP=%%I"
set "OUTFILE=%OUTDIR%\gestion_documental_%STAMP%.sql"

echo Creando respaldo en:
echo   %OUTFILE%

docker exec %CONTAINER% pg_dump -U %DB_USER% -d %DB_NAME% --no-owner --no-acl > "%OUTFILE%"
if errorlevel 1 (
  echo ERROR: fallo pg_dump.
  if exist "%OUTFILE%" del /f /q "%OUTFILE%"
  exit /b 1
)

for %%A in ("%OUTFILE%") do set "SIZE=%%~zA"
if "%SIZE%"=="0" (
  echo ERROR: el archivo de respaldo quedo vacio.
  del /f /q "%OUTFILE%"
  exit /b 1
)

echo OK: respaldo creado (%SIZE% bytes)

REM Retener solo los N mas recientes
powershell -NoProfile -Command ^
  "$dir='%OUTDIR%'; $keep=%RETAIN%;" ^
  "$files=Get-ChildItem -Path $dir -Filter 'gestion_documental_*.sql' | Sort-Object LastWriteTime -Descending;" ^
  "if ($keep -gt 0 -and $files.Count -gt $keep) { $files | Select-Object -Skip $keep | ForEach-Object { Write-Host ('Eliminado antiguo: ' + $_.Name); Remove-Item -Force $_.FullName } }"

echo.
echo Listo.
endlocal
exit /b 0
