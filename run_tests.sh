#!/bin/bash

echo "🚀 Iniciando pruebas para MenuExecuteCommand..."

# 1. Compilar la aplicación
echo "📦 Compilando..."
swift build

# 2. Ejecutar Unit Tests
echo "🧪 Ejecutando Unit Tests (Swift Testing)..."
swift test --filter MenuExecuteCommandTests

# 3. Ejecutar UI Tests usando xcodebuild (única forma de habilitar el UI Host)
echo "🖼️ Ejecutando UI Tests y capturando pantallas..."
echo "Nota: Esto abrirá la aplicación y requerirá permisos de accesibilidad si es la primera vez."

xcodebuild test 
  -scheme MenuExecuteCommand 
  -destination 'platform=macOS' 
  -only-testing MenuExecuteCommandUITests 
  -resultBundlePath ./TestResults.xcresult

echo "✅ Pruebas finalizadas."
echo "📂 Las capturas están dentro de ./TestResults.xcresult (puedes abrirlo con Xcode)."
