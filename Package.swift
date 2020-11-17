
// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Toaster",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "Toaster",
            targets: ["Toaster"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Toaster",
            dependencies: [],
            path: "Toaster"),
    ],
    swiftLanguageVersions: [.v5]
)
