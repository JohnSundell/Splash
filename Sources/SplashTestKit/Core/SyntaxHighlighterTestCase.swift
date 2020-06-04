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
open class SyntaxHighlighterTestCase: SplashTestCase {
    public static var grammer: Grammar = SwiftGrammar()
    
    private(set) public var highlighter: SyntaxHighlighter<OutputFormatMock>!
    private(set) public var builder: OutputBuilderMock!

    open override func setUp() {
        super.setUp()
        builder = OutputBuilderMock()
        highlighter = SyntaxHighlighter(format: OutputFormatMock(builder: builder), grammar: Self.grammer)
    }
}
