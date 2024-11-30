// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repositories",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Repositories", targets: ["Repositories"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(name: "Repositories"),
        .testTarget(name: "RepositoriesTests", dependencies: ["Repositories"]),
    ]
)
