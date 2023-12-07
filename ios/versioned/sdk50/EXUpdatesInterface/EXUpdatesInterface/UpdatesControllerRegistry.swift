//  Copyright © 2022-present 650 Industries. All rights reserved.

import Foundation

@objc(ABI50_0_0EXUpdatesControllerRegistry)
@objcMembers
public final class UpdatesControllerRegistry: NSObject {
  public weak var controller: UpdatesExternalInterface?

  public static let sharedInstance = UpdatesControllerRegistry()
}
