@echo off
setlocal EnableExtensions
REM Corrige bug previo: NUNCA usar "docker ps -aq" con --format en Windows.
REM Eso dejaba el nombre vacio y borraba APP_GESTION_DOCUMENTAL por error.

echo ============================================
echo Limpieza de contenedores huerfanos (APP)
echo ============================================
echo.
echo Contenedores actuales:
docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"
echo.
echo Se CONSERVAN siempre:
echo   APP_GESTION_DOCUMENTAL
echo   gestion_documental_db
echo.
echo Solo se borran contenedores de la imagen app_web_gestion_documental*
echo cuyo nombre NO sea APP_GESTION_DOCUMENTAL.
echo La BDD no se toca.
echo.
pause

set "DELETED=0"

for /f "usebackq tokens=1,2 delims=|" %%A in (`docker ps -a --format "{{.ID}}|{{.Names}}"`) do (
  if /I "%%B"=="APP_GESTION_DOCUMENTAL" (
    echo Conservando: %%B
  ) else if /I "%%B"=="gestion_documental_db" (
    echo Conservando: %%B
  ) else (
    for /f "usebackq delims=" %%I in (`docker inspect -f "{{.Config.Image}}" %%A 2^>nul`) do (
      echo %%I | findstr /I "app_web_gestion_documental" >nul
      if not errorlevel 1 (
        echo Eliminando huerfano: %%B ^(%%A^) imagen=%%I
        docker rm -f %%A >nul
        if not errorlevel 1 set /a DELETED+=1
      ) else (
        echo Omitiendo: %%B ^(otra imagen^)
      )
    )
  )
)

echo.
echo Huerfanos eliminados: %DELETED%
echo.
echo Estado actual:
docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
echo.
echo Si falta APP_GESTION_DOCUMENTAL, ejecuta AHORA:
echo   docker compose up -d
echo.
pause
endlocal
