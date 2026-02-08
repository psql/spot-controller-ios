// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SpotController",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "SpotSDK", targets: ["SpotSDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.21.0")
    ],
    targets: [
        .target(
            name: "SpotSDK",
            dependencies: [
                .product(name: "GRPC", package: "grpc-swift")
            ],
            path: "SpotSDK"
        )
    ]
)
