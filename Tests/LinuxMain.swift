/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import XCTest
import SplashTests

var tests = [XCTestCaseEntry]()
tests += SplashTests.makeLinuxTests()
XCTMain(tests)
