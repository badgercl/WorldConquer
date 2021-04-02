// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WorldConquer",
    products: [
        .library(name: "WorldConquer", targets: ["WorldConquer"]),
        .executable(name: "WorldConquerApp", targets: ["WorldConquerApp"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "WorldConquer", dependencies: [.product(name: "Logging", package: "swift-log")]),
        .target(name: "WorldConquerApp", dependencies: ["WorldConquer", .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "WorldConquerTests",
            dependencies: ["WorldConquer"],
            resources: [.process("TestResources")]),
    ]
)
