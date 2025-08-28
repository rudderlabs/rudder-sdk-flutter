// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "rudder_plugin_ios",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "rudder-plugin-ios", targets: ["rudder_plugin_ios"])
    ],
    dependencies: [
        .package(url: "https://github.com/rudderlabs/rudder-sdk-ios.git", from: "1.31.1")
    ],
    targets: [
        .target(
            name: "rudder_plugin_ios",
            dependencies: [
                .product(name: "Rudder", package: "rudder-sdk-ios")
            ],
            path: "Sources/rudder_plugin_ios",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include/rudder_plugin_ios")
            ]
        )
    ]
)