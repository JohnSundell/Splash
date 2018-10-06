/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import Splash

struct OutputBuilderMock: OutputBuilder {
    private var components = [Component]()

    mutating func addToken(_ token: String, ofType type: TokenType) {
        components.append(.token(token, type))
    }

    mutating func addPlainText(_ text: String) {
        components.append(.plainText(text))
    }

    mutating func addWhitespace(_ whitespace: String) {
        components.append(.whitespace(whitespace))
    }

    func build() -> [Component] {
        return components
    }
}

extension OutputBuilderMock {
    enum Component: Equatable {
        case token(String, TokenType)
        case plainText(String)
        case whitespace(String)
    }
}


extension OutputBuilderMock.Component: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .token(let value, let type):
            return "token(\(value), \(type))"
        case .plainText(let value):
            return "plainText(\(value))"
        case .whitespace(let value):
            return "whitespace(\(value))"
        }
    }
}
