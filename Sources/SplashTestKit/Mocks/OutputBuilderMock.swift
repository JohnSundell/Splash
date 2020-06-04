/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import Splash

public struct OutputBuilderMock: OutputBuilder {
    private var components = [Component]()

    public mutating func addToken(_ token: String, ofType type: TokenType) {
        components.append(.token(token, type))
    }

    public mutating func addPlainText(_ text: String) {
        components.append(.plainText(text))
    }

    public mutating func addWhitespace(_ whitespace: String) {
        components.append(.whitespace(whitespace))
    }

    public func build() -> [Component] {
        return components
    }
}

public extension OutputBuilderMock {
    enum Component: Equatable {
        case token(String, TokenType)
        case plainText(String)
        case whitespace(String)
    }
}
