// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IbadPrayerTimesRepository",
    platforms: [.iOS(.v17), .macOS(.v11)],
    products: [
        .library(name: "IbadPrayerTimesRepository", targets: ["IbadPrayerTimesRepository"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.6.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.7.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-http-types", from: "1.0.2"),
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
        ),
    ],
    targets: [
        .target(
            name: "IbadPrayerTimesRepository",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(
                    name: "IdentifiedCollections",
                    package: "swift-identified-collections"
                ),
                .product(name: "Sharing", package: "swift-sharing"),
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
            ]
        ),
    ]
)
