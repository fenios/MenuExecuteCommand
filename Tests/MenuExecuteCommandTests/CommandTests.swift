import XCTest
@testable import MenuExecuteCommand

final class CommandTests: XCTestCase {
    func testCommandInitialization() {
        let command = Command(name: "Test", script: "echo hello")
        XCTAssertEqual(command.name, "Test")
        XCTAssertEqual(command.script, "echo hello")
        XCTAssertFalse(command.isEnabled)
    }
    
    func testCommandEquality() {
        let id = UUID()
        let cmd1 = Command(id: id, name: "A", script: "B")
        let cmd2 = Command(id: id, name: "C", script: "D")
        XCTAssertEqual(cmd1, cmd2)
    }
    
    func testStoreInitialLoad() {
        let store = CommandStore()
        XCTAssertFalse(store.commands.isEmpty)
    }
}
