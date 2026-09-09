@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM Respaldo completo sin Python:
REM  1) BDD  -> pg_dump (docker)
REM  2) uploads -> ZIP del volumen montado ./uploads
REM Guarda en Escritorio\RESPALDOS_APP_BDD (o BACKUP_DIR).

cd /d "%~dp0.."

set "CONTAINER=gestion_documental_db"
set "DB_NAME=gestion_documental"
set "DB_USER=postgres"
set "RETAIN=14"
set "UPLOADS_DIR=%CD%\uploads"

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
set "OUTSQL=%OUTDIR%\gestion_documental_%STAMP%.sql"
set "OUTZIP=%OUTDIR%\uploads_%STAMP%.zip"

echo ============================================
echo 1/2 Respaldo BDD
echo ============================================
echo   %OUTSQL%

docker exec %CONTAINER% pg_dump -U %DB_USER% -d %DB_NAME% --no-owner --no-acl > "%OUTSQL%"
if errorlevel 1 (
  echo ERROR: fallo pg_dump.
  if exist "%OUTSQL%" del /f /q "%OUTSQL%"
  exit /b 1
)

for %%A in ("%OUTSQL%") do set "SQLSIZE=%%~zA"
if "!SQLSIZE!"=="0" (
  echo ERROR: el SQL quedo vacio.
  del /f /q "%OUTSQL%"
  exit /b 1
)
echo OK BDD (!SQLSIZE! bytes)

echo.
echo ============================================
echo 2/2 Respaldo uploads
echo ============================================
if not exist "%UPLOADS_DIR%" (
  echo AVISO: no existe la carpeta uploads: %UPLOADS_DIR%
  echo Se omite el ZIP de archivos.
  goto PRUNE
)

echo   Origen: %UPLOADS_DIR%
echo   Destino: %OUTZIP%

REM Si uploads esta vacia, Compress-Archive puede fallar: crear zip vacio-safe
dir /a-d /s "%UPLOADS_DIR%" >nul 2>&1
if errorlevel 1 (
  echo AVISO: uploads sin archivos; se omite ZIP.
  goto PRUNE
)

powershell -NoProfile -Command "Compress-Archive -Path '%UPLOADS_DIR%\*' -DestinationPath '%OUTZIP%' -Force"
if errorlevel 1 (
  echo ERROR: fallo al comprimir uploads.
  exit /b 1
)

if not exist "%OUTZIP%" (
  echo AVISO: no se genero ZIP.
  goto PRUNE
)

for %%A in ("%OUTZIP%") do set "ZIPSIZE=%%~zA"
echo OK uploads (!ZIPSIZE! bytes)

:PRUNE
echo.
echo Limpiando respaldos antiguos ^(retener %RETAIN%^)...
powershell -NoProfile -Command ^
  "$dir='%OUTDIR%'; $keep=%RETAIN%;" ^
  "foreach ($pat in @('gestion_documental_*.sql','uploads_*.zip')) {" ^
  "  $files=Get-ChildItem -Path $dir -Filter $pat -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending;" ^
  "  if ($keep -gt 0 -and $files.Count -gt $keep) { $files | Select-Object -Skip $keep | ForEach-Object { Write-Host ('Eliminado antiguo: ' + $_.Name); Remove-Item -Force $_.FullName } }" ^
  "}"

echo.
echo Listo. Archivos en:
echo   %OUTDIR%
endlocal
exit /b 0
