// swift-tools-version:5.2
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
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "WorldConquer", dependencies: []),
        .target(name: "WorldConquerApp", dependencies: ["WorldConquer"]),
        .testTarget(name: "WorldConquerTests", dependencies: ["WorldConquer"]),
    ]
)
