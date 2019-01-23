import Foundation
import Splash

guard CommandLine.arguments.count > 1 else {
    print("⚠️  Please supply the file to concatenate")
    exit(1)
}

let file = CommandLine.arguments[1]
let theme = Theme.midnight(withFont: Font(size: 17))
let highlighter = SyntaxHighlighter(format: TerminalOutputFormat(theme: theme))

do {
    let code = try String(contentsOfFile: file)
    print(highlighter.highlight(code))
}
catch {
    print("⚠️  Could not read from \(file)")
    exit(1)
}
