// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IbadAzan",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "IbadAzan", targets: ["IbadAzan"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ibad-al-rahman/azan", from: "0.3.2"),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            .upToNextMajor(from: "1.6.1")
        ),
    ],
    targets: [
        .target(name: "IbadAzan", dependencies: [
            .product(name: "Azan", package: "azan"),
            .product(name: "Dependencies", package: "swift-dependencies"),
            .product(name: "DependenciesMacros", package: "swift-dependencies"),
        ]),
    ]
)
