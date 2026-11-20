// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "rudder_sdk_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "rudder-sdk-flutter", targets: ["rudder_sdk_flutter", "rudder_sdk_flutter_startup"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/rudderlabs/rudder-sdk-swift.git", from: "2.2.0")
    ],
    targets: [
        .target(
            name: "rudder_sdk_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "RudderStackAnalytics", package: "rudder-sdk-swift")
            ]
        ),
        // Swift has no +load, so this Objective-C target calls the Swift setter at load time.
        .target(name: "rudder_sdk_flutter_startup", dependencies: ["rudder_sdk_flutter"], publicHeadersPath: ".")
    ]
)
