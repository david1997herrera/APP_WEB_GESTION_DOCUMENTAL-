#!/bin/bash

# Script de inicio rápido para la aplicación de Gestión Documental
echo "🚀 Iniciando Sistema de Gestión Documental..."
echo "================================================"

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado. Por favor instala Docker primero."
    exit 1
fi

# Verificar si Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose no está instalado. Por favor instala Docker Compose primero."
    exit 1
fi

# Verificar si el puerto 3110 está disponible
if lsof -Pi :3110 -sTCP:LISTEN -t >/dev/null ; then
    echo "⚠️  El puerto 3110 está en uso. Por favor libera el puerto o cambia la configuración."
    exit 1
fi

echo "✅ Verificaciones completadas"
echo ""

# Construir y ejecutar los contenedores
echo "🔨 Construyendo contenedores..."
docker-compose up --build -d

# Esperar a que la base de datos esté lista
echo "⏳ Esperando a que la base de datos esté lista..."
sleep 10

# Inicializar la base de datos
echo "🗄️  Inicializando base de datos..."
docker-compose exec app python init_db.py

echo ""
echo "🎉 ¡Aplicación iniciada correctamente!"
echo "================================================"
echo "🌐 URL: http://localhost:3110"
echo "👤 Usuario: Admin"
echo "🔑 Contraseña: uml57vli60"
echo ""
echo "📊 Para ver los logs: docker-compose logs -f"
echo "🛑 Para detener: docker-compose down"
echo "================================================"
