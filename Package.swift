// swift-tools-version:5.0

/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import PackageDescription

let package = Package(
    name: "Splash",
    products: [
        .library(name: "Splash", targets: ["Splash"])
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
