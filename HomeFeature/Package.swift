// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "HomeFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "HomeFeature", targets: ["HomeFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/arisandyk/PitchStreak-Core.git", from: "1.0.0"),
        .package(path: "../DesignSystem"),
        .package(path: "../PracticeFeature"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.7.0")
    ],
    targets: [
        .target(
            name: "HomeFeature",
            dependencies: [
                .product(name: "Core", package: "PitchStreak-Core"),
                "DesignSystem",
                "PracticeFeature",
                .product(name: "RxSwift", package: "RxSwift")
            ]
        )
    ]
)
