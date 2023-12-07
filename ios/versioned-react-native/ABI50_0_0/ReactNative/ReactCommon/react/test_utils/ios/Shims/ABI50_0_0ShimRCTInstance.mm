/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0ShimABI50_0_0RCTInstance.h"

#import <ABI50_0_0ReactCommon/ABI50_0_0RCTInstance.h>

#import "ABI50_0_0RCTSwizzleHelpers.h"

static __weak ShimABI50_0_0RCTInstance *weakShim = nil;

@implementation ShimABI50_0_0RCTInstance

- (instancetype)init
{
  if (self = [super init]) {
    _initCount = 0;
    ABI50_0_0RCTSwizzleInstanceSelector(
        [ABI50_0_0RCTInstance class],
        [ShimABI50_0_0RCTInstance class],
        @selector(initWithDelegate:
                  jsEngineInstance:bundleManager:turboModuleManagerDelegate:onInitialBundleLoad:moduleRegistry:));
    ABI50_0_0RCTSwizzleInstanceSelector([ABI50_0_0RCTInstance class], [ShimABI50_0_0RCTInstance class], @selector(invalidate));
    ABI50_0_0RCTSwizzleInstanceSelector(
        [ABI50_0_0RCTInstance class], [ShimABI50_0_0RCTInstance class], @selector(callFunctionOnJSModule:method:args:));
    weakShim = self;
  }
  return self;
}

- (void)reset
{
  ABI50_0_0RCTSwizzleInstanceSelector(
      [ABI50_0_0RCTInstance class],
      [ShimABI50_0_0RCTInstance class],
      @selector(initWithDelegate:
                jsEngineInstance:bundleManager:turboModuleManagerDelegate:onInitialBundleLoad:moduleRegistry:));
  ABI50_0_0RCTSwizzleInstanceSelector([ABI50_0_0RCTInstance class], [ShimABI50_0_0RCTInstance class], @selector(invalidate));
  ABI50_0_0RCTSwizzleInstanceSelector(
      [ABI50_0_0RCTInstance class], [ShimABI50_0_0RCTInstance class], @selector(callFunctionOnJSModule:method:args:));
  _initCount = 0;
  _invalidateCount = 0;
}

- (instancetype)initWithDelegate:(id<ABI50_0_0RCTInstanceDelegate>)delegate
                jsEngineInstance:(std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::JSEngineInstance>)jsEngineInstance
                   bundleManager:(ABI50_0_0RCTBundleManager *)bundleManager
      turboModuleManagerDelegate:(id<ABI50_0_0RCTTurboModuleManagerDelegate>)tmmDelegate
             onInitialBundleLoad:(ABI50_0_0RCTInstanceInitialBundleLoadCompletionBlock)onInitialBundleLoad
                  moduleRegistry:(ABI50_0_0RCTModuleRegistry *)moduleRegistry
{
  weakShim.initCount++;
  return self;
}

- (void)invalidate
{
  weakShim.invalidateCount++;
}

- (void)callFunctionOnJSModule:(NSString *)moduleName method:(NSString *)method args:(NSArray *)args
{
  weakShim.jsModuleName = moduleName;
  weakShim.method = method;
  weakShim.args = [args copy];
}

@end
