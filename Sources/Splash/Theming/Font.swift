/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

/// A representation of a font, for use with a `Theme`.
/// Since Splash aims to be cross-platform, it uses this
/// simplified color representation rather than `NSFont`
/// or `UIFont`.
public struct Font {
    /// The underlying resource used to load the font
    public var resource: Resource
    /// The size (in points) of the font
    public var size: Double

    /// Initialize an instance with a path to a font file
    /// on disk and a size.
    public init(path: String, size: Double) {
        #if os(macOS)
        resource = .path((path as NSString).expandingTildeInPath)
        #else
        resource = .path(path)
        #endif

        self.size = size
    }

    /// Initialize an instance with a size, and use an
    /// appropriate system font to render text.
    public init(size: Double) {
        resource = .system
        self.size = size
    }
}

public extension Font {
    /// Enum describing how to load the underlying resource for a font
    enum Resource {
        /// Use an appropriate system font
        case system
        /// Load a font file from a given file system path
        case path(String)
    }
}
