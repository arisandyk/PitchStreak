// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ProfileFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "ProfileFeature", targets: ["ProfileFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/arisandyk/PitchStreak-Core.git", from: "1.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.7.0")
    ],
    targets: [
        .target(
            name: "ProfileFeature",
            dependencies: [
                .product(name: "Core", package: "PitchStreak-Core"),
                .product(name: "RxSwift", package: "RxSwift")
            ]
        )
    ]
)
