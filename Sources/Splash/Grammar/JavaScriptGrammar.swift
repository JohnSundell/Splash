/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

/// Grammar for the JavaScript language. Use this implementation when
/// highlighting Swift code. This is the default grammar.
public struct JavaScriptGrammar: Grammar {
    public let delimiters: CharacterSet
    public let syntaxRules: [SyntaxRule]

    public init() {
        var delimiters = CharacterSet.alphanumerics.inverted
        delimiters.remove("_")
        delimiters.remove("\"")
        delimiters.remove("\'")
        delimiters.remove(";")
        self.delimiters = delimiters

        syntaxRules = [
            CommentRule(),
            SingleLineStringRule(),
            MultiLineStringRule(),
            NumberRule(),
            TypeRule(),
            CallRule(),
            PropertyRule(),
            DotAccessRule(),
            KeywordRule()
        ]
    }
}

private extension JavaScriptGrammar {
    static let keywords: Set<String> = [
    "break",
    "case",
    "catch",
    "class",
    "const",
    "continue",
    "debugger",
    "default",
    "delete",
    "do",
    "else",
    "export",
    "extends",
    "finally",
    "for",
    "function",
    "if",
    "import",
    "in",
    "instanceof",
    "let",
    "new",
    "return",
    "super",
    "switch",
    "this",
    "throw",
    "try",
    "typeof",
    "var",
    "void",
    "while",
    "with",
    "yield",
    "true",
    "false",
    "null",
    "undefined"
    ]

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

    struct MultiLineStringRule: SyntaxRule {
        var tokenType: TokenType { return .string }

        func matches(_ segment: Segment) -> Bool {
            guard !segment.tokens.count(of: "`").isEven else {
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
            // match against hex and bin numbers
            if segment.tokens.current.contains("0b") {
                return true
            }
            if segment.tokens.current.contains("0x") {
                return true
            }
            
            if segment.tokens.current.isNumber {
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
            keywordsToAvoid.remove("throw")
            keywordsToAvoid.remove("if")
            keywordsToAvoid.remove("true")
            keywordsToAvoid.remove("false")
            keywordsToAvoid.remove("null")
            keywordsToAvoid.remove("undefined")
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

            return segment.tokens.next.isAny(of: "(", "()", "())", "(.", "({", "().", "();")
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
                if !segment.tokens.current.isAny(of: "this", "let", "var") {
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
            "class", "enum", "function",
            "typealias", "require", "import"
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

            return true
        }
    }

    struct DotAccessRule: SyntaxRule {
        var tokenType: TokenType { return .dotAccess }

        func matches(_ segment: Segment) -> Bool {
            guard segment.tokens.previous.isAny(of: ".") else {
                return false
            }

            guard !segment.tokens.onSameLine.isEmpty else {
                return false
            }

            guard segment.tokens.current != "this" else {
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

            guard segment.tokens.previous.isAny(of: ".", "().", ").") else {
                return false
            }

            guard segment.tokens.current != "this" else {
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
        let delimiters = ["\"", "`", "'"]

        if delimiters.reduce(false, { (result, delimiter) -> Bool in
            return result || tokens.current.hasPrefix(delimiter)
        }) {
            return true
        }

//        if delimiters.reduce(false, { (result, delimiter) -> Bool in
//            return result || tokens.current.hasSuffix(delimiter)
//        }) {
//            return true
//        }

        var markerCounts = (start: 0, end: 0)
        var previousToken: String?

        for token in tokens.onSameLine {
            guard previousToken != "\\" else {
                previousToken = token
                continue
            }

            if token.isAny(of: delimiters) {
                if markerCounts.start == markerCounts.end {
                    markerCounts.start += 1
                } else {
                    markerCounts.end += 1
                }
            } else {
                if delimiters.reduce(false, { (result, delimiter) -> Bool in
                    return result || tokens.current.hasPrefix(delimiter)
                }) {
                    markerCounts.start += 1
                }

                if delimiters.reduce(false, { (result, delimiter) -> Bool in
                    return result || tokens.current.hasSuffix(delimiter)
                }) {
                    markerCounts.end += 1
                }
            }

            previousToken = token
        }

        return markerCounts.start != markerCounts.end
    }

    var isWithinStringInterpolation: Bool {
        let delimiter = "${"

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
            paranthesisCount += component.numberOfOccurrences(of: "{")
            paranthesisCount -= component.numberOfOccurrences(of: "}")

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
