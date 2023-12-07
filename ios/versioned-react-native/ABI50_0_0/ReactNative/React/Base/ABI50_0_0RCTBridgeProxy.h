/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

#import "ABI50_0_0RCTBridgeModule.h"

@class ABI50_0_0RCTBundleManager;
@class ABI50_0_0RCTCallableJSModules;
@class ABI50_0_0RCTModuleRegistry;
@class ABI50_0_0RCTViewRegistry;

@interface ABI50_0_0RCTBridgeProxy : NSProxy
- (instancetype)initWithViewRegistry:(ABI50_0_0RCTViewRegistry *)viewRegistry
                      moduleRegistry:(ABI50_0_0RCTModuleRegistry *)moduleRegistry
                       bundleManager:(ABI50_0_0RCTBundleManager *)bundleManager
                   callableJSModules:(ABI50_0_0RCTCallableJSModules *)callableJSModules
                  dispatchToJSThread:(void (^)(dispatch_block_t))dispatchToJSThread
               registerSegmentWithId:(void (^)(NSNumber *, NSString *))registerSegmentWithId NS_DESIGNATED_INITIALIZER;

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel;
- (void)forwardInvocation:(NSInvocation *)invocation;

- (void)logWarning:(NSString *)message cmd:(SEL)cmd;
- (void)logError:(NSString *)message cmd:(SEL)cmd;

/**
 * Methods required for ABI50_0_0RCTBridge class extensions
 */
- (id)moduleForClass:(Class)moduleClass;
- (id)moduleForName:(NSString *)moduleName lazilyLoadIfNecessary:(BOOL)lazilyLoad;
@end
