// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IbadDesign",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "IbadDesign", targets: ["IbadDesign"]),
    ],
    targets: [
        .target(
            name: "IbadDesign",
            resources: [.process("Fonts")]
        ),
        .testTarget(name: "IbadDesignTests", dependencies: ["IbadDesign"]),
    ]
)
