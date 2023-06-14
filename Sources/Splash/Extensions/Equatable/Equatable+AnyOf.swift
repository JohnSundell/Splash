/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

import Foundation

extension Equatable {
  func isAny(of candidates: Self...) -> Bool {
    candidates.contains(self)
  }

  func isAny(of candidates: some Sequence<Self>) -> Bool {
    candidates.contains(self)
  }
}
