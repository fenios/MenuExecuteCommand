import SwiftUI
import ServiceManagement

@main
struct MenuExecuteCommandApp: App {
    @StateObject private var store = CommandStore()
    @StateObject private var runner = CommandRunner()
    
    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }
    
    var body: some Scene {
        MenuBarExtra("MenuCommand", systemImage: "terminal") {
            AppMenuView(store: store, runner: runner)
        }
        
        Settings {
            SettingsView(store: store)
        }
    }
}

struct AppMenuView: View {
    @ObservedObject var store: CommandStore
    @ObservedObject var runner: CommandRunner
    
    var body: some View {
        Group {
            ForEach(store.commands) { command in
                Button {
                    if let index = store.commands.firstIndex(where: { $0.id == command.id }) {
                        store.commands[index].isEnabled.toggle()
                        runner.toggle(command: store.commands[index]) { id, output in
                            if let idx = store.commands.firstIndex(where: { $0.id == id }) {
                                store.commands[idx].lastOutput = output
                                store.commands[idx].isEnabled = false
                            }
                        }
                    }
                } label: {
                    HStack {
                        if runner.runningCommandIds.contains(command.id) {
                            Image(systemName: "checkmark.circle.fill")
                        } else {
                            Image(systemName: "circle")
                        }
                        Text(command.name)
                    }
                }
            }
        }
        .onAppear {
            for command in store.commands where command.isEnabled {
                if !runner.runningCommandIds.contains(command.id) {
                    runner.start(command: command) { id, output in
                        if let idx = store.commands.firstIndex(where: { $0.id == id }) {
                            store.commands[idx].lastOutput = output
                            store.commands[idx].isEnabled = false
                        }
                    }
                }
            }
        }
        
        Divider()
        
        SettingsLink {
            Text("Settings...")
        }
        .keyboardShortcut(",", modifiers: .command)
        
        Divider()
        
        LaunchAtLoginToggle()
        
        Divider()
        
        Button("Quit") {
            runner.stopAll()
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q", modifiers: .command)
    }
}

struct SettingsView: View {
    @ObservedObject var store: CommandStore
    @State private var newCommandName = ""
    @State private var newCommandScript = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(store.commands) { command in
                    VStack(alignment: .leading) {
                        Text(command.name).font(.headline)
                        Text(command.script).font(.caption).foregroundColor(.secondary)
                        if let output = command.lastOutput, !output.isEmpty {
                            Text("Last Output:").font(.caption2).padding(.top, 2)
                            Text(output)
                                .font(.system(.caption2, design: .monospaced))
                                .padding(4)
                                .background(Color.black.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                    .contextMenu {
                        Button("Delete", role: .destructive) {
                            store.commands.removeAll { $0.id == command.id }
                        }
                    }
                }
                .onDelete { indexSet in
                    store.commands.remove(atOffsets: indexSet)
                }
            }
            
            Divider()
            
            VStack {
                TextField("Command Name", text: $newCommandName)
                TextField("Bash Script", text: $newCommandScript)
                Button("Add Command") {
                    if !newCommandName.isEmpty && !newCommandScript.isEmpty {
                        store.commands.append(Command(name: newCommandName, script: newCommandScript))
                        newCommandName = ""
                        newCommandScript = ""
                    }
                }
                .disabled(newCommandName.isEmpty || newCommandScript.isEmpty)
            }
            .padding()
        }
        .frame(width: 400, height: 500)
                .padding()
            }
        }
        
        struct LaunchAtLoginToggle: View {
            @State private var isOn: Bool = SMAppService.mainApp.status == .enabled
        
            var body: some View {
                Button(isOn ? "Disable Launch at Login" : "Enable Launch at Login") {
                    toggle()
                }
            }
        
            func toggle() {
                do {
                    if isOn {
                        try SMAppService.mainApp.unregister()
                    } else {
                        try SMAppService.mainApp.register()
                    }
                    isOn = SMAppService.mainApp.status == .enabled
                } catch {
                    print("Failed to toggle launch at login: \(error)")
                }
            }
        }
        