// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXJSIInstaller.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXJavaScriptRuntime.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0ExpoModulesHostObject.h>
#import <ABI50_0_0ExpoModulesCore/LazyObject.h>
#import <ABI50_0_0ExpoModulesCore/Swift.h>

namespace jsi = ABI50_0_0facebook::jsi;

/**
 Property name used to define the modules host object in the main object of the Expo JS runtime.
 */
static NSString *modulesHostObjectPropertyName = @"modules";

/**
 Property name used to define the modules host object in the global object of the Expo JS runtime (legacy).
 */
static NSString *modulesHostObjectLegacyPropertyName = @"ExpoModules";

@interface ABI50_0_0RCTBridge (ExpoBridgeWithRuntime)

- (void *)runtime;
- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker>)jsCallInvoker;

@end

@implementation ABI50_0_0EXJavaScriptRuntimeManager

+ (nullable ABI50_0_0EXRuntime *)runtimeFromBridge:(nonnull ABI50_0_0RCTBridge *)bridge
{
  jsi::Runtime *jsiRuntime = [bridge respondsToSelector:@selector(runtime)] ? reinterpret_cast<jsi::Runtime *>(bridge.runtime) : nullptr;
  return jsiRuntime ? [[ABI50_0_0EXRuntime alloc] initWithRuntime:jsiRuntime callInvoker:bridge.jsCallInvoker] : nil;
}

+ (BOOL)installExpoModulesHostObject:(nonnull ABI50_0_0EXAppContext *)appContext
{
  ABI50_0_0EXRuntime *runtime = [appContext _runtime];

  // The runtime may be unavailable, e.g. remote debugger is enabled or it hasn't been set yet.
  if (!runtime) {
    return false;
  }

  ABI50_0_0EXJavaScriptObject *global = [runtime global];
  ABI50_0_0EXJavaScriptObject *coreObject = [runtime coreObject];

  if ([coreObject hasProperty:modulesHostObjectPropertyName]) {
    return false;
  }

  std::shared_ptr<ABI50_0_0expo::ExpoModulesHostObject> modulesHostObjectPtr = std::make_shared<ABI50_0_0expo::ExpoModulesHostObject>(appContext);
  ABI50_0_0EXJavaScriptObject *modulesHostObject = [runtime createHostObject:modulesHostObjectPtr];

  // Define the `global.expo.modules` object as a non-configurable, read-only and enumerable property.
  [coreObject defineProperty:modulesHostObjectPropertyName
                       value:modulesHostObject
                     options:ABI50_0_0EXJavaScriptObjectPropertyDescriptorEnumerable];

  // Also define `global.ExpoModules` for backwards compatibility (used before SDK47, can be removed in SDK48).
  [global defineProperty:modulesHostObjectLegacyPropertyName
                   value:modulesHostObject
                 options:ABI50_0_0EXJavaScriptObjectPropertyDescriptorEnumerable];
  return true;
}

@end
