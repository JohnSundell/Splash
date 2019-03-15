/**
 *  Splash
 *  Copyright (c) John Sundell 2019
 *  MIT license - see LICENSE.md
 */

import Foundation

/// Type used to decorate a Markdown file with Splash-highlighted code blocks
public struct MarkdownDecorator {
    private let highlighter = SyntaxHighlighter(format: HTMLOutputFormat())
    private let skipHighlightingPrefix = "no-highlight"

    public init() {}

    /// Decorate all code blocks within a given Markdown string. This API assumes
    /// that the passed Markdown is valid. Each code block will be replaced by
    /// Splash-highlighted HTML for that block's code. To skip highlighting for
    /// any given code block, add "no-highlight" next to the opening row of
    /// backticks for that block.
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
