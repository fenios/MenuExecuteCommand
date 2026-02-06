#!/bin/bash

echo "🚀 Iniciando pruebas para MenuExecuteCommand..."

# 1. Compilar la aplicación
echo "📦 Compilando..."
swift build

# 2. Registrar la App en el sistema (Necesario para que el Bundle ID funcione)
echo "🔗 Registrando Bundle ID..."
APP_PATH=$(find .build -name MenuExecuteCommand -type f | head -n 1)
# Abrimos y cerramos la app rápido para que LaunchServices la registre
open "$APP_PATH"
sleep 2
pkill MenuExecuteCommand

# 3. Ejecutar Unit Tests
echo "🧪 Ejecutando Unit Tests..."
swift test --filter MenuExecuteCommandTests

# 4. Ejecutar UI Tests usando xcodebuild
echo "🖼️ Ejecutando UI Tests..."
xcodebuild test \
  -scheme MenuExecuteCommand \
  -destination 'platform=macOS' \
  -only-testing MenuExecuteCommandUITests \
  -resultBundlePath ./TestResults.xcresult \
  -derivedDataPath ./DerivedData

echo "✅ Pruebas finalizadas."
