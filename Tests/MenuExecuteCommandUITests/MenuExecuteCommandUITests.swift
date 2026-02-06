import XCTest

@MainActor
final class MenuExecuteCommandUITests: XCTestCase {
    
    // We use a computed property to avoid initialization issues in non-UI contexts
    var app: XCUIApplication {
        XCUIApplication(bundleIdentifier: "com.fenios.MenuExecuteCommand")
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // Check if we are running in a UI testing environment
        // This prevents the "Device is not configured for UI testing" crash during 'swift test'
        guard ProcessInfo.processInfo.environment["XCTestBundlePath"]?.contains(".xctest") == true else {
            throw XCTSkip("Skipping UI Test: XCUIApplication is only supported in UI Test bundles run via Xcode.")
        }
    }

    func testCaptureScreenshots() throws {
        // 1. Launch the app
        let app = self.app
        app.launch()

        // 2. Capture Menu Bar Status Item
        // In macOS 14+, status items are often hosted in the Control Center or SystemUIServer
        let controlCenter = XCUIApplication(bundleIdentifier: "com.apple.controlcenter")
        let menuBarItem = controlCenter.statusItems["MenuCommand"]
        
        if menuBarItem.waitForExistence(timeout: 10) {
            menuBarItem.click()
            
            // Capture the menu
            let screenshot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = "menu_bar_visible"
            attachment.lifetime = .keepAlways
            add(attachment)
            
            // 3. Open Settings
            // We search for the "Settings..." menu item in the recently opened menu
            let settingsMenuItem = controlCenter.menuItems["Settings..."]
            if settingsMenuItem.waitForExistence(timeout: 5) {
                settingsMenuItem.click()
                
                let settingsWindow = app.windows["Settings"]
                if settingsWindow.waitForExistence(timeout: 5) {
                    let settingsScreenshot = settingsWindow.screenshot()
                    let settingsAttachment = XCTAttachment(screenshot: settingsScreenshot)
                    settingsAttachment.name = "settings_window"
                    settingsAttachment.lifetime = .keepAlways
                    add(settingsAttachment)
                }
            }
        } else {
            XCTFail("Could not find the system tray icon 'MenuCommand'. Ensure the app is built and running.")
        }
    }
}