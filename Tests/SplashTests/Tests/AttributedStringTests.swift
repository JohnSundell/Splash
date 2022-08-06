#if !os(Linux)

import Foundation
import XCTest
import Splash

final class AttributedStringOutputFormatTests: SplashTestCase {
    private var highlighter: SyntaxHighlighter<AttributedStringOutputFormat>!

    override func setUp() {
        super.setUp()
        highlighter = SyntaxHighlighter(format: AttributedStringOutputFormat(theme: Theme.presentation(withFont: .init(size: 15))))
    }

    func testBasicAttributedStringOutputMatchesInput() {
        let input = """
        public struct Test: SomeProtocol {
            func hello() -> Int { return 7 }
        }
        """
        let output = highlighter.highlight(input)
        XCTAssertEqual(input, output.string)
    }

    func testNewlinesAttributedStringOutputMatchesInput() {
        let input = """

        typealias a = b
        typealias b = c

        print("hello")
        """
        let output = highlighter.highlight(input)
        XCTAssertEqual(input, output.string)
    }

    func testInnerNewlinesAttributedStringOutputMatchesInput() {
        let input = """
        typealias a = b
        typealias b = c

        print("hello")

        print("hello")
        print("hello")


        print("hello")
        """
        let output = highlighter.highlight(input)
        XCTAssertEqual(input, output.string)
    }

    func testAllTestsRunOnLinux() {
    }
}

#endif
