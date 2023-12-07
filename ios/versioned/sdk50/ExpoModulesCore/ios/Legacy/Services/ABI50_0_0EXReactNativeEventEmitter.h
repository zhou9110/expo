// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0React/ABI50_0_0RCTEventEmitter.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXInternalModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXEventEmitterService.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryConsumer.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXBridgeModule.h>

// Swift compatibility headers (e.g. `ExpoModulesCore-Swift.h`) are not available in headers,
// so we use class forward declaration here. Swift header must be imported in the `.m` file.
@class ABI50_0_0EXAppContext;

@interface ABI50_0_0EXReactNativeEventEmitter : ABI50_0_0RCTEventEmitter <ABI50_0_0EXInternalModule, ABI50_0_0EXBridgeModule, ABI50_0_0EXModuleRegistryConsumer, ABI50_0_0EXEventEmitterService>

@property (nonatomic, strong) ABI50_0_0EXAppContext *appContext;

@end
