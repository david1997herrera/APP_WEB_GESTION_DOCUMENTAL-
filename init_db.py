#!/usr/bin/env python3
"""
Script de inicialización de la base de datos
Ejecutar este script para crear las tablas y el usuario admin
"""

import os
import sys

# Importar directamente desde main.py
from main import init_db

if __name__ == '__main__':
    print("🚀 Inicializando base de datos...")
    init_db()
    print("\n🚀 Puedes acceder a la aplicación en: http://localhost:3110")
    print("👤 Usuario: Admin")
    print("🔑 Contraseña: uml57vli60")
    print("📧 Email: david.herrera@tessacorporation.com")
