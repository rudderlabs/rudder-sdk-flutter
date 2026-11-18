// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "rudder_sdk_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "rudder-sdk-flutter", targets: ["rudder_sdk_flutter"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/rudderlabs/rudder-sdk-swift.git", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "rudder_sdk_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "RudderStackAnalytics", package: "rudder-sdk-swift")
            ]
        )
    ]
)
