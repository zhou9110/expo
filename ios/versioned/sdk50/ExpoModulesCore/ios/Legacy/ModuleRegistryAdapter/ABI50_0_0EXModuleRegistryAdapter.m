// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXNativeModulesProxy.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryAdapter.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryProvider.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryHolderReactModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXReactNativeEventEmitter.h>

@interface ABI50_0_0EXModuleRegistryAdapter ()

@property (nonatomic, strong) ABI50_0_0EXModuleRegistryProvider *moduleRegistryProvider;

@end

@implementation ABI50_0_0EXModuleRegistryAdapter

- (nonnull instancetype)initWithModuleRegistryProvider:(ABI50_0_0EXModuleRegistryProvider *)moduleRegistryProvider
{
  if (self = [super init]) {
    _moduleRegistryProvider = moduleRegistryProvider;
  }
  return self;
}

- (NSArray<id<ABI50_0_0RCTBridgeModule>> *)extraModulesForBridge:(ABI50_0_0RCTBridge *)bridge
{
  return [self extraModulesForModuleRegistry:[_moduleRegistryProvider moduleRegistry]];
}

- (NSArray<id<ABI50_0_0RCTBridgeModule>> *)extraModulesForModuleRegistry:(ABI50_0_0EXModuleRegistry *)moduleRegistry
{
  NSMutableArray<id<ABI50_0_0RCTBridgeModule>> *extraModules = [NSMutableArray array];

  ABI50_0_0EXNativeModulesProxy *nativeModulesProxy = [[ABI50_0_0EXNativeModulesProxy alloc] initWithModuleRegistry:moduleRegistry];
  [extraModules addObject:nativeModulesProxy];

  // Event emitter is not automatically registered — we add it to the module registry here.
  // It will be added to the bridge later in this method, as it conforms to `ABI50_0_0RCTBridgeModule`.
  ABI50_0_0EXReactNativeEventEmitter *eventEmitter = [ABI50_0_0EXReactNativeEventEmitter new];
  [moduleRegistry registerInternalModule:eventEmitter];

  // It is possible that among internal modules there are some ABI50_0_0RCTBridgeModules --
  // let's add them to extraModules here.
  for (id<ABI50_0_0EXInternalModule> module in [moduleRegistry getAllInternalModules]) {
    if ([module conformsToProtocol:@protocol(ABI50_0_0RCTBridgeModule)]) {
      id<ABI50_0_0RCTBridgeModule> reactBridgeModule = (id<ABI50_0_0RCTBridgeModule>)module;
      [extraModules addObject:reactBridgeModule];
    }
  }
  
  // Adding the way to access the module registry from ABI50_0_0RCTBridgeModules.
  [extraModules addObject:[[ABI50_0_0EXModuleRegistryHolderReactModule alloc] initWithModuleRegistry:moduleRegistry]];

  // One could add some modules to the Module Registry after creating it.
  // Here is our last call for finalizing initialization.
  [moduleRegistry initialize];
  return extraModules;
}

@end
