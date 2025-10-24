#!/usr/bin/env python3
"""
Script simple para convertir Markdown a PDF usando herramientas disponibles
"""

import subprocess
import sys
import os

def main():
    # Intentar con diferentes métodos
    methods = [
        # Método 1: pandoc con weasyprint
        lambda: subprocess.run([
            'pandoc', 'Seccion_4_Pruebas.md',
            '-o', 'Seccion_4_Pruebas.pdf',
            '--pdf-engine=weasyprint',
            '-V', 'lang=es',
            '--metadata', 'title=Sección 4. Pruebas - Ofraud'
        ]),

        # Método 2: pandoc con context
        lambda: subprocess.run([
            'pandoc', 'Seccion_4_Pruebas.md',
            '-o', 'Seccion_4_Pruebas.pdf',
            '--pdf-engine=context',
            '-V', 'lang=es'
        ]),

        # Método 3: pandoc con prince
        lambda: subprocess.run([
            'pandoc', 'Seccion_4_Pruebas.md',
            '-o', 'Seccion_4_Pruebas.pdf',
            '--pdf-engine=prince'
        ]),
    ]

    print("Intentando convertir Markdown a PDF...")

    for i, method in enumerate(methods, 1):
        try:
            print(f"\nMétodo {i}:")
            result = method()
            if result.returncode == 0:
                print(f"✅ Éxito! PDF creado con método {i}")
                return 0
        except Exception as e:
            print(f"❌ Falló: {e}")
            continue

    print("\n⚠️  No se pudo crear el PDF automáticamente.")
    print("\nOpciones manuales:")
    print("1. Abrir Seccion_4_Pruebas.html en Chrome/Safari")
    print("2. Presionar Cmd+P (imprimir)")
    print("3. Seleccionar 'Guardar como PDF'")
    print("4. Guardar con el nombre 'Seccion_4_Pruebas.pdf'")

    return 1

if __name__ == '__main__':
    sys.exit(main())
