/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

typedef NS_ENUM(NSInteger, ABI50_0_0RCTPLTag) {
  ABI50_0_0RCTPLScriptDownload = 0,
  ABI50_0_0RCTPLScriptExecution,
  ABI50_0_0RCTPLRAMBundleLoad,
  ABI50_0_0RCTPLRAMStartupCodeSize,
  ABI50_0_0RCTPLRAMStartupNativeRequires,
  ABI50_0_0RCTPLRAMStartupNativeRequiresCount,
  ABI50_0_0RCTPLRAMNativeRequires,
  ABI50_0_0RCTPLRAMNativeRequiresCount,
  ABI50_0_0RCTPLNativeModuleInit,
  ABI50_0_0RCTPLNativeModuleMainThread,
  ABI50_0_0RCTPLNativeModulePrepareConfig,
  ABI50_0_0RCTPLNativeModuleMainThreadUsesCount,
  ABI50_0_0RCTPLNativeModuleSetup,
  ABI50_0_0RCTPLTurboModuleSetup,
  ABI50_0_0RCTPLJSCWrapperOpenLibrary,
  ABI50_0_0RCTPLBridgeStartup,
  ABI50_0_0RCTPLTTI,
  ABI50_0_0RCTPLBundleSize,
  ABI50_0_0RCTPLABI50_0_0ReactInstanceInit,
  ABI50_0_0RCTPLAppStartup,
  ABI50_0_0RCTPLInitABI50_0_0ReactRuntime,
  ABI50_0_0RCTPLSize // This is used to count the size
};
