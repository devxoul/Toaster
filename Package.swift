// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Toaster",
    products: [
        .library(
            name: "Toaster",
            targets: ["Toaster"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "Toaster",
            dependencies: [],
            path: "Sources")
    ]
)
