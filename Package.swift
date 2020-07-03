// swift-tools-version:5.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "ToothpasteSqueezer",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "ToothpasteSqueezer", targets: ["ToothpasteSqueezer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Samasaur1/SwiftySCADKit", .branch("dsl")),
    ],
    targets: [
        .target(name: "ToothpasteSqueezer", dependencies: ["SwiftySCADKit"]),
        .testTarget(name: "ToothpasteSqueezerTests", dependencies: ["ToothpasteSqueezer"]),
    ]
)
