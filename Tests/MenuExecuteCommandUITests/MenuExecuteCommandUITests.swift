import XCTest

@MainActor
final class MenuExecuteCommandUITests: XCTestCase {
    
    // Acceso seguro a la app mediante su Bundle ID configurado en el Info.plist
    var app: XCUIApplication {
        XCUIApplication(bundleIdentifier: "com.fenios.MenuExecuteCommand")
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // Verificación de seguridad: Evita el crash si no estamos en un host de UI Testing
        // Si se corre vía 'swift test' (que no soporta UI), saltará la prueba limpiamente.
        guard ProcessInfo.processInfo.environment["XCTestBundlePath"]?.contains(".xctest") == true else {
            throw XCTSkip("Entorno no compatible con UI Testing. Use Xcode o el script run_tests.sh")
        }
    }

    func testCaptureScreenshots() throws {
        let app = self.app
        app.launch()

        // 1. Localizar el icono en el System Tray
        // macOS aloja los status items en el proceso del Control Center
        let controlCenter = XCUIApplication(bundleIdentifier: "com.apple.controlcenter")
        let menuBarItem = controlCenter.statusItems["MenuCommand"]
        
        XCTAssertTrue(menuBarItem.waitForExistence(timeout: 15), "No se encontró el icono de la app en la barra de menú.")
        
        menuBarItem.click()
        
        // Captura de la barra de menú abierta
        let menuScreenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: menuScreenshot)
        attachment.name = "menu_bar_opened"
        attachment.lifetime = .keepAlways
        add(attachment)
        
        // 2. Abrir Settings
        let settingsMenu = controlCenter.menuItems["Settings..."]
        if settingsMenu.waitForExistence(timeout: 5) {
            settingsMenu.click()
            
            // Captura de la ventana de configuración
            let settingsWindow = app.windows["Settings"]
            if settingsWindow.waitForExistence(timeout: 5) {
                let settingsScreenshot = settingsWindow.screenshot()
                let settingsAttachment = XCTAttachment(screenshot: settingsScreenshot)
                settingsAttachment.name = "settings_window"
                settingsAttachment.lifetime = .keepAlways
                add(settingsAttachment)
            }
        }
    }
}