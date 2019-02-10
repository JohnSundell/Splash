import Foundation

/// Output format to use to generate an encoded terminal string
public struct TerminalOutputFormat: OutputFormat {
    public var theme: Theme

    public init(theme: Theme) {
        self.theme = theme
    }

    public func makeBuilder() -> Builder {
        return Builder(theme: theme)
    }
}

public extension TerminalOutputFormat {
    struct Builder: OutputBuilder {
        private let theme: Theme
        private var text = ""

        fileprivate init(theme: Theme) {
            self.theme = theme
        }

        public mutating func addToken(_ token: String, ofType type: TokenType) {
            let color = theme.tokenColors[type] ?? .white
            text.append(token.colorized(with: color))
        }

        public mutating func addPlainText(_ plainText: String) {
            text.append(plainText.colorized(with: theme.plainTextColor))
        }

        public mutating func addWhitespace(_ whitespace: String) {
            text.append(whitespace)
        }

        public func build() -> String {
            return text
        }
    }
}

private extension String {
    // Color formatting for xterm is described in the section named "88/256 Colors" here:
    // https://misc.flogisoft.com/bash/tip_colors_and_formatting
    func colorized(with color: Color) -> String {
        return "\u{001B}[38;5;\(color.xtermIndex)m\(self)\u{001B}[39m"
    }
}

// Converting from RGB to closest 256-color xterm value
//
// Inspired by the explanation given in
// https://codegolf.stackexchange.com/questions/156918/rgb-to-xterm-color-converter
extension Color {
    private static let xtermDefaultColorIndex = 16
    private static let xtermColors: [(Int, Int, Int)] = (0 ... 239).map {
        let indices = [0, 95, 135, 175, 215, 255]
        let uniformValue = $0 * 10 - 2152

        return $0 < 216 ? (indices[$0 / 36], indices[($0 % 36) / 6], indices[$0 % 6]) :
            (uniformValue, uniformValue, uniformValue)
    }

    var xtermIndex: Int {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)

        let manhattanDistances: [Float] = Color.xtermColors.map { (r, g, b) in
            let distances = [
                fabsf(Float(red * 255) - Float(r)),
                fabsf(Float(green * 255) - Float(g)),
                fabsf(Float(blue * 255) - Float(b))
            ]

            return distances.reduce(0, +)
        }

        guard
            let lowestDistance = manhattanDistances.min(),
            let index = manhattanDistances.lastIndex(of: lowestDistance)
        else {
            return Color.xtermDefaultColorIndex
        }

        return index + Color.xtermDefaultColorIndex
    }
}

#if swift(>=4.2)
#else
private extension Array where Element: Equatable {
    func lastIndex(of element: Element) -> Int? {
        guard let index = reversed().firstIndex(of: element)?.base else {
            return nil
        }

        return index - 1
    }
}
#endif
