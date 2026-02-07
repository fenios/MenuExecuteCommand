import Foundation
import Observation

@Observable
@MainActor
class CommandRunner {
    private var processes: [UUID: Process] = [:]
    var runningCommandIds: Set<UUID> = []
    
    func toggle(command: Command, onCompletion: @escaping @Sendable @MainActor (UUID, String) -> Void) {
        if runningCommandIds.contains(command.id) {
            stop(command: command)
        } else {
            start(command: command, onCompletion: onCompletion)
        }
    }
    
    func start(command: Command, onCompletion: @escaping @Sendable @MainActor (UUID, String) -> Void) {
        let validation = ScriptValidator.validate(command.script)
        if !validation.isValid {
            let errorMsg = "Blocked: \(validation.message ?? "Security violation")"
            onCompletion(command.id, errorMsg)
            return
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", command.script]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        process.terminationHandler = { [weak self] proc in
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            
            Task { @MainActor in
                onCompletion(command.id, output)
                self?.runningCommandIds.remove(command.id)
                self?.processes.removeValue(forKey: command.id)
            }
        }
        
        do {
            try process.run()
            processes[command.id] = process
            runningCommandIds.insert(command.id)
        } catch {
            print("Failed to start command \(command.name): \(error)")
        }
    }
    
    func stop(command: Command) {
        if let process = processes[command.id] {
            process.terminate()
            // Termination handler will cleanup
        }
    }
    
    func stopAll() {
        for process in processes.values {
            process.terminate()
        }
    }
}