/**
 *  Splash
 *  Copyright (c) John Sundell 2019
 *  MIT license - see LICENSE.md
 */

import Foundation
import Splash

public struct MarkdownDecorator {
    private let highlighter = SyntaxHighlighter(format: HTMLOutputFormat())
    private let skipHighlightingPrefix = "no-highlight"

    public func decorate(_ markdown: String) -> String {
        let components = markdown.components(separatedBy: "```")
        var output = ""

        for (index, component) in components.enumerated() {
            guard index % 2 != 0 else {
                output.append(component)
                continue
            }

            var code = component.trimmingCharacters(in: .whitespacesAndNewlines)

            if code.hasPrefix(skipHighlightingPrefix) {
                let charactersToDrop = skipHighlightingPrefix + "\n"
                code = String(code.dropFirst(charactersToDrop.count))
            } else {
                code = highlighter.highlight(code)
            }

            output.append("""
            <pre class="splash"><code>
            \(code)
            </code></pre>
            """)
        }

        return output
    }
}
