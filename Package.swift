// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MobileDeviceKit",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MobileDeviceKit",
            targets: ["MobileDeviceKit"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CMobileDeviceKit",
            publicHeadersPath: "include",
            swiftSettings: [
                .define("SPM"),
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker",
                    "./Dependencies/AOSKit.tbd",
                    "-Xlinker",
                    "./Dependencies/MobileDevice.tbd",
                    "-Xlinker",
                    "./Dependencies/AirTrafficHost.tbd",
                ]),
            ]
        ),
        .target(
            name: "MobileDeviceKit",
            dependencies: ["CMobileDeviceKit"]

        ),
        .executableTarget(
            name: "MobileDeviceKitDemo",
            dependencies: ["MobileDeviceKit"]
        ),
        .testTarget(
            name: "MobileDeviceKitTests",
            dependencies: ["CMobileDeviceKit", "MobileDeviceKit"]
        ),
    ]
)
