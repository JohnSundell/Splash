/**
 *  Splash
 *  Copyright (c) John Sundell 2019
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest

/// Abstract base class for all Splash tests
class SplashTestCase: XCTestCase {
    #if os(macOS)
    func testHasLinuxVerificationTest() {
        let concreteType = type(of: self)

        guard concreteType != SyntaxHighlighterTestCase.self else {
            return
        }

        guard concreteType != SplashTestCase.self else {
            return
        }

        XCTAssertTrue(concreteType.testNames.contains("testAllTestsRunOnLinux"),
                      "\(concreteType) doesn't have a  test that verifies that its tests run on Linux")
    }
    #endif
}
