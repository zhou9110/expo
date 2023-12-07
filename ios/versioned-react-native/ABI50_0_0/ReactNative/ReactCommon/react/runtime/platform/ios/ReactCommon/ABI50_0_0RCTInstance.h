/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>
#import <ABI50_0_0React/renderer/mapbuffer/ABI50_0_0MapBuffer.h>
#import <ABI50_0_0React/runtime/ABI50_0_0JSEngineInstance.h>
#import <ABI50_0_0React/runtime/ABI50_0_0ReactInstance.h>

#import "ABI50_0_0RCTContextContainerHandling.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A utility to enable diagnostics mode at runtime. Useful for test runs.
 * The flags are comma-separated string tokens, or an empty string when
 * nothing is enabled.
 */
ABI50_0_0RCT_EXTERN NSString *ABI50_0_0RCTInstanceRuntimeDiagnosticFlags(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTInstanceSetRuntimeDiagnosticFlags(NSString *_Nullable flags);

@class ABI50_0_0RCTBundleManager;
@class ABI50_0_0RCTInstance;
@class ABI50_0_0RCTJSThreadManager;
@class ABI50_0_0RCTModuleRegistry;
@class ABI50_0_0RCTPerformanceLogger;
@class ABI50_0_0RCTSource;
@class ABI50_0_0RCTSurfacePresenter;

@protocol ABI50_0_0RCTTurboModuleManagerDelegate;

@protocol ABI50_0_0RCTInstanceDelegate <ABI50_0_0RCTContextContainerHandling>

- (void)instance:(ABI50_0_0RCTInstance *)instance
    didReceiveJSErrorStack:(NSArray<NSDictionary<NSString *, id> *> *)stack
                   message:(NSString *)message
               exceptionId:(NSUInteger)exceptionId
                   isFatal:(BOOL)isFatal;

- (void)instance:(ABI50_0_0RCTInstance *)instance didInitializeRuntime:(ABI50_0_0facebook::jsi::Runtime &)runtime;

@end

typedef void (^_Null_unspecified ABI50_0_0RCTInstanceInitialBundleLoadCompletionBlock)();

/**
 * ABI50_0_0RCTInstance owns and manages most of the pieces of infrastructure required to display a screen powered by ABI50_0_0React
 * Native. ABI50_0_0RCTInstance should never be instantiated in product code, but rather accessed through ABI50_0_0RCTHost. The host
 * ensures that any access to the instance is safe, and manages instance lifecycle.
 */
@interface ABI50_0_0RCTInstance : NSObject

- (instancetype)initWithDelegate:(id<ABI50_0_0RCTInstanceDelegate>)delegate
                jsEngineInstance:(std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::JSEngineInstance>)jsEngineInstance
                   bundleManager:(ABI50_0_0RCTBundleManager *)bundleManager
      turboModuleManagerDelegate:(id<ABI50_0_0RCTTurboModuleManagerDelegate>)turboModuleManagerDelegate
             onInitialBundleLoad:(ABI50_0_0RCTInstanceInitialBundleLoadCompletionBlock)onInitialBundleLoad
                  moduleRegistry:(ABI50_0_0RCTModuleRegistry *)moduleRegistry;

- (void)callFunctionOnJSModule:(NSString *)moduleName method:(NSString *)method args:(NSArray *)args;

- (void)registerSegmentWithId:(NSNumber *)segmentId path:(NSString *)path;

- (void)invalidate;

@property (nonatomic, readonly, strong) ABI50_0_0RCTSurfacePresenter *surfacePresenter;

@end

NS_ASSUME_NONNULL_END
