// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IbadEnvironment",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "IbadEnvironment", targets: ["IbadEnvironment"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            .upToNextMajor(from: "1.6.1")
        )
    ],
    targets: [
        .target(name: "IbadEnvironment", dependencies: [
            .product(name: "Dependencies", package: "swift-dependencies"),
            .product(name: "DependenciesMacros", package: "swift-dependencies"),
        ]),
        .testTarget(name: "IbadEnvironmentTests", dependencies: ["IbadEnvironment"]),
    ]
)
