import Foundation
import Combine

class CommandRunner: ObservableObject {
    private var processes: [UUID: Process] = [:]
    @Published var runningCommandIds: Set<UUID> = []
    
    func toggle(command: Command, onCompletion: @escaping (UUID, String) -> Void) {
        if runningCommandIds.contains(command.id) {
            stop(command: command)
        } else {
            start(command: command, onCompletion: onCompletion)
        }
    }
    
    func start(command: Command, onCompletion: @escaping (UUID, String) -> Void) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", command.script]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        process.terminationHandler = { [weak self] proc in
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            
            DispatchQueue.main.async {
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
