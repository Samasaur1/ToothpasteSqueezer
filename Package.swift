// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "ToothpasteSqueezer",
    dependencies: [
        .package(url: "https://github.com/Samasaur1/SwiftySCADKit", .branch("master")),
    ],
    targets: [
        .target(name: "ToothpasteSqueezer", dependencies: ["SwiftySCADKit"]),
        .testTarget(name: "ToothpasteSqueezerTests", dependencies: ["ToothpasteSqueezer"]),
    ]
)
