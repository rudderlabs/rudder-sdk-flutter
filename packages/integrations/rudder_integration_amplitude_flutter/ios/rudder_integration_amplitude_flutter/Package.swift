// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "rudder_integration_amplitude_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "rudder-integration-amplitude-flutter", targets: ["rudder_integration_amplitude_flutter"])
    ],
    dependencies: [
        .package(name: "rudder_plugin_ios", path: "../rudder_plugin_ios"),
        .package(url: "https://github.com/rudderlabs/rudder-integration-amplitude-ios.git", "1.3.1"..<"2.0.0")
    ],
    targets: [
        .target(
            name: "rudder_integration_amplitude_flutter",
            dependencies: [
                .product(name: "rudder-plugin-ios", package: "rudder_plugin_ios"),
                .product(name: "Rudder-Amplitude", package: "rudder-integration-amplitude-ios")
            ],
            path: "Sources/rudder_integration_amplitude_flutter",
            publicHeadersPath: "include"
        )
    ]
)
