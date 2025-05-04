// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IbadRepositories",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "IbadRepositories", targets: ["IbadRepositories"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            .upToNextMajor(from: "1.6.1")
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-identified-collections",
            .upToNextMajor(from: "1.1.0")
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-sharing",
            .upToNextMajor(from: "2.1.0")
        )
    ],
    targets: [
        .target(name: "IbadRepositories", dependencies: [
            .product(name: "Dependencies", package: "swift-dependencies"),
            .product(name: "DependenciesMacros", package: "swift-dependencies"),
            .product(
                name: "IdentifiedCollections",
                package: "swift-identified-collections"
            ),
            .product(name: "Sharing", package: "swift-sharing")
        ]),
        .testTarget(name: "IbadRepositoriesTests", dependencies: ["IbadRepositories"]),
    ]
)
