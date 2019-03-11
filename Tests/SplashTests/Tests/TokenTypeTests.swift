/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest
import Splash

final class TokenTypeTests: SplashTestCase {
    func testConvertingToString() {
        let standardType = TokenType.comment
        XCTAssertEqual(standardType.string, "comment")

        let customType = TokenType.custom("MyCustomType")
        XCTAssertEqual(customType.string, "MyCustomType")
    }

    func testAllTestsRunOnLinux() {
        XCTAssertTrue(TestCaseVerifier.verifyLinuxTests((type(of: self)).allTests))
    }
}

extension TokenTypeTests {
    static var allTests: [(String, TestClosure<TokenTypeTests>)] {
        return [
            ("testConvertingToString", testConvertingToString)
        ]
    }
}
