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
