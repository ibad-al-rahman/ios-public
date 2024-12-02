// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IbadRepositories",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "IbadRepositories", targets: ["IbadRepositories"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Alamofire/Alamofire",
            .upToNextMajor(from: "5.10.1")
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            .upToNextMajor(from: "1.6.1")
        )
    ],
    targets: [
        .target(name: "IbadRepositories", dependencies: [
            .product(name: "Alamofire", package: "Alamofire"),
            .product(name: "Dependencies", package: "swift-dependencies")
        ]),
        .testTarget(name: "IbadRepositoriesTests", dependencies: ["IbadRepositories"]),
    ]
)
