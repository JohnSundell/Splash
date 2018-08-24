/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest

#if os(macOS)

extension XCTestCase {
    static var testNames: [String] {
        return defaultTestSuite.tests.map { test in
            let components = test.name.components(separatedBy: .whitespaces)
            return components[1].replacingOccurrences(of: "]", with: "")
        }
    }
}

#endif
