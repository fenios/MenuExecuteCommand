import Foundation
import SwiftUI

class CommandStore: ObservableObject {
    @Published var commands: [Command] = [] {
        didSet {
            save()
        }
    }
    
    private let fileURL: URL = {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDirectory = appSupport.appendingPathComponent("MenuExecuteCommand", isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: appDirectory.path) {
            try? FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true)
        }
        
        return appDirectory.appendingPathComponent("commands.json")
    }()
    
    init() {
        load()
        if commands.isEmpty {
            // Default example commands
            commands = [
                Command(name: "Ping Localhost", script: "ping -c 4 localhost"),
                Command(name: "List Files", script: "ls -la ~")
            ]
        }
    }
    
    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Command].self, from: data) {
            self.commands = decoded
        }
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(commands) {
            try? encoded.write(to: fileURL)
        }
    }
}
