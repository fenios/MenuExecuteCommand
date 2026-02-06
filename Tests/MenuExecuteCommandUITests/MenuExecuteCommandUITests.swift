import XCTest

@MainActor
final class MenuExecuteCommandUITests: XCTestCase {
    var app: XCUIApplication?

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // Initialize with bundle identifier. 
        // Note: For this to work, the app must have been built/run at least once 
        // so macOS registers the bundle identifier.
        let bundleID = "com.fenios.MenuExecuteCommand"
        let application = XCUIApplication(bundleIdentifier: bundleID)
        
        // Defensive check
        if application.exists || true { // XCUIApplication init always returns an object, 'exists' check is for the process
            self.app = application
        }
        
        guard let app = self.app else {
            XCTFail("Could not initialize XCUIApplication for bundle ID: \(bundleID)")
            return
        }
        
        app.launch()
    }

    func testCaptureScreenshots() throws {
        guard let app = self.app else { 
            XCTFail("App not initialized")
            return 
        }

        // 1. Capture Menu Bar Status Item
        // We look for the item in the system-wide status bar
        let systemUI = XCUIApplication(bundleIdentifier: "com.apple.controlcenter")
        let menuBarItem = systemUI.statusItems["MenuCommand"]
        
        if menuBarItem.waitForExistence(timeout: 5) {
            menuBarItem.click()
            
            let screenshot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = "menu_bar"
            attachment.lifetime = .keepAlways
            add(attachment)
        } else {
            print("System tray icon 'MenuCommand' not found. Ensure the app is running and the icon is visible.")
        }

        // 2. Open Settings and capture
        // We try to trigger it via the menu item if we just clicked it
        let settingsMenu = systemUI.menuItems["Settings..."]
        if settingsMenu.waitForExistence(timeout: 2) {
            settingsMenu.click()
            
            let settingsWindow = app.windows["Settings"]
            if settingsWindow.waitForExistence(timeout: 5) {
                let screenshot = settingsWindow.screenshot()
                let attachment = XCTAttachment(screenshot: screenshot)
                attachment.name = "settings"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
        }
    }
}
