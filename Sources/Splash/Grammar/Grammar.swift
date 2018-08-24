/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

/// Protocol used to define the grammar of a language to use for
/// syntax highlighting. See `SwiftGrammar` for a default implementation
/// of the Swift language grammar.
public protocol Grammar {
    /// The set of characters that make up the delimiters that separates
    /// tokens within the language, such as punctuation characters.
    var delimiters: CharacterSet { get }
    /// The rules that define the syntax of the language. When tokenizing,
    /// the rules will be iterated over in sequence, and the first rule
    /// that matches a given code segment will be used to determine that
    /// segment's token type.
    var syntaxRules: [SyntaxRule] { get }
}
