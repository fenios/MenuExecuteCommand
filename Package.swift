// swift-tools-version: 5.9
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
            dependencies: ["MenuExecuteCommand"]
        )
    ]
)