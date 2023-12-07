// Copyright 2023-present 650 Industries. All rights reserved.

#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>
#import <ABI50_0_0React/ABI50_0_0JSCExecutorFactory.h>
#import <ABI50_0_0React/ABI50_0_0RCTJSIExecutorRuntimeInstaller.h>
#import <ABI50_0_0React/ABI50_0_0CoreModulesPlugins.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTTurboModule.h>
#import <ABI50_0_0Reacthermes/HermesExecutorFactory.h>

#import <ABI50_0_0RNReanimated/ABI50_0_0REAModule.h>
#import <ABI50_0_0RNReanimated/NativeProxy.h>
#import <ABI50_0_0RNReanimated/ReanimatedVersion.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXDefines.h>

#import "ABI50_0_0EXDevSettings.h"
#import "ABI50_0_0EXDisabledDevMenu.h"
#import "ABI50_0_0EXDisabledRedBox.h"
#import "ABI50_0_0EXVersionUtils.h"

@interface ABI50_0_0RCTEventDispatcher (ABI50_0_0REAnimated)
- (void)setBridge:(ABI50_0_0RCTBridge*)bridge;
@end

@implementation ABI50_0_0EXVersionUtils

+ (nonnull void *)versionedJsExecutorFactoryForBridge:(nonnull ABI50_0_0RCTBridge *)bridge
                                               engine:(nonnull NSString *)jsEngine
{
  [bridge moduleForClass:[ABI50_0_0RCTUIManager class]];

  ABI50_0_0EX_WEAKIFY(self);
  const auto executor = [ABI50_0_0EXWeak_self, bridge](ABI50_0_0facebook::jsi::Runtime &runtime) {
    if (!bridge) {
      return;
    }
    ABI50_0_0EX_ENSURE_STRONGIFY(self);
  };
  if ([jsEngine isEqualToString:@"hermes"]) {
    return new ABI50_0_0facebook::ABI50_0_0React::HermesExecutorFactory(ABI50_0_0RCTJSIExecutorRuntimeInstaller(executor));
  }
  return new ABI50_0_0facebook::ABI50_0_0React::JSCExecutorFactory(ABI50_0_0RCTJSIExecutorRuntimeInstaller(executor));
}

@end
