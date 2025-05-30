// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Components",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Components",
            targets: ["Components"]
        ),
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
    ],
    targets: [
        .target(
            name: "Components",
            dependencies: [
                "DesignSystem",
            ]
        ),
        .testTarget(
            name: "ComponentsTests",
            dependencies: ["Components"]
        ),
    ]
)
