import Testing
import Foundation
@testable import MenuExecuteCommand

@Suite("Command Model and Store Tests")
@MainActor
struct CommandTests {
    
    @Test("Command initialization sets correct properties")
    func commandInitialization() {
        let command = Command(name: "Test", script: "echo hello")
        #expect(command.name == "Test")
        #expect(command.script == "echo hello")
        #expect(command.isEnabled == false)
    }
    
    @Test("Command equality is based on ID")
    func commandEquality() {
        let id = UUID()
        let cmd1 = Command(id: id, name: "A", script: "B")
        let cmd2 = Command(id: id, name: "C", script: "D")
        #expect(cmd1 == cmd2)
    }
    
    @Test("Store loads default commands when empty")
    func storeInitialLoad() {
        let store = CommandStore()
        #expect(!store.commands.isEmpty)
    }
}