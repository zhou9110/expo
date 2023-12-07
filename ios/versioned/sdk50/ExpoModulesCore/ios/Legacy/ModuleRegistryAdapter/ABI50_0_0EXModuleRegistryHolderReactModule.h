// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistry.h>

@interface ABI50_0_0EXModuleRegistryHolderReactModule : NSObject <ABI50_0_0RCTBridgeModule>

- (nonnull instancetype)initWithModuleRegistry:(nonnull ABI50_0_0EXModuleRegistry *)moduleRegistry;
- (nullable ABI50_0_0EXModuleRegistry *)exModuleRegistry;

@end
