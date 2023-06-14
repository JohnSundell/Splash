/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import Splash

struct TokenizerOutputFormat: OutputFormat {
  func makeBuilder() -> Builder {
    Builder()
  }
}

extension TokenizerOutputFormat {
  struct Builder: OutputBuilder {
    private var components = [String]()

    mutating func addToken(_ token: String, ofType type: TokenType) {
      components.append("\(type.string.capitalized) token: \(token)")
    }

    mutating func addPlainText(_ text: String) {
      components.append("Plain text: \(text)")
    }

    mutating func addWhitespace(_: String) {
      // Ignore whitespace
    }

    func build() -> String {
      components.joined(separator: "\n")
    }
  }
}
