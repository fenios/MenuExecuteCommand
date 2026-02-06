// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MenuExecuteCommand",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [],
        targets: [
            .executableTarget(
                name: "MenuExecuteCommand",
                dependencies: [],
                path: "Sources/MenuExecuteCommand",
                resources: []
            ),
                    .testTarget(
                        name: "MenuExecuteCommandTests",
                        dependencies: ["MenuExecuteCommand"],
                        path: "Tests/MenuExecuteCommandTests"
                    ),
                    .testTarget(
                        name: "MenuExecuteCommandUITests",
                        dependencies: ["MenuExecuteCommand"],
                        path: "Tests/MenuExecuteCommandUITests"
                    )
                ]
            )
            