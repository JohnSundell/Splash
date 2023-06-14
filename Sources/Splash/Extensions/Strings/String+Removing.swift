/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

internal extension String {
    func removing(_ substring: String) -> String {
        replacingOccurrences(of: substring, with: "")
    }
}
