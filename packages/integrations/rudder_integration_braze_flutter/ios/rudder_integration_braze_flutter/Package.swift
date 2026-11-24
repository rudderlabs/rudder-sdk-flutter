// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "rudder_integration_braze_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "rudder-integration-braze-flutter", targets: ["rudder_integration_braze_flutter"])
    ],
    dependencies: [
        .package(name: "rudder_plugin_ios", path: "../rudder_plugin_ios"),
        .package(url: "https://github.com/rudderlabs/rudder-integration-braze-ios.git", "4.5.0"..<"5.0.0")
    ],
    targets: [
        .target(
            name: "rudder_integration_braze_flutter",
            dependencies: [
                .product(name: "rudder-plugin-ios", package: "rudder_plugin_ios"),
                .product(name: "Rudder-Braze", package: "rudder-integration-braze-ios")
            ],
            path: "Sources/rudder_integration_braze_flutter",
            publicHeadersPath: "include"
        )
    ]
)
