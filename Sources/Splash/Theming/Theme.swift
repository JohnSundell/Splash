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

public extension Theme {
    /// Create a theme matching the "Sundell's Colors" Xcode theme
    static func sundellsColors(withFont font: Font) -> Theme {
        return Theme(
            font: font,
            plainTextColor: Color(
                red: 0.66,
                green: 0.74,
                blue: 0.74
            ),
            tokenColors: [
                .keyword : Color(red: 0.91, green: 0.2, blue: 0.54),
                .string : Color(red: 0.98, green: 0.39, blue: 0.12),
                .type : Color(red: 0.51, green: 0.51, blue: 0.79),
                .call : Color(red: 0.2, green: 0.56, blue: 0.9),
                .number : Color(red: 0.86, green: 0.44, blue: 0.34),
                .comment : Color(red: 0.42, green: 0.54, blue: 0.58),
                .property : Color(red: 0.13, green: 0.67, blue: 0.62),
                .dotAccess : Color(red: 0.57, green: 0.7, blue: 0),
                .preprocessing : Color(red: 0.71, green: 0.54, blue: 0)
            ]
        )
    }
}
