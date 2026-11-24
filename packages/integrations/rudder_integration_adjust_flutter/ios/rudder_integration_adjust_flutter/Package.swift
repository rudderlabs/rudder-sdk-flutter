// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "rudder_integration_adjust_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "rudder-integration-adjust-flutter", targets: ["rudder_integration_adjust_flutter"])
    ],
    dependencies: [
        .package(name: "rudder_plugin_ios", path: "../rudder_plugin_ios"),
        .package(url: "https://github.com/rudderlabs/rudder-integration-adjust-ios.git", "2.3.0"..<"3.0.0")
    ],
    targets: [
        .target(
            name: "rudder_integration_adjust_flutter",
            dependencies: [
                .product(name: "rudder-plugin-ios", package: "rudder_plugin_ios"),
                .product(name: "Rudder-Adjust", package: "rudder-integration-adjust-ios")
            ],
            path: "Sources/rudder_integration_adjust_flutter",
            publicHeadersPath: "include"
        )
    ]
)
