/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest
import Splash

/// Test case used as an abstract base class for all tests relating to
/// syntax highlighting. For all such tests, the Swift grammar is used.
class SyntaxHighlighterTestCase: XCTestCase {
    private(set) var highlighter: SyntaxHighlighter<OutputFormatMock>!
    private(set) var builder: OutputBuilderMock!

    override func setUp() {
        super.setUp()
        builder = OutputBuilderMock()
        highlighter = SyntaxHighlighter(format: OutputFormatMock(builder: builder))
    }

    #if os(macOS)
    func testHasLinuxVerificationTest() {
        let concreteType = type(of: self)

        guard concreteType != SyntaxHighlighterTestCase.self else {
            return
        }

        XCTAssertTrue(concreteType.testNames.contains("testAllTestsRunOnLinux"),
                      "All test cases should have a test that verify that their tests run on Linux")
    }
    #endif
}
