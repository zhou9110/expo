/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTPerformanceLoggerLabels.h"
#import <ABI50_0_0React/ABI50_0_0RCTAssert.h>

NSString *ABI50_0_0RCTPLLabelForTag(ABI50_0_0RCTPLTag tag)
{
  switch (tag) {
    case ABI50_0_0RCTPLScriptDownload:
      return @"ScriptDownload";
    case ABI50_0_0RCTPLScriptExecution:
      return @"ScriptExecution";
    case ABI50_0_0RCTPLRAMBundleLoad:
      return @"RAMBundleLoad";
    case ABI50_0_0RCTPLRAMStartupCodeSize:
      return @"RAMStartupCodeSize";
    case ABI50_0_0RCTPLRAMStartupNativeRequires:
      return @"RAMStartupNativeRequires";
    case ABI50_0_0RCTPLRAMStartupNativeRequiresCount:
      return @"RAMStartupNativeRequiresCount";
    case ABI50_0_0RCTPLRAMNativeRequires:
      return @"RAMNativeRequires";
    case ABI50_0_0RCTPLRAMNativeRequiresCount:
      return @"RAMNativeRequiresCount";
    case ABI50_0_0RCTPLNativeModuleInit:
      return @"NativeModuleInit";
    case ABI50_0_0RCTPLNativeModuleMainThread:
      return @"NativeModuleMainThread";
    case ABI50_0_0RCTPLNativeModulePrepareConfig:
      return @"NativeModulePrepareConfig";
    case ABI50_0_0RCTPLNativeModuleMainThreadUsesCount:
      return @"NativeModuleMainThreadUsesCount";
    case ABI50_0_0RCTPLNativeModuleSetup:
      return @"NativeModuleSetup";
    case ABI50_0_0RCTPLTurboModuleSetup:
      return @"TurboModuleSetup";
    case ABI50_0_0RCTPLJSCWrapperOpenLibrary:
      return @"JSCWrapperOpenLibrary";
    case ABI50_0_0RCTPLBridgeStartup:
      return @"BridgeStartup";
    case ABI50_0_0RCTPLTTI:
      return @"RootViewTTI";
    case ABI50_0_0RCTPLBundleSize:
      return @"BundleSize";
    case ABI50_0_0RCTPLABI50_0_0ReactInstanceInit:
      return @"ABI50_0_0ReactInstanceInit";
    case ABI50_0_0RCTPLAppStartup:
      return @"AppStartup";
    case ABI50_0_0RCTPLInitABI50_0_0ReactRuntime:
      return @"InitABI50_0_0ReactRuntime";
    case ABI50_0_0RCTPLSize: // Only used to count enum size
      ABI50_0_0RCTAssert(NO, @"ABI50_0_0RCTPLSize should not be used to track performance timestamps.");
      return nil;
  }
}
