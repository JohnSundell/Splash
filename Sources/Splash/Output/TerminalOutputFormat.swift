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
            let color = theme.tokenColors[type] ?? Color(red: 1, green: 1, blue: 1)
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
    func colorized(with color: Color) -> String {
        return "\u{001B}[38;5;\(color.xtermIndex)m\(self)\u{001B}[39m"
    }
}

// Converting from RGB to 256-color xterm
//
// Inspired by the explanation given in
// https://codegolf.stackexchange.com/questions/156918/rgb-to-xterm-color-converter
private extension Color {
    private static let xtermDefaultColorIndex = 16
    private static let xtermIndices = [0, 95, 135, 175, 215, 255]
    private static let xtermTriplets: [(Int, Int, Int)] = (0 ..< 239).map {
        let uniformValue = $0 * 10 - 2152
        return $0 < 216 ? (xtermIndices[$0 / 36], xtermIndices[($0 % 36) / 6], xtermIndices[$0 % 6]) :
            (uniformValue, uniformValue, uniformValue)
    }

    var xtermIndex: Int {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)

        let manhattanDistances: [Float] = Color.xtermTriplets.map { triplet in
            let distances = [
                fabsf(Float(red * 255) - Float(triplet.0)),
                fabsf(Float(green * 255) - Float(triplet.1)),
                fabsf(Float(blue * 255) - Float(triplet.2))
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
