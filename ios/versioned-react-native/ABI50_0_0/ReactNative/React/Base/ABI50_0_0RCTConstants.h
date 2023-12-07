/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>

ABI50_0_0RCT_EXTERN NSString *const ABI50_0_0RCTPlatformName;

ABI50_0_0RCT_EXTERN NSString *const ABI50_0_0RCTUserInterfaceStyleDidChangeNotification;
ABI50_0_0RCT_EXTERN NSString *const ABI50_0_0RCTUserInterfaceStyleDidChangeNotificationTraitCollectionKey;

ABI50_0_0RCT_EXTERN NSString *const ABI50_0_0RCTWindowFrameDidChangeNotification;

/**
 * This notification fires when the bridge initializes.
 */
ABI50_0_0RCT_EXTERN NSString *const ABI50_0_0RCTJavaScriptWillStartLoadingNotification;

/**
 * This notification fires when the bridge starts executing the JS bundle.
 */
ABI50_0_0RCT_EXTERN NSString *const ABI50_0_0RCTJavaScriptWillStartExecutingNotification;

/**
 * This notification fires when the bridge has finished loading the JS bundle.
 */
ABI50_0_0RCT_EXTERN NSString *const ABI50_0_0RCTJavaScriptDidLoadNotification;

/**
 * This notification fires when the bridge failed to load the JS bundle. The
 * `error` key can be used to determine the error that occurred.
 */
ABI50_0_0RCT_EXTERN NSString *const ABI50_0_0RCTJavaScriptDidFailToLoadNotification;

/**
 * This notification fires each time a native module is instantiated. The
 * `module` key will contain a reference to the newly-created module instance.
 * Note that this notification may be fired before the module is available via
 * the `[bridge moduleForClass:]` method.
 */
ABI50_0_0RCT_EXTERN NSString *const ABI50_0_0RCTDidInitializeModuleNotification;

/*
 * W3C Pointer Events
 */
ABI50_0_0RCT_EXTERN BOOL ABI50_0_0RCTGetDispatchW3CPointerEvents(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTSetDispatchW3CPointerEvents(BOOL value);

/*
 * Validate ABI50_0_0RCTEventEmitter
 */
ABI50_0_0RCT_EXTERN BOOL ABI50_0_0RCTGetValidateCanSendEventInABI50_0_0RCTEventEmitter(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTSetValidateCanSendEventInABI50_0_0RCTEventEmitter(BOOL value);

/*
 * Memory Pressure Unloading Level
 */
ABI50_0_0RCT_EXTERN int ABI50_0_0RCTGetMemoryPressureUnloadLevel(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTSetMemoryPressureUnloadLevel(int value);

/*
 * Parse JS stack for unhandled JS errors caught in C++
 */
ABI50_0_0RCT_EXTERN BOOL ABI50_0_0RCTGetParseUnhandledJSErrorStackNatively(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTSetParseUnhandledJSErrorStackNatively(BOOL value);

/*
 * Use native view configs in bridgeless mode
 */
ABI50_0_0RCT_EXTERN BOOL ABI50_0_0RCTGetUseNativeViewConfigsInBridgelessMode(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTSetUseNativeViewConfigsInBridgelessMode(BOOL value);
