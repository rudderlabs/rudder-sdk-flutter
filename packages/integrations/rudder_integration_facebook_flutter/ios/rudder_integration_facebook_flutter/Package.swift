// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "rudder_integration_facebook_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "rudder-integration-facebook-flutter", targets: ["rudder_integration_facebook_flutter"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(name: "rudder_sdk_flutter", path: "../rudder_sdk_flutter"),
        .package(url: "https://github.com/rudderlabs/integration-swift-facebook.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "rudder_integration_facebook_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "rudder-sdk-flutter", package: "rudder_sdk_flutter"),
                .product(name: "RudderIntegrationFacebook", package: "integration-swift-facebook")
            ]
        )
    ]
)
