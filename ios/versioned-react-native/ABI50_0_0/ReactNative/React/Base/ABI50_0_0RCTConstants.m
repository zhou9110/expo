/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTConstants.h"

NSString *const ABI50_0_0RCTPlatformName = @"ios";

NSString *const ABI50_0_0RCTUserInterfaceStyleDidChangeNotification = @"ABI50_0_0RCTUserInterfaceStyleDidChangeNotification";
NSString *const ABI50_0_0RCTUserInterfaceStyleDidChangeNotificationTraitCollectionKey = @"traitCollection";

NSString *const ABI50_0_0RCTWindowFrameDidChangeNotification = @"ABI50_0_0RCTWindowFrameDidChangeNotification";

NSString *const ABI50_0_0RCTJavaScriptDidFailToLoadNotification = @"ABI50_0_0RCTJavaScriptDidFailToLoadNotification";
NSString *const ABI50_0_0RCTJavaScriptDidLoadNotification = @"ABI50_0_0RCTJavaScriptDidLoadNotification";
NSString *const ABI50_0_0RCTJavaScriptWillStartExecutingNotification = @"ABI50_0_0RCTJavaScriptWillStartExecutingNotification";
NSString *const ABI50_0_0RCTJavaScriptWillStartLoadingNotification = @"ABI50_0_0RCTJavaScriptWillStartLoadingNotification";

NSString *const ABI50_0_0RCTDidInitializeModuleNotification = @"ABI50_0_0RCTDidInitializeModuleNotification";

/*
 * W3C Pointer Events
 */
static BOOL ABI50_0_0RCTDispatchW3CPointerEvents = NO;

BOOL ABI50_0_0RCTGetDispatchW3CPointerEvents(void)
{
  return ABI50_0_0RCTDispatchW3CPointerEvents;
}

void ABI50_0_0RCTSetDispatchW3CPointerEvents(BOOL value)
{
  ABI50_0_0RCTDispatchW3CPointerEvents = value;
}

/*
 * Validate ABI50_0_0RCTEventEmitter. For experimentation only.
 */
static BOOL ABI50_0_0RCTValidateCanSendEventInABI50_0_0RCTEventEmitter = NO;

BOOL ABI50_0_0RCTGetValidateCanSendEventInABI50_0_0RCTEventEmitter(void)
{
  return ABI50_0_0RCTValidateCanSendEventInABI50_0_0RCTEventEmitter;
}

void ABI50_0_0RCTSetValidateCanSendEventInABI50_0_0RCTEventEmitter(BOOL value)
{
  ABI50_0_0RCTValidateCanSendEventInABI50_0_0RCTEventEmitter = value;
}

/*
 * Memory Pressure Unloading Level for experimentation only.
 * Default is 15, which is TRIM_MEMORY_RUNNING_CRITICAL.
 */
static int ABI50_0_0RCTMemoryPressureUnloadLevel = 15;

int ABI50_0_0RCTGetMemoryPressureUnloadLevel(void)
{
  return ABI50_0_0RCTMemoryPressureUnloadLevel;
}

void ABI50_0_0RCTSetMemoryPressureUnloadLevel(int value)
{
  ABI50_0_0RCTMemoryPressureUnloadLevel = value;
}

/*
 * In Bridge mode, parse the JS stack for unhandled JS errors, to display in RedBox.
 * When false (previous default behavior), a native stack is displayed in the RedBox.
 */
static BOOL ABI50_0_0RCTParseUnhandledJSErrorStackNatively = NO;

BOOL ABI50_0_0RCTGetParseUnhandledJSErrorStackNatively(void)
{
  return ABI50_0_0RCTParseUnhandledJSErrorStackNatively;
}

void ABI50_0_0RCTSetParseUnhandledJSErrorStackNatively(BOOL value)
{
  ABI50_0_0RCTParseUnhandledJSErrorStackNatively = value;
}

/*
 * Use native view configs in bridgeless mode
 */
static BOOL ABI50_0_0RCTUseNativeViewConfigsInBridgelessMode = NO;

BOOL ABI50_0_0RCTGetUseNativeViewConfigsInBridgelessMode(void)
{
  return ABI50_0_0RCTUseNativeViewConfigsInBridgelessMode;
}

void ABI50_0_0RCTSetUseNativeViewConfigsInBridgelessMode(BOOL value)
{
  ABI50_0_0RCTUseNativeViewConfigsInBridgelessMode = value;
}
