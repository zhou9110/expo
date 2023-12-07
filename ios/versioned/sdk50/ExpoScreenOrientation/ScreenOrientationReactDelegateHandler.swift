// Copyright 2018-present 650 Industries. All rights reserved.

import ABI50_0_0ExpoModulesCore

@objc(ABI50_0_0EXScreenOrientationReactDelegateHandler)
public class ScreenOrientationReactDelegateHandler: ExpoReactDelegateHandler {
  public override func createRootViewController(reactDelegate: ExpoReactDelegate) -> UIViewController? {
    return ScreenOrientationViewController(defaultScreenOrientationFromPlist: ())
  }
}
