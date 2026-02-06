import XCTest

@MainActor
final class MenuExecuteCommandUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // Absolute path to the built binary
        let binaryPath = "/Users/nano/Projectos/MenuExecuteCommand/.build/arm64-apple-macosx/debug/MenuExecuteCommand"
        let executableURL = URL(fileURLWithPath: binaryPath)
        
        if FileManager.default.fileExists(atPath: binaryPath) {
            app = XCUIApplication(url: executableURL)
        } else {
            // Fallback to bundle ID if path fails
            app = XCUIApplication(bundleIdentifier: "com.fenios.MenuExecuteCommand")
        }
        
        app.launch()
    }

    func testCaptureScreenshots() throws {
        // 1. Capture Menu Bar Status Item
        // Note: statusItems are part of the system-wide menu bar
        let systemUI = XCUIApplication(bundleIdentifier: "com.apple.controlcenter")
        let menuBarItem = systemUI.statusItems["MenuCommand"]
        
        if menuBarItem.waitForExistence(timeout: 5) {
            menuBarItem.click()
            let screenshot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = "menu_bar"
            attachment.lifetime = .keepAlways
            add(attachment)
        }

        // 2. Open Settings and capture
        // We might need to click the app menu item "Settings..."
        // In some macOS versions, MenuBarExtra shows up in the app's own process too
        let appMenu = app.menuBars.statusItems["MenuCommand"]
        if appMenu.exists {
            appMenu.click()
            app.menuItems["Settings..."].click()
        }

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