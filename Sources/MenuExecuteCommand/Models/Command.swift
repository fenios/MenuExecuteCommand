import Foundation

struct Command: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var script: String
    var isEnabled: Bool = false
    var lastOutput: String?
    
    static func == (lhs: Command, rhs: Command) -> Bool {
        lhs.id == rhs.id
    }
}
