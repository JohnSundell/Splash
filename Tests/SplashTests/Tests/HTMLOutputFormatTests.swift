import Foundation
import XCTest
import Splash

final class HTMLOutputFormatTests: SplashTestCase {
    private var highlighter: SyntaxHighlighter<HTMLOutputFormat>!

    override func setUp() {
        super.setUp()
        highlighter = SyntaxHighlighter(format: HTMLOutputFormat())
    }

    func testStrippingGreaterAndLessThanCharactersFromOutput() {
        let html = highlighter.highlight("Array<String>")

        XCTAssertEqual(html, """
        <span class="type">Array</span>&lt;<span class="type">String</span>&gt;
        """)
    }

    func testAllTestsRunOnLinux() {
        XCTAssertTrue(TestCaseVerifier.verifyLinuxTests((type(of: self)).allTests))
    }
}

extension HTMLOutputFormatTests {
    static var allTests: [(String, TestClosure<HTMLOutputFormatTests>)] {
        return [
            ("testStrippingGreaterAndLessThanCharactersFromOutput", testStrippingGreaterAndLessThanCharactersFromOutput)
        ]
    }
}
