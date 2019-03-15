/**
 *  Splash
 *  Copyright (c) John Sundell 2019
 *  MIT license - see LICENSE.md
 */

import XCTest
import Splash

final class MarkdownTests: SplashTestCase {
    private var decorator: MarkdownDecorator!

    override func setUp() {
        super.setUp()
        decorator = MarkdownDecorator()
    }

    func testConvertingCodeBlock() {
        let markdown = """
        # Title

        Text text text `inline.code.shouldNotBeHighlighted()`.

        ```
        struct Hello: Protocol {}
        ```

        Text.
        """

        let expectedResult = """
        # Title

        Text text text `inline.code.shouldNotBeHighlighted()`.

        <pre class="splash"><code>
        <span class="keyword">struct</span> Hello: <span class="type">Protocol</span> {}
        </code></pre>

        Text.
        """

        XCTAssertEqual(decorator.decorate(markdown), expectedResult)
    }

    func testSkippingHighlightingForCodeBlock() {
        let markdown = """
        Text text.

        ```no-highlight
        struct Hello: Protocol {}
        ```

        Text.
        """

        let expectedResult = """
        Text text.

        <pre class="splash"><code>
        struct Hello: Protocol {}
        </code></pre>

        Text.
        """

        XCTAssertEqual(decorator.decorate(markdown), expectedResult)
    }

    func testAllTestsRunOnLinux() {
        XCTAssertTrue(TestCaseVerifier.verifyLinuxTests((type(of: self)).allTests))
    }
}

extension MarkdownTests {
    static var allTests: [(String, TestClosure<MarkdownTests>)] {
        return [
            ("testConvertingCodeBlock", testConvertingCodeBlock),
            ("testSkippingHighlightingForCodeBlock", testSkippingHighlightingForCodeBlock)
        ]
    }
}
