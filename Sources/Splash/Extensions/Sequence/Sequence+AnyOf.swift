/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

internal extension Sequence where Element: Equatable {
    func contains(anyOf candidates: Element...) -> Bool {
        contains(anyOf: candidates)
    }

    func contains(anyOf candidates: some Sequence<Element>) -> Bool {
        for candidate in candidates {
            if contains(candidate) {
                return true
            }
        }

        return false
    }
}
