// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "rudder_integration_firebase_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "rudder-integration-firebase-flutter", targets: ["rudder_integration_firebase_flutter"])
    ],
    dependencies: [
        .package(name: "rudder_plugin_ios", path: "../rudder_plugin_ios"),
        .package(url: "https://github.com/rudderlabs/rudder-integration-firebase-ios.git", "3.6.0"..<"4.0.0")
    ],
    targets: [
        .target(
            name: "rudder_integration_firebase_flutter",
            dependencies: [
                .product(name: "rudder-plugin-ios", package: "rudder_plugin_ios"),
                .product(name: "Rudder-Firebase", package: "rudder-integration-firebase-ios")
            ],
            path: "Sources/rudder_integration_firebase_flutter",
            publicHeadersPath: "include"
        )
    ]
)
