#!/usr/bin/env python3
"""
Script para migrar la base de datos y agregar la columna created_at a la tabla files
"""

import os
import sys
from sqlalchemy import create_engine, text

# Configuración de la base de datos
DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://postgres:password@localhost:5432/gestion_documental')

def migrate_database():
    """Migrar la base de datos"""
    try:
        # Conectar a la base de datos
        engine = create_engine(DATABASE_URL)
        
        with engine.connect() as conn:
            # Verificar si la columna created_at ya existe
            result = conn.execute(text("""
                SELECT column_name 
                FROM information_schema.columns 
                WHERE table_name = 'files' AND column_name = 'created_at'
            """))
            
            if result.fetchone():
                print("✅ La columna 'created_at' ya existe en la tabla 'files'")
            else:
                print("🔄 Agregando columna 'created_at' a la tabla 'files'...")
                # Agregar la columna created_at
                conn.execute(text("""
                    ALTER TABLE files 
                    ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                """))
                
                # Actualizar registros existentes para que created_at = uploaded_at
                conn.execute(text("""
                    UPDATE files 
                    SET created_at = uploaded_at 
                    WHERE created_at IS NULL
                """))
                
                conn.commit()
                print("✅ Columna 'created_at' agregada exitosamente")
            
            # Verificar si la columna mimetype existe y renombrarla a file_type si es necesario
            result = conn.execute(text("""
                SELECT column_name 
                FROM information_schema.columns 
                WHERE table_name = 'files' AND column_name = 'mimetype'
            """))
            
            if result.fetchone():
                print("🔄 Renombrando columna 'mimetype' a 'file_type'...")
                conn.execute(text("""
                    ALTER TABLE files 
                    RENAME COLUMN mimetype TO file_type
                """))
                conn.commit()
                print("✅ Columna renombrada exitosamente")
            else:
                print("✅ La columna ya se llama 'file_type'")
                
        print("🎉 Migración completada exitosamente")
        
    except Exception as e:
        print(f"❌ Error durante la migración: {e}")
        sys.exit(1)

if __name__ == "__main__":
    migrate_database()
