/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

/// A representation of a segment of code, used to determine the type
/// of a given token when passed to a `SyntaxRule` implementation.
public struct Segment {
    /// The code that prefixes this segment, that is all the characters
    /// up to where the segment's current token begins.
    public var prefix: Substring
    /// The collection of tokens that the segment includes
    public var tokens: Tokens
    /// Any whitespace that immediately follows the segment's current token
    public var trailingWhitespace: String?

    internal let currentTokenIsDelimiter: Bool
    internal var isLastOnLine: Bool
}

public extension Segment {
    /// A collection of tokens included in a code segment
    struct Tokens {
        /// The number of times a given token has been found up until this point
        var counts: [String : Int]
        /// The tokens that were previously found on the same line as the current one
        var onSameLine: [String]
        /// The token that was previously found (may be on a different line)
        var previous: String?
        /// The current token which is currently being evaluated
        var current: String
        /// Any upcoming token that will follow the current one
        var next: String?
    }
}

public extension Segment.Tokens {
    /// Return the number of times a given token has been found up until this point.
    /// This is a convenience API over the `counts` dictionary.
    func count(of token: String) -> Int {
        return counts[token] ?? 0
    }

    /// Return whether an equal number of occurrences have been found of two tokens.
    /// For example, this can be used to check if a token is encapsulated by parenthesis.
    func containsBalancedOccurrences(of tokenA: String, and tokenB: String) -> Bool {
        return count(of: tokenA) == count(of: tokenB)
    }
}
