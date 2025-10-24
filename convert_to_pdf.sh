#!/bin/bash

# Script para convertir HTML a PDF usando herramientas de macOS

HTML_FILE="$1"
OUTPUT_PDF="$2"

if [ -z "$HTML_FILE" ] || [ -z "$OUTPUT_PDF" ]; then
    echo "Uso: $0 <archivo.html> <salida.pdf>"
    exit 1
fi

# Obtener ruta absoluta
HTML_PATH=$(cd "$(dirname "$HTML_FILE")" && pwd)/$(basename "$HTML_FILE")

# Usar Python con PyPDF o similar
osascript <<EOF
tell application "Safari"
    activate
    open POSIX file "$HTML_PATH"
    delay 2
end tell

tell application "System Events"
    keystroke "p" using command down
    delay 1
    keystroke return
end tell
EOF
