// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BsSolutionsBastionSmsPlugin",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "BsSolutionsBastionSmsPlugin",
            targets: ["BastionSMSPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "6.2.0")
    ],
    targets: [
        .target(
            name: "BastionSMSPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/BastionSMSPlugin"),
        .testTarget(
            name: "BastionSMSPluginTests",
            dependencies: ["BastionSMSPlugin"],
            path: "ios/Tests/BastionSMSPluginTests")
    ]
)
