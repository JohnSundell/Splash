import Foundation
import XCTest
@testable import Splash

final class TerminalOutputFormatTests: SplashTestCase {
    func testEscapedHighlightingOutput() {
        let theme = Theme.midnight(withFont: Font(size: 17))
        let formatter = TerminalOutputFormat(theme: theme)
        let highlighter = SyntaxHighlighter(format: formatter)

        let terminalOutput = highlighter.highlight("static let image = UIImage(named: \"splash\")!")

        XCTAssertEqual(terminalOutput, """
        \u{001B}[38;5;162mstatic\u{001B}[39m \u{001B}[38;5;162mlet\u{001B}[39m \u{001B}[38;5;231mimage\u{001B}[39m \u{001B}[38;5;231m=\u{001B}[39m \u{001B}[38;5;48mUIImage\u{001B}[39m\u{001B}[38;5;231m(named:\u{001B}[39m \u{001B}[38;5;197m"splash"\u{001B}[39m\u{001B}[38;5;231m)!\u{001B}[39m
        """)
    }

    // Xterm color test vectors
    //
    //  R   G   B     Xterm
    // --------------------
    //   0   0   0 ==>  16
    //  95 135   0 ==>  64
    // 255 255 255 ==> 231
    // 238 238 238 ==> 255
    //
    //  90 133 140 ==>  66
    // 218 215 216 ==> 188
    // 175 177 178 ==> 249
    //
    // 175   0 155 ==> 127
    //  75  75  75 ==> 239
    //  23  23  23 ==> 234
    // 115 155 235 ==> 111
    func testColorIndices() {
        let rgbColors = [
            (  0,   0,   0),
            ( 95, 135,   0),
            (255, 255, 255),
            (238, 238, 238),
            ( 90, 133, 140),
            (218, 215, 216),
            (175, 177, 178),
            (175,   0, 155),
            ( 75,  75,  75),
            ( 23,  23,  23),
            (115, 155, 235),
        ]

        let xtermColors = [
            16, 64, 231, 255, 66, 188, 249, 127, 239, 234, 111
        ]

        zip(rgbColors, xtermColors).forEach {
            let color = Color(red: CGFloat($0.0) / 255.0, green: CGFloat($0.1) / 255.0, blue: CGFloat($0.2) / 255.0, alpha: 1.0)
            XCTAssertEqual(color.xtermIndex, $1)
        }
    }

    func testAllTestsRunOnLinux() {
        XCTAssertTrue(TestCaseVerifier.verifyLinuxTests((type(of: self)).allTests))
    }
}

extension TerminalOutputFormatTests {
    static var allTests: [(String, TestClosure<TerminalOutputFormatTests>)] {
        return [
            ("testEscapedHighlightingOutput", testEscapedHighlightingOutput),
            ("testColorIndices", testColorIndices)
        ]
    }
}
