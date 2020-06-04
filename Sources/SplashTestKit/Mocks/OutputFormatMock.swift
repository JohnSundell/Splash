/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation
import Splash

public struct OutputFormatMock: OutputFormat {
    public let builder: OutputBuilderMock

    public func makeBuilder() -> OutputBuilderMock {
        return builder
    }
}
