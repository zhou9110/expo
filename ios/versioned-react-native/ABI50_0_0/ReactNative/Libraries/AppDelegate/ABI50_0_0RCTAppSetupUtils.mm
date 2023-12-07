/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTAppSetupUtils.h"

#import <ABI50_0_0React/ABI50_0_0RCTJSIExecutorRuntimeInstaller.h>
#import <ABI50_0_0React/renderer/runtimescheduler/ABI50_0_0RuntimeScheduler.h>
#import <ABI50_0_0React/renderer/runtimescheduler/ABI50_0_0RuntimeSchedulerBinding.h>

#if ABI50_0_0RCT_NEW_ARCH_ENABLED
// Turbo Module
#import <ABI50_0_0React/ABI50_0_0CoreModulesPlugins.h>
#import <ABI50_0_0React/ABI50_0_0RCTBundleAssetImageLoader.h>
#import <ABI50_0_0React/ABI50_0_0RCTDataRequestHandler.h>
#import <ABI50_0_0React/ABI50_0_0RCTFileRequestHandler.h>
#import <ABI50_0_0React/ABI50_0_0RCTGIFImageDecoder.h>
#import <ABI50_0_0React/ABI50_0_0RCTHTTPRequestHandler.h>
#import <ABI50_0_0React/ABI50_0_0RCTImageLoader.h>
#import <ABI50_0_0React/ABI50_0_0RCTNetworking.h>

// Fabric
#import <ABI50_0_0React/ABI50_0_0RCTFabricSurface.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfaceHostingProxyRootView.h>
#endif

#ifdef FB_SONARKIT_ENABLED
#import <FlipperKit/FlipperClient.h>
#import <FlipperKitLayoutPlugin/FlipperKitLayoutPlugin.h>
#import <FlipperKitNetworkPlugin/FlipperKitNetworkPlugin.h>
#import <FlipperKitABI50_0_0ReactPlugin/FlipperKitABI50_0_0ReactPlugin.h>
#import <FlipperKitUserDefaultsPlugin/FKUserDefaultsPlugin.h>
#import <SKIOSNetworkPlugin/SKIOSNetworkAdapter.h>

static void InitializeFlipper(UIApplication *application)
{
  FlipperClient *client = [FlipperClient sharedClient];
  SKDescriptorMapper *layoutDescriptorMapper = [[SKDescriptorMapper alloc] initWithDefaults];
  [client addPlugin:[[FlipperKitLayoutPlugin alloc] initWithRootNode:application
                                                withDescriptorMapper:layoutDescriptorMapper]];
  [client addPlugin:[[FKUserDefaultsPlugin alloc] initWithSuiteName:nil]];
  [client addPlugin:[FlipperKitABI50_0_0ReactPlugin new]];
  [client addPlugin:[[FlipperKitNetworkPlugin alloc] initWithNetworkAdapter:[SKIOSNetworkAdapter new]]];
  [client start];
}
#endif

void ABI50_0_0RCTAppSetupPrepareApp(UIApplication *application, BOOL turboModuleEnabled)
{
#ifdef FB_SONARKIT_ENABLED
  InitializeFlipper(application);
#endif

#if ABI50_0_0RCT_NEW_ARCH_ENABLED
  ABI50_0_0RCTEnableTurboModule(turboModuleEnabled);
#endif

#if DEBUG
  // Disable idle timer in dev builds to avoid putting application in background and complicating
  // Metro reconnection logic. Users only need this when running the application using our CLI tooling.
  application.idleTimerDisabled = YES;
#endif
}

UIView *
ABI50_0_0RCTAppSetupDefaultRootView(ABI50_0_0RCTBridge *bridge, NSString *moduleName, NSDictionary *initialProperties, BOOL fabricEnabled)
{
#if ABI50_0_0RCT_NEW_ARCH_ENABLED
  if (fabricEnabled) {
    id<ABI50_0_0RCTSurfaceProtocol> surface = [[ABI50_0_0RCTFabricSurface alloc] initWithBridge:bridge
                                                                   moduleName:moduleName
                                                            initialProperties:initialProperties];
    return [[ABI50_0_0RCTSurfaceHostingProxyRootView alloc] initWithSurface:surface];
  }
#endif
  return [[ABI50_0_0RCTRootView alloc] initWithBridge:bridge moduleName:moduleName initialProperties:initialProperties];
}

#if ABI50_0_0RCT_NEW_ARCH_ENABLED
id<ABI50_0_0RCTTurboModule> ABI50_0_0RCTAppSetupDefaultModuleFromClass(Class moduleClass)
{
  // Set up the default ABI50_0_0RCTImageLoader and ABI50_0_0RCTNetworking modules.
  if (moduleClass == ABI50_0_0RCTImageLoader.class) {
    return [[moduleClass alloc] initWithRedirectDelegate:nil
        loadersProvider:^NSArray<id<ABI50_0_0RCTImageURLLoader>> *(ABI50_0_0RCTModuleRegistry *moduleRegistry) {
          return @[ [ABI50_0_0RCTBundleAssetImageLoader new] ];
        }
        decodersProvider:^NSArray<id<ABI50_0_0RCTImageDataDecoder>> *(ABI50_0_0RCTModuleRegistry *moduleRegistry) {
          return @[ [ABI50_0_0RCTGIFImageDecoder new] ];
        }];
  } else if (moduleClass == ABI50_0_0RCTNetworking.class) {
    return [[moduleClass alloc]
        initWithHandlersProvider:^NSArray<id<ABI50_0_0RCTURLRequestHandler>> *(ABI50_0_0RCTModuleRegistry *moduleRegistry) {
          return @[
            [ABI50_0_0RCTHTTPRequestHandler new],
            [ABI50_0_0RCTDataRequestHandler new],
            [ABI50_0_0RCTFileRequestHandler new],
          ];
        }];
  }
  // No custom initializer here.
  return [moduleClass new];
}

std::unique_ptr<ABI50_0_0facebook::ABI50_0_0React::JSExecutorFactory> ABI50_0_0RCTAppSetupDefaultJsExecutorFactory(
    ABI50_0_0RCTBridge *bridge,
    ABI50_0_0RCTTurboModuleManager *turboModuleManager,
    const std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::RuntimeScheduler> &runtimeScheduler)
{
  // Necessary to allow NativeModules to lookup TurboModules
  [bridge setABI50_0_0RCTTurboModuleRegistry:turboModuleManager];

#if ABI50_0_0RCT_DEV
  /**
   * Instantiating DevMenu has the side-effect of registering
   * shortcuts for CMD + d, CMD + i,  and CMD + n via ABI50_0_0RCTDevMenu.
   * Therefore, when TurboModules are enabled, we must manually create this
   * NativeModule.
   */
  [turboModuleManager moduleForName:"ABI50_0_0RCTDevMenu"];
#endif // end ABI50_0_0RCT_DEV

#if ABI50_0_0RCT_USE_HERMES
  return std::make_unique<ABI50_0_0facebook::ABI50_0_0React::HermesExecutorFactory>(
#else
  return std::make_unique<ABI50_0_0facebook::ABI50_0_0React::JSCExecutorFactory>(
#endif // end ABI50_0_0RCT_USE_HERMES
      ABI50_0_0facebook::ABI50_0_0React::ABI50_0_0RCTJSIExecutorRuntimeInstaller(
          [turboModuleManager, bridge, runtimeScheduler](ABI50_0_0facebook::jsi::Runtime &runtime) {
            if (!bridge || !turboModuleManager) {
              return;
            }
            if (runtimeScheduler) {
              ABI50_0_0facebook::ABI50_0_0React::RuntimeSchedulerBinding::createAndInstallIfNeeded(runtime, runtimeScheduler);
            }
            [turboModuleManager installJSBindings:runtime];
          }));
}

#else // else !ABI50_0_0RCT_NEW_ARCH_ENABLED

std::unique_ptr<ABI50_0_0facebook::ABI50_0_0React::JSExecutorFactory> ABI50_0_0RCTAppSetupJsExecutorFactoryForOldArch(
    ABI50_0_0RCTBridge *bridge,
    const std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::RuntimeScheduler> &runtimeScheduler)
{
#if ABI50_0_0RCT_USE_HERMES
  return std::make_unique<ABI50_0_0facebook::ABI50_0_0React::HermesExecutorFactory>(
#else
  return std::make_unique<ABI50_0_0facebook::ABI50_0_0React::JSCExecutorFactory>(
#endif // end ABI50_0_0RCT_USE_HERMES
      ABI50_0_0facebook::ABI50_0_0React::ABI50_0_0RCTJSIExecutorRuntimeInstaller([bridge, runtimeScheduler](ABI50_0_0facebook::jsi::Runtime &runtime) {
        if (!bridge) {
          return;
        }
        if (runtimeScheduler) {
          ABI50_0_0facebook::ABI50_0_0React::RuntimeSchedulerBinding::createAndInstallIfNeeded(runtime, runtimeScheduler);
        }
      }));
}
#endif // end ABI50_0_0RCT_NEW_ARCH_ENABLED
