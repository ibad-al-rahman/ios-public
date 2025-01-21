// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IbadAnalytics",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "IbadAnalytics", targets: ["IbadAnalytics"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            .upToNextMajor(from: "1.0.0")
        ),
    ],
    targets: [
        .target(
            name: "IbadAnalytics",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
        .testTarget(name: "IbadAnalyticsTests", dependencies: ["IbadAnalytics"])
    ]
)
