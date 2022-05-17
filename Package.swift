// swift-tools-version:5.6

/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import PackageDescription

let package = Package(
    name: "Splash",
    platforms: [.macOS(.v12)],
    products: [
        .library(name: "Splash", targets: ["Splash"]),
        .executable(name: "SplashMarkdown", targets: ["SplashMarkdown"]),
        .executable(name: "SplashHTMLGen", targets: ["SplashHTMLGen"]),
        .executable(name: "SplashImageGen", targets: ["SplashImageGen"]),
        .executable(name: "SplashTokenizer", targets: ["SplashTokenizer"]),
    ],
    targets: [
        .target(name: "Splash"),
        .executableTarget(
            name: "SplashMarkdown",
            dependencies: ["Splash"]
        ),
        .executableTarget(
            name: "SplashHTMLGen",
            dependencies: ["Splash"]
        ),
        .executableTarget(
            name: "SplashImageGen",
            dependencies: ["Splash"]
        ),
        .executableTarget(
            name: "SplashTokenizer",
            dependencies: ["Splash"]
        ),
        .testTarget(
            name: "SplashTests",
            dependencies: ["Splash"]
        )
    ]
)
