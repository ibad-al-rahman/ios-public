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
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            .upToNextMajor(from: "11.7.0")
        )
    ],
    targets: [
        .target(
            name: "IbadAnalytics",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(
                    name: "FirebaseAnalytics", package: "firebase-ios-sdk"
                ),
                .product(
                    name: "FirebaseCrashlytics", package: "firebase-ios-sdk"
                )
            ]
        ),
        .testTarget(name: "IbadAnalyticsTests", dependencies: ["IbadAnalytics"])
    ]
)
