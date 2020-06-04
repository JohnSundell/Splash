/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import XCTest

public typealias TestClosure<T: XCTestCase> = (T) -> () throws -> Void
