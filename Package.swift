// swift-tools-version:5.2

/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import PackageDescription

let package = Package(
    name: "Splash",
    products: [
        .library(name: "Splash", targets: ["Splash"]),
        .executable(name: "SplashMarkdown", targets: ["SplashMarkdown"]),
        .executable(name: "SplashHTMLGen", targets: ["SplashHTMLGen"]),
        .executable(name: "SplashImageGen", targets: ["SplashImageGen"]),
        .executable(name: "SplashTokenizer", targets: ["SplashTokenizer"]),
    ],
    targets: [
        .target(name: "Splash"),
        .target(
            name: "SplashMarkdown",
            dependencies: ["Splash"]
        ),
        .target(
            name: "SplashHTMLGen",
            dependencies: ["Splash"]
        ),
        .target(
            name: "SplashImageGen",
            dependencies: ["Splash"]
        ),
        .target(
            name: "SplashTokenizer",
            dependencies: ["Splash"]
        ),
        .testTarget(
            name: "SplashTests",
            dependencies: ["Splash"]
        )
    ]
)
