// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXUIManager.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXInternalModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXAppLifecycleService.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXAppLifecycleListener.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryConsumer.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXJavaScriptContextProvider.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXBridgeModule.h>

@interface ABI50_0_0EXReactNativeAdapter : NSObject <ABI50_0_0EXInternalModule, ABI50_0_0EXBridgeModule, ABI50_0_0EXAppLifecycleService, ABI50_0_0EXUIManager, ABI50_0_0EXJavaScriptContextProvider, ABI50_0_0EXModuleRegistryConsumer>

- (void)setBridge:(ABI50_0_0RCTBridge *)bridge;

@end
