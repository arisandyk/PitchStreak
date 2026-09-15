// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DesignSystem", targets: ["DesignSystem"])
    ],
    dependencies: [
        .package(url: "https://github.com/arisandyk/PitchStreak-Core.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(name: "Core", package: "PitchStreak-Core")
            ]
        )
    ]
)
