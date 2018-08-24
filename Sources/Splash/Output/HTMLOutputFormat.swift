/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

/// Output format to use to generate an HTML string with a semantic
/// representation of the highlighted code. Each token will be wrapped
/// in a `span` element with a CSS class matching the token's type.
/// Optionally, a `classPrefix` can be set to prefix each CSS class with
/// a given string.
public struct HTMLOutputFormat: OutputFormat {
    public var classPrefix: String

    public init(classPrefix: String = "") {
        self.classPrefix = classPrefix
    }

    public func makeBuilder() -> Builder {
        return Builder(classPrefix: classPrefix)
    }
}

public extension HTMLOutputFormat {
    struct Builder: OutputBuilder {
        private let classPrefix: String
        private var html = ""

        fileprivate init(classPrefix: String) {
            self.classPrefix = classPrefix
        }

        public mutating func addToken(_ token: String, ofType type: TokenType) {
            html.append("<span class=\"\(classPrefix)\(type.rawValue)\">\(token)</span>")
        }

        public mutating func addPlainText(_ text: String) {
            html.append(text)
        }

        public mutating func addWhitespace(_ whitespace: String) {
            html.append(whitespace)
        }

        public func build() -> String {
            return html
        }
    }
}
