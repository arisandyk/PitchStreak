// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "FavoriteFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FavoriteFeature", targets: ["FavoriteFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/arisandyk/PitchStreak-Core.git", from: "1.0.0"),
        .package(path: "../DesignSystem"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.7.0")
    ],
    targets: [
        .target(
            name: "FavoriteFeature",
            dependencies: [
                .product(name: "Core", package: "PitchStreak-Core"),
                "DesignSystem",
                .product(name: "RxSwift", package: "RxSwift")
            ]
        )
    ]
)
