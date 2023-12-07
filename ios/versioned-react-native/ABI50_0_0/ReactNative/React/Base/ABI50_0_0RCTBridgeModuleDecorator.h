/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTBridgeModule.h"

@class ABI50_0_0RCTBundleManager;
@class ABI50_0_0RCTCallableJSModules;
@class ABI50_0_0RCTModuleRegistry;
@class ABI50_0_0RCTViewRegistry;

/**
 ABI50_0_0RCTBridgeModuleDecorator contains instances that can be initialized with @synthesize
 in ABI50_0_0RCTBridgeModules. For the Fabric interop layer.

 In Bridgeless, @synthesize ivars are passed from ABI50_0_0RCTBridgeModuleDecorator.
 In Bridge, @synthesize ivars are passed from ABI50_0_0RCTModuleData.
 */
@interface ABI50_0_0RCTBridgeModuleDecorator : NSObject
@property (nonatomic, strong, readonly) ABI50_0_0RCTViewRegistry *viewRegistry_DEPRECATED;
@property (nonatomic, strong, readonly) ABI50_0_0RCTModuleRegistry *moduleRegistry;
@property (nonatomic, strong, readonly) ABI50_0_0RCTBundleManager *bundleManager;
@property (nonatomic, strong, readonly) ABI50_0_0RCTCallableJSModules *callableJSModules;

- (instancetype)initWithViewRegistry:(ABI50_0_0RCTViewRegistry *)viewRegistry
                      moduleRegistry:(ABI50_0_0RCTModuleRegistry *)moduleRegistry
                       bundleManager:(ABI50_0_0RCTBundleManager *)bundleManager
                   callableJSModules:(ABI50_0_0RCTCallableJSModules *)callableJSModules;

- (void)attachInteropAPIsToModule:(id<ABI50_0_0RCTBridgeModule>)bridgeModule;

@end
