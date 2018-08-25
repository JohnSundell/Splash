/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

/// A theme describes what fonts and colors to use when rendering
/// certain output formats - such as `NSAttributedString`. A default
/// implementation is provided that matches the "Sundell's Colors"
/// Xcode theme, by using the `sundellsColors(withFont:)` method.
public struct Theme {
    /// What font to use to render the highlighted text
    public var font: Font
    /// What color to use for plain text (no highlighting)
    public var plainTextColor: Color
    /// What color to use for the text's highlighted tokens
    public var tokenColors: [TokenType : Color]

    public init(font: Font, plainTextColor: Color, tokenColors: [TokenType : Color]) {
        self.font = font
        self.plainTextColor = plainTextColor
        self.tokenColors = tokenColors
    }
}
