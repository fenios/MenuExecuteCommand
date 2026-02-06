import XCTest

@MainActor
final class MenuExecuteCommandUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        // We must perform actor-isolated setup in a way that respects the base class
        app = XCUIApplication()
        app.launch()
    }

    func testCaptureScreenshots() throws {
        // 1. Capture Menu Bar (Note: MenuBarExtra is tricky to access via UI tests in some environments)
        // We simulate clicking the status item if possible, or just focus on the windows.
        
        let menuBar = app.menuBars.statusItems["MenuCommand"]
        if menuBar.exists {
            menuBar.click()
            let screenshot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.lifetime = .keepAlways
            add(attachment)
        }

        // 2. Open Settings and capture
        app.menuBars.statusItems["MenuCommand"].menuItems["Settings..."].click()
        
        let settingsWindow = app.windows["Settings"]
        if settingsWindow.waitForExistence(timeout: 5) {
            let screenshot = settingsWindow.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}
