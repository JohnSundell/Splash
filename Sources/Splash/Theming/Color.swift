/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

/// A representation of a color, for use with a `Theme`.
/// Since Splash aims to be cross-platform, it uses this
/// simplified color representation rather than `NSColor`
/// or `UIColor`.
public struct Color {
    public var red: Double
    public var green: Double
    public var blue: Double
    public var alpha: Double

    public init(red: Double, green: Double, blue: Double, alpha: Double = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

#if !os(Linux)
internal extension Color {
    var renderable: Renderable {
        return Renderable(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(alpha)
        )
    }
}
#endif

#if os(iOS)

import UIKit

internal extension Color {
    typealias Renderable = UIColor
}

#elseif os(macOS)

import Cocoa

internal extension Color {
    typealias Renderable = NSColor
}

#endif
