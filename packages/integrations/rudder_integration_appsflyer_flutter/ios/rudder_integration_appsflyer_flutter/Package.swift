// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "rudder_integration_appsflyer_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "rudder-integration-appsflyer-flutter", targets: ["rudder_integration_appsflyer_flutter"])
    ],
    dependencies: [
        .package(name: "rudder_plugin_ios", path: "../rudder_plugin_ios"),
        .package(url: "https://github.com/rudderlabs/rudder-integration-appsflyer-ios.git", "3.0.0"..<"4.0.0")
    ],
    targets: [
        .target(
            name: "rudder_integration_appsflyer_flutter",
            dependencies: [
                .product(name: "rudder-plugin-ios", package: "rudder_plugin_ios"),
                .product(name: "Rudder-Appsflyer", package: "rudder-integration-appsflyer-ios")
            ],
            path: "Sources/rudder_integration_appsflyer_flutter",
            publicHeadersPath: "include"
        )
    ]
)
