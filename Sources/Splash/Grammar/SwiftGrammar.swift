/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

/// Grammar for the Swift language. Use this implementation when
/// highlighting Swift code. This is the default grammar.
public struct SwiftGrammar: Grammar {
    public var delimiters: CharacterSet
    public var syntaxRules: [SyntaxRule]

    public init() {
        var delimiters = CharacterSet.alphanumerics.inverted
        delimiters.remove("_")
        delimiters.remove("\"")
        delimiters.remove("#")
        delimiters.remove("@")
        self.delimiters = delimiters

        syntaxRules = [
            PreprocessingRule(),
            CommentRule(),
            RawStringRule(),
            MultiLineStringRule(),
            SingleLineStringRule(),
            AttributeRule(),
            NumberRule(),
            TypeRule(),
            CallRule(),
            KeyPathRule(),
            PropertyRule(),
            DotAccessRule(),
            KeywordRule()
        ]
    }
}

private extension SwiftGrammar {
    static let keywords = ([
        "final", "class", "struct", "enum", "protocol",
        "extension", "let", "var", "func", "typealias",
        "init", "guard", "if", "else", "return", "get",
        "throw", "throws", "rethrows", "for", "in", "open", "weak",
        "import", "mutating", "nonmutating", "associatedtype",
        "case", "switch", "static", "do", "try", "catch", "as",
        "super", "self", "set", "true", "false", "nil",
        "override", "where", "_", "default", "break",
        "#selector", "required", "willSet", "didSet",
        "lazy", "subscript", "defer", "inout", "while",
        "continue", "fallthrough", "repeat", "indirect",
        "deinit", "is", "#file", "#line", "#function",
        "dynamic", "some", "#available"
    ] as Set<String>).union(accessControlKeywords)

    static let accessControlKeywords: Set<String> = [
        "public", "internal", "fileprivate", "private"
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

            if segment.tokens.current.isAny(of: "/*", "/**", "*/") {
                return true
            }

            let multiLineStartCount = segment.tokens.count(of: "/*") + segment.tokens.count(of: "/**")
            return multiLineStartCount != segment.tokens.count(of: "*/")
        }
    }

    struct AttributeRule: SyntaxRule {
        var tokenType: TokenType { return .keyword }

        func matches(_ segment: Segment) -> Bool {
            return segment.tokens.current.hasPrefix("@")
        }
    }

    struct RawStringRule: SyntaxRule {
        var tokenType: TokenType { return .string }

        func matches(_ segment: Segment) -> Bool {
            if segment.isWithinStringLiteral(withStart: "#\"", end: "\"#") {
                return true
            }

            let multiLineStartCount = segment.tokens.count(of: "#\"\"\"")
            let multiLineEndCount = segment.tokens.count(of: "\"\"\"#")
            return multiLineStartCount != multiLineEndCount
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
            guard segment.isWithinStringLiteral(withStart: "\"", end: "\"") else {
                return false
            }

            return !segment.isWithinStringInterpolation
        }
    }

    struct NumberRule: SyntaxRule {
        var tokenType: TokenType { return .number }

        func matches(_ segment: Segment) -> Bool {
            // Don't match against index-based closure arguments
            if let previous = segment.tokens.previous {
                guard !previous.hasSuffix("$") else {
                    return false
                }
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
        private let callLikeKeywords: Set<String>
        private let controlFlowTokens = ["if", "&&", "||", "for"]

        init() {
            var keywordsToAvoid = keywords
            keywordsToAvoid.remove("return")
            keywordsToAvoid.remove("try")
            keywordsToAvoid.remove("throw")
            keywordsToAvoid.remove("if")
            self.keywordsToAvoid = keywordsToAvoid

            var callLikeKeywords = accessControlKeywords
            callLikeKeywords.insert("subscript")
            self.callLikeKeywords = callLikeKeywords
        }

        func matches(_ segment: Segment) -> Bool {
            guard segment.tokens.current.startsWithLetter else {
                return false
            }

            // There's a few keywords that might look like function calls
            if callLikeKeywords.contains(segment.tokens.current) {
                if let nextToken = segment.tokens.next {
                    guard !nextToken.starts(with: "(") else {
                        return false
                    }
                }
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

            return segment.tokens.next?.starts(with: "(") ?? false
        }
    }

    struct KeywordRule: SyntaxRule {
        var tokenType: TokenType { return .keyword }

        func matches(_ segment: Segment) -> Bool {
            if segment.tokens.next == ":" {
                // Nil pattern matching inside of a switch statement case
                if segment.tokens.current == "nil" {
                    guard let previousToken = segment.tokens.previous else {
                        return false
                    }

                    return previousToken.isAny(of: "case", ",")
                }

                guard segment.tokens.current == "default" else {
                    return false
                }
            }

            if let previousToken = segment.tokens.previous {
                // Highlight the '(set)' part of setter access modifiers
                switch segment.tokens.current {
                case "(":
                    return accessControlKeywords.contains(previousToken)
                case "set":
                    if previousToken == "(" {
                        return true
                    }
                case ")":
                    return previousToken == "set"
                default:
                    break
                }

                // Don't highlight most keywords when used as a parameter label
                if !segment.tokens.current.isAny(of: "_", "self", "let", "var", "true", "false", "inout") {
                    guard !previousToken.isAny(of: "(", ",", ">(") else {
                        return false
                    }
                }

                guard !segment.tokens.previous.isAny(of: "func", "`") else {
                    return false
                }
            }

            return keywords.contains(segment.tokens.current)
        }
    }

    struct TypeRule: SyntaxRule {
        var tokenType: TokenType { return .type }

        private let declarationKeywords: Set<String> = [
            "class", "struct", "enum", "func",
            "protocol", "typealias", "import",
            "associatedtype"
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

            // The XCTAssert family of functions is a bit of an edge case,
            // since they start with capital letters. Since they are so
            // commonly used, we'll add a special case for them here:
            guard !segment.tokens.current.starts(with: "XCTAssert") else {
                return false
            }

            // In a generic declaration, only highlight constraints
            if segment.tokens.previous.isAny(of: "<", ",") {
                var foundOpeningBracket = false

                // Since the declaration might be on another line, we have to walk
                // backwards through all tokens until we've found enough information.
                for token in segment.tokens.all.reversed() {
                    // Highlight return type generics as normal
                    if token == "->" {
                        return true
                    }

                    if !foundOpeningBracket && token == "<" {
                        foundOpeningBracket = true
                    }

                    // Handling generic lists for parameters, rather than declarations
                    if foundOpeningBracket && token == ":" {
                        return true
                    }

                    guard !declarationKeywords.contains(token) else {
                        // If it turns out that we weren't in fact inside of a generic
                        // declaration, (lacking "<"), then highlight the type as normal.
                        return !foundOpeningBracket
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

            guard !segment.tokens.current.isAny(of: "self", "init") else {
                return false
            }

            return segment.tokens.onSameLine.first != "import"
        }
    }

    struct KeyPathRule: SyntaxRule {
        var tokenType: TokenType { return .property }

        func matches(_ segment: Segment) -> Bool {
            return segment.tokens.previous.isAny(of: #"\."#, #"(\."#)
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
    func isWithinStringLiteral(withStart start: String, end: String) -> Bool {
        if tokens.current.hasPrefix(start) {
            return true
        }

        if tokens.current.hasSuffix(end) {
            return true
        }

        var markerCounts = (start: 0, end: 0)
        var previousToken: String?

        for token in tokens.onSameLine {
            guard previousToken != "\\" else {
                previousToken = token
                continue
            }

            if token == start {
                if start != end || markerCounts.start == markerCounts.end {
                    markerCounts.start += 1
                } else {
                    markerCounts.end += 1
                }
            } else if token == end && start != end {
                markerCounts.end += 1
            } else {
                if token.hasPrefix(start) {
                    markerCounts.start += 1
                }

                if token.hasSuffix(end) {
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
