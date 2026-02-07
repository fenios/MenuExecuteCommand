import XCTest

@MainActor
final class MenuExecuteCommandUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // Evitamos el crash de inicialización en entornos no-UI
        guard ProcessInfo.processInfo.environment["XCTestBundlePath"]?.contains(".xctest") == true else {
            throw XCTSkip("Saltando UI Test: Solo ejecutable vía Xcode o xcodebuild.")
        }
        
        // Usamos el bundle identifier para referenciar la app de forma global
        // Esto evita que XCUITest intente buscar un 'Host Application' dentro del bundle de tests
        app = XCUIApplication(bundleIdentifier: "com.fenios.MenuExecuteCommand")
    }

    func testCaptureScreenshots() throws {
        // Intentamos lanzar la app. Si falla porque no está "instalada", el test fallará con un error claro.
        app.launch()

        // 1. Captura del icono en el System Tray
        let controlCenter = XCUIApplication(bundleIdentifier: "com.apple.controlcenter")
        let menuBarItem = controlCenter.statusItems["MenuCommand"]
        
        XCTAssertTrue(menuBarItem.waitForExistence(timeout: 20), "No se encontró el icono 'MenuCommand' en la barra de menú.")
        
        menuBarItem.click()
        
        // Captura de la barra de menú desplegada
        let menuScreenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: menuScreenshot)
        attachment.name = "01_menu_bar_opened"
        attachment.lifetime = .keepAlways
        add(attachment)
        
        // 2. Abrir la ventana de Settings
        // Buscamos el texto "Settings..." en el menú que acaba de aparecer
        let settingsMenu = controlCenter.menuItems["Settings..."]
        if settingsMenu.waitForExistence(timeout: 5) {
            settingsMenu.click()
            
            // La ventana de Settings pertenece al proceso de la app, no al Control Center
            let settingsWindow = app.windows["Settings"]
            if settingsWindow.waitForExistence(timeout: 10) {
                let settingsScreenshot = settingsWindow.screenshot()
                let settingsAttachment = XCTAttachment(screenshot: settingsScreenshot)
                settingsAttachment.name = "02_settings_window"
                settingsAttachment.lifetime = .keepAlways
                add(settingsAttachment)
            }
        }
    }
}
