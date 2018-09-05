/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

/// Grammar for the Swift language. Use this implementation when
/// highlighting Swift code. This is the default grammar.
public struct SwiftGrammar: Grammar {
    public let delimiters: CharacterSet
    public let syntaxRules: [SyntaxRule]

    public init() {
        var delimiters = CharacterSet.alphanumerics.inverted
        delimiters.remove("_")
        delimiters.remove("\"")
        delimiters.remove("#")
        self.delimiters = delimiters

        syntaxRules = [
            PreprocessingRule(),
            CommentRule(),
            MultiLineStringRule(),
            SingleLineStringRule(),
            AttributeRule(),
            NumberRule(),
            TypeRule(),
            CallRule(),
            PropertyRule(),
            DotAccessRule(),
            KeywordRule()
        ]
    }
}

private extension SwiftGrammar {
    static let keywords: Set<String> = [
        "final", "class", "struct", "enum", "protocol",
        "extension", "let", "var", "func", "typealias",
        "init", "guard", "if", "else", "return", "get",
        "throw", "throws", "for", "in", "open", "weak",
        "public", "internal", "private", "fileprivate",
        "import", "mutating", "associatedtype", "case",
        "switch", "static", "do", "try", "catch", "as",
        "super", "self", "set", "true", "false", "nil",
        "override", "where", "_", "default", "break",
        "#selector", "required", "willSet", "didSet",
        "lazy", "subscript", "defer", "continue",
        "fallthrough", "repeat", "while"
    ]

    struct PreprocessingRule: SyntaxRule {
        var tokenType: TokenType { return .preprocessing }
        private let tokens = ["#if", "#endif", "#elseif", "#else"]

        func matches(_ segment: Segment) -> Bool {
            if segment.tokens.current.isAny(of: tokens) {
                return true
            }

            return segment.tokens.onSameLine.contains(anyOf: tokens)
        }
    }

    struct CommentRule: SyntaxRule {
        var tokenType: TokenType { return .comment }

        func matches(_ segment: Segment) -> Bool {
            if segment.tokens.current.hasPrefix("//") {
                return true
            }

            if segment.tokens.onSameLine.contains(anyOf: "//", "///") {
                return true
            }

            if segment.tokens.current.isAny(of: "/*", "*/") {
                return true
            }

            return !segment.tokens.containsBalancedOccurrences(of: "/*", and: "*/")
        }
    }

    struct AttributeRule: SyntaxRule {
        var tokenType: TokenType { return .keyword }

        func matches(_ segment: Segment) -> Bool {
            return segment.tokens.current == "@" || segment.tokens.previous == "@"
        }
    }

    struct MultiLineStringRule: SyntaxRule {
        var tokenType: TokenType { return .string }

        func matches(_ segment: Segment) -> Bool {
            guard !segment.tokens.count(of: "\"\"\"").isEven else {
                return false
            }

            return !segment.isWithinStringInterpolation
        }
    }

    struct SingleLineStringRule: SyntaxRule {
        var tokenType: TokenType { return .string }

        func matches(_ segment: Segment) -> Bool {
            guard segment.isWithinStringLiteral else {
                return false
            }

            return !segment.isWithinStringInterpolation
        }
    }

    struct NumberRule: SyntaxRule {
        var tokenType: TokenType { return .number }

        func matches(_ segment: Segment) -> Bool {
            // Don't match against index-based closure arguments
            guard segment.tokens.previous != "$" else {
                return false
            }

            // Integers can be separated using "_", so handle that
            if segment.tokens.current.removing("_").isNumber {
                return true
            }

            // Double and floating point values that contain a "."
            guard segment.tokens.current == "." else {
                return false
            }

            guard let previous = segment.tokens.previous,
                  let next = segment.tokens.next else {
                    return false
            }

            return previous.isNumber && next.isNumber
        }
    }

    struct CallRule: SyntaxRule {
        var tokenType: TokenType { return .call }
        private let keywordsToAvoid: Set<String>
        private let controlFlowTokens = ["if", "&&", "||", "for"]

        init() {
            var keywordsToAvoid = keywords
            keywordsToAvoid.remove("return")
            keywordsToAvoid.remove("try")
            keywordsToAvoid.remove("throw")
            keywordsToAvoid.remove("if")
            self.keywordsToAvoid = keywordsToAvoid
        }

        func matches(_ segment: Segment) -> Bool {
            guard segment.tokens.current.startsWithLetter else {
                return false
            }

            // Subscripting is a bit of an edge case, since it's the only keyword
            // that looks like a function call, so we need to handle it explicitly
            guard segment.tokens.current != "subscript" else {
                return false
            }

            if let previousToken = segment.tokens.previous {
                guard !keywordsToAvoid.contains(previousToken) else {
                    return false
                }

                // Don't treat enums with associated values as function calls
                guard !segment.prefixedByDotAccess else {
                    return false
                }
            }

            // Handle trailing closure syntax
            guard segment.trailingWhitespace == nil else {
                guard segment.tokens.next.isAny(of: "{", "{}") else {
                    return false
                }

                guard !keywords.contains(segment.tokens.current) else {
                    return false
                }

                return !segment.tokens.onSameLine.contains(anyOf: controlFlowTokens)
            }

            // Check so that this is an initializer call, not the declaration
            if segment.tokens.current == "init" {
                guard segment.tokens.previous == "." else {
                    return false
                }
            }

            return segment.tokens.next.isAny(of: "(", "()", "())", "(.", "({", "().")
        }
    }

    struct KeywordRule: SyntaxRule {
        var tokenType: TokenType { return .keyword }

        func matches(_ segment: Segment) -> Bool {
            if segment.tokens.next == ":" {
                guard segment.tokens.current == "default" else {
                    return false
                }
            }

            if let previousToken = segment.tokens.previous {
                // Don't highlight most keywords when used as a parameter label
                if !segment.tokens.current.isAny(of: "_", "self", "let", "var") {
                    guard !previousToken.isAny(of: "(", ",") else {
                        return false
                    }
                }
            }

            return keywords.contains(segment.tokens.current)
        }
    }

    struct TypeRule: SyntaxRule {
        var tokenType: TokenType { return .type }

        private let declarationKeywords: Set<String> = [
            "class", "struct", "enum", "func",
            "protocol", "typealias", "import"
        ]

        func matches(_ segment: Segment) -> Bool {
            // Types should not be highlighted when declared
            if let previousToken = segment.tokens.previous {
                guard !previousToken.isAny(of: declarationKeywords) else {
                    return false
                }
            }

            guard segment.tokens.current.isCapitalized else {
                return false
            }

            guard !segment.prefixedByDotAccess else {
                return false
            }

            // In a generic declaration, only highlight constraints
            if segment.tokens.previous.isAny(of: "<", ",") {
                // Since the declaration might be on another line, we have to walk
                // backwards through all tokens until we've found enough information.
                for token in segment.tokens.all.reversed() {
                    guard !declarationKeywords.contains(token) else {
                        return false
                    }

                    guard !keywords.contains(token) else {
                        return true
                    }

                    if token.isAny(of: ">", "=", "==", "(") {
                        return true
                    }
                }
            }

            return true
        }
    }

    struct DotAccessRule: SyntaxRule {
        var tokenType: TokenType { return .dotAccess }

        func matches(_ segment: Segment) -> Bool {
            guard segment.tokens.previous.isAny(of: ".", "(.", "[.") else {
                return false
            }

            guard !segment.tokens.onSameLine.isEmpty else {
                return false
            }

            guard segment.tokens.current != "self" else {
                return false
            }

            return segment.tokens.onSameLine.first != "import"
        }
    }

    struct PropertyRule: SyntaxRule {
        var tokenType: TokenType { return .property }

        func matches(_ segment: Segment) -> Bool {
            guard !segment.tokens.onSameLine.isEmpty else {
                return false
            }

            guard segment.tokens.previous.isAny(of: ".", "?.", "().", ").") else {
                return false
            }

            guard segment.tokens.current != "self" else {
                return false
            }

            guard !segment.prefixedByDotAccess else {
                return false
            }

            return segment.tokens.onSameLine.first != "import"
        }
    }
}

private extension Segment {
    var isWithinStringLiteral: Bool {
        let delimiter = "\""

        if tokens.current.hasPrefix(delimiter) {
            return true
        }

        if tokens.current.hasSuffix(delimiter) {
            return true
        }

        var markerCounts = (start: 0, end: 0)
        var previousToken: String?

        for token in tokens.onSameLine {
            guard previousToken != "\\" else {
                previousToken = token
                continue
            }

            if token == delimiter {
                if markerCounts.start == markerCounts.end {
                    markerCounts.start += 1
                } else {
                    markerCounts.end += 1
                }
            } else {
                if token.hasPrefix(delimiter) {
                    markerCounts.start += 1
                }

                if token.hasSuffix(delimiter) {
                    markerCounts.end += 1
                }
            }

            previousToken = token
        }

        return markerCounts.start != markerCounts.end
    }

    var isWithinStringInterpolation: Bool {
        let delimiter = "\\("

        if tokens.current == delimiter || tokens.previous == delimiter {
            return true
        }

        let components = tokens.onSameLine.split(separator: delimiter)

        guard components.count > 1 else {
            return false
        }

        let suffix = components.last!
        var paranthesisCount = 1

        for component in suffix {
            paranthesisCount += component.numberOfOccurrences(of: "(")
            paranthesisCount -= component.numberOfOccurrences(of: ")")

            guard paranthesisCount > 0 else {
                return false
            }
        }

        return true
    }

    var prefixedByDotAccess: Bool {
        return tokens.previous == "(." || prefix.hasSuffix(" .")
    }
}
