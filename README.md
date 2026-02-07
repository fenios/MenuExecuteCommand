# MenuExecuteCommand

A lightweight macOS system tray application to manage and execute Bash commands.

![Menu Bar Interface](docs/screenshots/menu_bar.png)
*Quick access to all your commands from the system tray.*

## Features
- **System Tray Presence:** Runs in the menu bar for quick access.
- **On/Off Toggles:** Start and stop commands with a single click.
- **Concurrent Execution:** Run multiple commands simultaneously in the background.
- **Persistence:** Commands and their states are saved and restored across restarts.
- **Launch at Login:** Option to start the app automatically when you log in.
- **Log Viewing:** See the last output of your commands in the settings window.

![Settings Window](docs/screenshots/settings.png)
*Manage commands and view logs.*

## Development & Testing
### Unit Tests
The project uses the modern **Swift Testing** framework. To run tests from the command line:
```bash
swift test
```

### UI Tests & Screenshots
UI tests are configured to automate interactions and capture screenshots. Due to macOS security, these must be run from Xcode:
1. Open `Package.swift` in Xcode.
2. Select the `MenuExecuteCommand` scheme.
3. Press `Cmd+U` to run tests.
4. Screenshots will be available in the Xcode Test Report (under the "Attachments" icon for each test step).
5. Save these screenshots to `docs/screenshots/` to update this documentation.

## How to Open in Xcode
1. Open Xcode.
2. Select **File > Open**.
3. Navigate to the project directory and select the `Package.swift` file.
4. Xcode will load the project as a Swift Package.

## How to Run
- Once opened in Xcode, select the `MenuExecuteCommand` target and click **Run**.
- The application icon (a terminal symbol) will appear in your macOS menu bar.

## Configuration
- Click the menu bar icon and select **Settings...** to add, remove, or view logs for your commands.
- Configured commands are stored in `~/Library/Application Support/MenuExecuteCommand/commands.json`.
