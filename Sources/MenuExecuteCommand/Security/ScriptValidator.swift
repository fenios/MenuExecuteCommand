import Foundation

struct ScriptValidator {
    static let blockedCommands = [
        "rm", "srm", "sudo", "su", "format", "mkfs", "dd",
        "curl", "wget", "nc", "netcat", "nmap",
        "kill", "killall", "pkill", "halt", "reboot", "shutdown",
        "chmod", "chown", "chgrp"
    ]
    
    static let blockedPatterns = [
        #">\s*/etc/"#, #">\s*/var/"#, #">\s*/bin/"#, #">\s*/sbin/"#, #">\s*/usr/bin/"#,
        #"\|\s*bash"#, #"\|\s*sh"#, #"base64\s+--decode"#, #"eval\s+"#
    ]
    
    struct ValidationResult {
        let isValid: Bool
        let violations: [String]
        
        var message: String? {
            if violations.isEmpty { return nil }
            return "Potentially dangerous content detected: " + violations.joined(separator: ", ")
        }
    }
    
    static func validate(_ script: String) -> ValidationResult {
        var violations: [String] = []
        
        for command in blockedCommands {
            let pattern = "\\b\(command)\\b"
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
                let range = NSRange(location: 0, length: script.utf16.count)
                if regex.firstMatch(in: script, options: [], range: range) != nil {
                    violations.append("Command '\(command)'")
                }
            }
        }
        
        for pattern in blockedPatterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
                let range = NSRange(location: 0, length: script.utf16.count)
                if regex.firstMatch(in: script, options: [], range: range) != nil {
                    violations.append("Pattern matches '\(pattern)'")
                }
            }
        }
        
        return ValidationResult(isValid: violations.isEmpty, violations: violations)
    }
}