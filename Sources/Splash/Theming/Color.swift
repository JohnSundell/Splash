/**
 *  Splash
 *  Copyright (c) John Sundell 2018
 *  MIT license - see LICENSE.md
 */

#if os(iOS)
  import UIKit
  public typealias Color = UIColor
#elseif os(macOS)
  import Cocoa
  public typealias Color = NSColor
#endif

internal extension Color {
  convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
    self.init(red: red, green: green, blue: blue, alpha: 1)
  }
}
