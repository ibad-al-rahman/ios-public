// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MiqatKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "MiqatKit", targets: ["MiqatKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ibad-al-rahman/miqat", from: "0.4.0"),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            .upToNextMajor(from: "1.6.1")
        ),
    ],
    targets: [
        .target(name: "MiqatKit", dependencies: [
            .product(name: "Miqat", package: "miqat"),
            .product(name: "Dependencies", package: "swift-dependencies"),
            .product(name: "DependenciesMacros", package: "swift-dependencies"),
        ]),
    ]
)
