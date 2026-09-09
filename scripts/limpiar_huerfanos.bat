@echo off
REM Elimina contenedores huérfanos de la imagen de la app (nombres aleatorios tipo hardcore_lamarr).
REM NO toca gestion_documental_db ni APP_GESTION_DOCUMENTAL ni volúmenes.

echo Contenedores actuales de la imagen app:
docker ps -a --filter "ancestor=app_web_gestion_documental--app" --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"

echo.
echo Se eliminaran SOLO contenedores de esa imagen cuyo nombre NO sea APP_GESTION_DOCUMENTAL.
pause

for /f "tokens=1,2" %%A in ('docker ps -aq --filter "ancestor=app_web_gestion_documental--app" --format "{{.ID}} {{.Names}}"') do (
  if /I not "%%B"=="APP_GESTION_DOCUMENTAL" (
    echo Eliminando huérfano %%B ^(%%A^)...
    docker rm -f %%A
  )
)

echo.
echo Listo. Verifica el stack:
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
echo.
echo Si faltan contenedores: docker compose up -d
