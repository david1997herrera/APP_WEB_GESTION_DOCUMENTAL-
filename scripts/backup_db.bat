@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM Respaldo completo en UN solo ZIP:
REM   - gestion_documental.sql  (pg_dump)
REM   - uploads\...             (archivos de la app)
REM Destino: Escritorio\RESPALDOS_APP_BDD (o BACKUP_DIR)

cd /d "%~dp0.."

set "CONTAINER=gestion_documental_db"
set "DB_NAME=gestion_documental"
set "DB_USER=postgres"
set "RETAIN=14"
set "UPLOADS_DIR=%CD%\uploads"
set "TMPDIR=%TEMP%\gd_backup_%RANDOM%"

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
mkdir "%TMPDIR%" >nul 2>&1
mkdir "%TMPDIR%\uploads" >nul 2>&1

for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "STAMP=%%I"
set "OUTZIP=%OUTDIR%\respaldo_completo_%STAMP%.zip"
set "TMPSQL=%TMPDIR%\gestion_documental.sql"

echo ============================================
echo 1/3 Dump BDD
echo ============================================
docker exec %CONTAINER% pg_dump -U %DB_USER% -d %DB_NAME% --no-owner --no-acl > "%TMPSQL%"
if errorlevel 1 (
  echo ERROR: fallo pg_dump.
  rmdir /s /q "%TMPDIR%" >nul 2>&1
  exit /b 1
)
for %%A in ("%TMPSQL%") do set "SQLSIZE=%%~zA"
if "!SQLSIZE!"=="0" (
  echo ERROR: el SQL quedo vacio.
  rmdir /s /q "%TMPDIR%" >nul 2>&1
  exit /b 1
)
echo OK BDD (!SQLSIZE! bytes)

echo.
echo ============================================
echo 2/3 Copiar uploads
echo ============================================
if exist "%UPLOADS_DIR%" (
  robocopy "%UPLOADS_DIR%" "%TMPDIR%\uploads" /E /NFL /NDL /NJH /NJS /nc /ns /np >nul
  set "RC=!ERRORLEVEL!"
  if !RC! GEQ 8 (
    echo ERROR: fallo al copiar uploads ^(robocopy code !RC!^).
    rmdir /s /q "%TMPDIR%" >nul 2>&1
    exit /b 1
  )
  echo OK uploads copiados
) else (
  echo AVISO: no existe %UPLOADS_DIR% — el ZIP ira solo con el SQL
)

echo.
echo ============================================
echo 3/3 Generar ZIP unico
echo ============================================
echo   %OUTZIP%
powershell -NoProfile -Command "Compress-Archive -Path '%TMPSQL%','%TMPDIR%\uploads' -DestinationPath '%OUTZIP%' -Force"
if errorlevel 1 (
  echo ERROR: fallo al crear el ZIP.
  rmdir /s /q "%TMPDIR%" >nul 2>&1
  exit /b 1
)

for %%A in ("%OUTZIP%") do set "ZIPSIZE=%%~zA"
echo OK ZIP (!ZIPSIZE! bytes)

rmdir /s /q "%TMPDIR%" >nul 2>&1

echo.
echo Limpiando respaldos antiguos ^(retener %RETAIN%^)...
powershell -NoProfile -Command ^
  "$dir='%OUTDIR%'; $keep=%RETAIN%;" ^
  "$files=Get-ChildItem -Path $dir -Filter 'respaldo_completo_*.zip' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending;" ^
  "if ($keep -gt 0 -and $files.Count -gt $keep) { $files | Select-Object -Skip $keep | ForEach-Object { Write-Host ('Eliminado antiguo: ' + $_.Name); Remove-Item -Force $_.FullName } }"

echo.
echo Listo. Un solo archivo:
echo   %OUTZIP%
echo Contiene: gestion_documental.sql + carpeta uploads\
endlocal
exit /b 0
