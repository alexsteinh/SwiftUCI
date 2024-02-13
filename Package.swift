// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftUCI",
    platforms: [
        .iOS(.v16), .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftUCI",
            targets: ["SwiftUCI"]),
    ],
    targets: [
        .target(
            name: "SwiftUCI",
            swiftSettings: [.enableUpcomingFeature("BareSlashRegexLiterals")]),
        .testTarget(
            name: "SwiftUCITests",
            dependencies: ["SwiftUCI"]),
    ]
)
