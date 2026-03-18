// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IbadRemoteConfig",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "IbadRemoteConfig", targets: ["IbadRemoteConfig"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ibad-al-rahman/swift-pmff",
            .upToNextMajor(from: "0.5.1")
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            .upToNextMajor(from: "1.6.1")
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-sharing",
            .upToNextMajor(from: "2.1.0")
        )
    ],
    targets: [
        .target(name: "IbadRemoteConfig", dependencies: [
            .product(name: "Pmff", package: "swift-pmff"),
            .product(name: "Dependencies", package: "swift-dependencies"),
            .product(name: "DependenciesMacros", package: "swift-dependencies"),
            .product(name: "Sharing", package: "swift-sharing")
        ]),
        .testTarget(
            name: "IbadRemoteConfigTests",
            dependencies: ["IbadRemoteConfig"]
        ),
    ]
)
