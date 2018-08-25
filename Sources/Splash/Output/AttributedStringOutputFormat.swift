/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

#if os(macOS)
import Cocoa
#endif

#if os(iOS)
import UIKit
#endif

/// Output format to use to generate an NSAttributedString from the
/// highlighted code. A `Theme` is used to determine what fonts and
/// colors to use for the various tokens.
public struct AttributedStringOutputFormat: OutputFormat {
    public var theme: Theme
    
    public init(theme: Theme) {
        self.theme = theme
    }
    
    public func makeBuilder() -> Builder {
        return Builder(theme: theme)
    }
}

public extension AttributedStringOutputFormat {
    struct Builder: OutputBuilder {
        private let theme: Theme
        private lazy var font = loadFont()
        private var string = NSMutableAttributedString()
        
        fileprivate init(theme: Theme) {
            self.theme = theme
        }
        
        public mutating func addToken(_ token: String, ofType type: TokenType) {
            let color = theme.tokenColors[type] ?? Color(red: 1, green: 1, blue: 1)
            string.append(token, font: font, color: color)
        }
        
        public mutating func addPlainText(_ text: String) {
            string.append(text, font: font, color: theme.plainTextColor)
        }
        
        public mutating func addWhitespace(_ whitespace: String) {
            let color = Color(red: 1, green: 1, blue: 1)
            string.append(whitespace, font: font, color: color)
        }
        
        public func build() -> NSAttributedString {
            return NSAttributedString(attributedString: string)
        }
        
        #if os(macOS)
        private mutating func loadFont() -> NSFont {
            let size = CGFloat(theme.font.size)
            
            switch theme.font.resource {
            case .system:
                return .defaultFont(ofSize: size)
            case .path(let path):
                guard let font = NSFont.loaded(from: path, size: size) else {
                    return .defaultFont(ofSize: size)
                }
                
                return font
            }
        }
        #endif
        
        #if os(iOS)
        private mutating func loadFont() -> UIFont {
            
            let size = CGFloat(theme.font.size)
            let font = UIFont.defaultFont(ofSize: size)
            return font
            
        }
        #endif
        
    }
}

#if os(macOS)
private extension NSMutableAttributedString {
    func append(_ string: String, font: NSFont, color: Color) {
        let color = NSColor(
            red: CGFloat(color.red),
            green: CGFloat(color.green),
            blue: CGFloat(color.blue),
            alpha: CGFloat(color.alpha)
        )
        
        let attributedString = NSAttributedString(string: string, attributes: [
            .foregroundColor: color,
            .font: font
            ])
        
        append(attributedString)
    }
}

private extension NSFont {
    static func loaded(from path: String, size: CGFloat) -> NSFont? {
        let url = CFURLCreateWithFileSystemPath(
            kCFAllocatorDefault,
            path as CFString,
            .cfurlposixPathStyle,
            false
        )
        
        guard let font = url.flatMap(CGDataProvider.init).flatMap(CGFont.init) else {
            return nil
        }
        
        return CTFontCreateWithGraphicsFont(font, size, nil, nil)
    }
    
    static func defaultFont(ofSize size: CGFloat) -> NSFont {
        guard let courier = loaded(from: "/Library/Fonts/Courier New.ttf", size: size) else {
            return .systemFont(ofSize: size)
        }
        
        return courier
    }
}
#endif

#if os(iOS)
private extension NSMutableAttributedString {
    func append(_ string: String, font: UIFont, color: Color) {
        let color = UIColor(
            red: CGFloat(color.red),
            green: CGFloat(color.green),
            blue: CGFloat(color.blue),
            alpha: CGFloat(color.alpha)
        )
        
        let attributedString = NSAttributedString(string: string, attributes: [
            .foregroundColor: color,
            .font: font
            ])
        
        append(attributedString)
    }
}

private extension UIFont {
    
    static func defaultFont(ofSize size: CGFloat) -> UIFont {
        guard let menlo = UIFont(name: "Menlo-Regular", size: size) else {
            return .systemFont(ofSize: size)
        }
        
        return menlo
    }
    
}
#endif
