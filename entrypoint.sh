#!/bin/sh
set -e

echo "🚀 Iniciando aplicación..."
echo "⏳ Esperando base de datos..."
sleep 5

if [ "${RUN_DB_INIT}" = "true" ]; then
  echo "🗄️ Inicializando base de datos (RUN_DB_INIT=true)..."
  python init_db.py || true
else
  echo "ℹ️ RUN_DB_INIT no es true, no se ejecuta init_db.py"
fi

echo "🌐 Iniciando servidor web..."
exec python main.py


