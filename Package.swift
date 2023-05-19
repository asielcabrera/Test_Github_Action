// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Test_Github_Action",
    
    dependencies: [
        .package(url: "https://github.com/asielcabrera/github-toolkit.git", from: "0.0.1"),
        .package(url: "https://github.com/asielcabrera/Terminal.git", from: "0.0.1")
    ],
    
    targets: [
        .executableTarget(
            name: "Test_Github_Action",
            dependencies: [
                .product(name: "Core", package: "github-toolkit"),
                .product(name: "Github", package: "github-toolkit"),
                "Terminal"
            ],
            path: "Sources"),
    ]
)
