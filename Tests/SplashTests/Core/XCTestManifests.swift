/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import XCTest

#if os(Linux)

public func makeLinuxTests() -> [XCTestCaseEntry] {
    return [
        testCase(ClosureTests.allTests),
        testCase(CommentTests.allTests),
        testCase(DeclarationTests.allTests),
        testCase(EnumTests.allTests),
        testCase(FunctionCallTests.allTests),
        testCase(LiteralTests.allTests),
        testCase(OptionalTests.allTests),
        testCase(PreprocessorTests.allTests),
        testCase(StatementTests.allTests),
        testCase(MarkdownTests.allTests)
    ]
}

#endif
