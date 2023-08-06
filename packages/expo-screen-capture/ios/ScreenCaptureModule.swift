// Copyright 2023-present 650 Industries. All rights reserved.

import ExpoModulesCore

public final class ScreenCaptureModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoScreenCapture")

    LegacyModule(EXScreenCaptureModule.self)
  }
}
