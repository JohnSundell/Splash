/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest

struct TestCaseVerifier<Case: XCTestCase> {
    static func verifyLinuxTests(_ tests: [(String, TestClosure<Case>)]) -> Bool {
        #if os(macOS)
        let testNames = Set(tests.map { $0.0 })

        for name in Case.testNames {
            guard name != "testAllTestsRunOnLinux" else {
                continue
            }

            guard name != "testHasLinuxVerificationTest" else {
                continue
            }

            guard testNames.contains(name) else {
                XCTFail("""
                Test case \(Case.self) does not include test \(name) on Linux.
                Please add it to the test case's 'allTests' array.
                """)

                return false
            }
        }
        #endif

        return true
    }
}
