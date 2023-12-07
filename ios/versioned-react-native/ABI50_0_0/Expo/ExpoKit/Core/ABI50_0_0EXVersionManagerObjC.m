// Copyright 2015-present 650 Industries. All rights reserved.

#import "ABI50_0_0EXAppState.h"
#import "ABI50_0_0EXDevSettings.h"
#import "ABI50_0_0EXDisabledDevLoadingView.h"
#import "ABI50_0_0EXDisabledDevMenu.h"
#import "ABI50_0_0EXDisabledRedBox.h"
#import "ABI50_0_0EXVersionedNetworkInterceptor.h"
#import "ABI50_0_0EXVersionManagerObjC.h"
#import "ABI50_0_0EXScopedBridgeModule.h"
#import "ABI50_0_0EXStatusBarManager.h"
#import "ABI50_0_0EXUnversioned.h"
#import "ABI50_0_0EXTest.h"

#import <ABI50_0_0React/ABI50_0_0RCTAssert.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>
#import <ABI50_0_0React/ABI50_0_0RCTDevMenu.h>
#import <ABI50_0_0React/ABI50_0_0RCTDevSettings.h>
#import <ABI50_0_0React/ABI50_0_0RCTExceptionsManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTLog.h>
#import <ABI50_0_0React/ABI50_0_0RCTRedBox.h>
#import <ABI50_0_0React/ABI50_0_0RCTPackagerConnection.h>
#import <ABI50_0_0React/ABI50_0_0RCTModuleData.h>
#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>
#import <ABI50_0_0React/ABI50_0_0RCTDataRequestHandler.h>
#import <ABI50_0_0React/ABI50_0_0RCTFileRequestHandler.h>
#import <ABI50_0_0React/ABI50_0_0RCTHTTPRequestHandler.h>
#import <ABI50_0_0React/ABI50_0_0RCTNetworking.h>
#import <ABI50_0_0React/ABI50_0_0RCTLocalAssetImageLoader.h>
#import <ABI50_0_0React/ABI50_0_0RCTGIFImageDecoder.h>
#import <ABI50_0_0React/ABI50_0_0RCTImageLoader.h>
#import <ABI50_0_0React/ABI50_0_0RCTInspectorDevServerHelper.h>
#import <ABI50_0_0React/ABI50_0_0CoreModulesPlugins.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXNativeModulesProxy.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryHolderReactModule.h>
#import <ABI50_0_0EXMediaLibrary/ABI50_0_0EXMediaLibraryImageLoader.h>

// When `use_frameworks!` is used, the generated Swift header is inside modules.
// Otherwise, it's available only locally with double-quoted imports.
#if __has_include(<ABI50_0_0EXManifests/ABI50_0_0EXManifests-Swift.h>)
#import <ABI50_0_0EXManifests/ABI50_0_0EXManifests-Swift.h>
#else
#import "ABI50_0_0EXManifests-Swift.h"
#endif

// Import 3rd party modules that need to be scoped.
#import <ABI50_0_0RNCAsyncStorage/ABI50_0_0RNCAsyncStorage.h>
#import "ABI50_0_0RNCWebViewManager.h"

#import "ABI50_0_0EXScopedModuleRegistry.h"
#import "ABI50_0_0EXScopedModuleRegistryAdapter.h"
#import "ABI50_0_0EXScopedModuleRegistryDelegate.h"

#import "ABI50_0_0Expo_Go-Swift.h"

ABI50_0_0RCT_EXTERN NSDictionary<NSString *, NSDictionary *> *ABI50_0_0EXGetScopedModuleClasses(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0EXRegisterScopedModule(Class, ...);

// this is needed because ABI50_0_0RCTPerfMonitor does not declare a public interface
// anywhere that we can import.
@interface ABI50_0_0RCTPerfMonitorDevSettingsHack <NSObject>

- (void)hide;
- (void)show;

@end

@interface ABI50_0_0RCTBridgeHack <NSObject>

- (void)reload;

@end

@interface ABI50_0_0EXVersionManagerObjC ()

// is this the first time this ABI has been touched at runtime?
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) ABI50_0_0EXManifestsManifest *manifest;
@property (nonatomic, strong) ABI50_0_0EXVersionedNetworkInterceptor *networkInterceptor;

// Legacy
@property (nonatomic, strong) ABI50_0_0EXModuleRegistry *legacyModuleRegistry;
@property (nonatomic, strong) ABI50_0_0EXNativeModulesProxy *legacyModulesProxy;

@end

@implementation ABI50_0_0EXVersionManagerObjC

/**
 * Uses a params dict since the internal workings may change over time, but we want to keep the interface the same.
 *  Expected params:
 *    NSDictionary *constants
 *    NSURL *initialUri
 *    @BOOL isDeveloper
 *    @BOOL isStandardDevMenuAllowed
 *    @ABI50_0_0EXTestEnvironment testEnvironment
 *    NSDictionary *services
 *
 * Kernel-only:
 *    ABI50_0_0EXKernel *kernel
 *    NSArray *supportedSdkVersions
 *    id exceptionsManagerDelegate
 */
- (nonnull instancetype)initWithParams:(nonnull NSDictionary *)params
                              manifest:(nonnull ABI50_0_0EXManifestsManifest *)manifest
                          fatalHandler:(void (^ _Nonnull)(NSError * _Nullable))fatalHandler
                           logFunction:(nonnull ABI50_0_0RCTLogFunction)logFunction
                          logThreshold:(ABI50_0_0RCTLogLevel)logThreshold
{
  if (self = [super init]) {
    _params = params;
    _manifest = manifest;
  }
  return self;
}

+ (void)load
{
  // Register scoped 3rd party modules. Some of them are separate pods that
  // don't have access to ABI50_0_0EXScopedModuleRegistry and so they can't register themselves.
  ABI50_0_0EXRegisterScopedModule([ABI50_0_0RNCWebViewManager class], ABI50_0_0EX_KERNEL_SERVICE_NONE, nil);
}

- (void)bridgeWillStartLoading:(id)bridge
{
  if ([self _isDevModeEnabledForBridge:bridge]) {
    // Set the bundle url for the packager connection manually
    NSURL *bundleURL = [bridge bundleURL];
    NSString *packagerServerHostPort = [NSString stringWithFormat:@"%@:%@", bundleURL.host, bundleURL.port];
    [[ABI50_0_0RCTPackagerConnection sharedPackagerConnection] reconnect:packagerServerHostPort];
    ABI50_0_0RCTInspectorPackagerConnection *inspectorPackagerConnection = [ABI50_0_0RCTInspectorDevServerHelper connectWithBundleURL:bundleURL];

    NSDictionary<NSString *, id> *buildProps = [self.manifest getPluginPropertiesWithPackageName:@"expo-build-properties"];
    NSNumber *enableNetworkInterceptor = [[buildProps objectForKey:@"ios"] objectForKey:@"unstable_networkInspector"];
    if (enableNetworkInterceptor == nil || [enableNetworkInterceptor boolValue] != NO) {
      self.networkInterceptor = [[ABI50_0_0EXVersionedNetworkInterceptor alloc] initWithABI50_0_0RCTInspectorPackagerConnection:inspectorPackagerConnection];
    }
  }

  // Manually send a "start loading" notif, since the real one happened uselessly inside the ABI50_0_0RCTBatchedBridge constructor
  [[NSNotificationCenter defaultCenter]
   postNotificationName:ABI50_0_0RCTJavaScriptWillStartLoadingNotification object:bridge];
}

- (void)bridgeFinishedLoading:(id)bridge
{
  // Override the "Reload" button from Redbox to reload the app from manifest
  // Keep in mind that it is possible this will return a ABI50_0_0EXDisabledRedBox
  ABI50_0_0RCTRedBox *redBox = [self _moduleInstanceForBridge:bridge named:@"RedBox"];
  [redBox setOverrideReloadAction:^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EXReloadActiveAppRequest" object:nil];
  }];
}

- (void)invalidate {
  self.networkInterceptor = nil;
}

#pragma mark - Dev menu

- (NSDictionary<NSString *, NSString *> *)devMenuItemsForBridge:(id)bridge
{
  ABI50_0_0RCTDevSettings *devSettings = (ABI50_0_0RCTDevSettings *)[self _moduleInstanceForBridge:bridge named:@"DevSettings"];
  BOOL isDevModeEnabled = [self _isDevModeEnabledForBridge:bridge];
  NSMutableDictionary *items = [NSMutableDictionary new];

  if (isDevModeEnabled) {
    items[@"dev-inspector"] = @{
      @"label": devSettings.isElementInspectorShown ? @"Hide Element Inspector" : @"Show Element Inspector",
      @"isEnabled": @YES
    };
  } else {
    items[@"dev-inspector"] = @{
      @"label": @"Element Inspector Unavailable",
      @"isEnabled": @NO
    };
  }

  if ([self _isBridgeInspectable:bridge] && isDevModeEnabled) {
    items[@"dev-remote-debug"] = @{
      @"label": @"Open JS Debugger",
      @"isEnabled": @YES
    };
  } else if (
      [self.manifest.expoGoSDKVersion compare:@"49.0.0" options:NSNumericSearch] == NSOrderedAscending &&
      devSettings.isRemoteDebuggingAvailable &&
      isDevModeEnabled
    ) {
    items[@"dev-remote-debug"] = @{
      @"label": (devSettings.isDebuggingRemotely) ? @"Stop Remote Debugging" : @"Debug Remote JS",
      @"isEnabled": @YES
    };
  }

  if (devSettings.isHotLoadingAvailable && isDevModeEnabled) {
    items[@"dev-hmr"] = @{
      @"label": (devSettings.isHotLoadingEnabled) ? @"Disable Fast Refresh" : @"Enable Fast Refresh",
      @"isEnabled": @YES,
    };
  } else {
    items[@"dev-hmr"] =  @{
      @"label": @"Fast Refresh Unavailable",
      @"isEnabled": @NO,
      @"detail": @"Use the Reload button above to reload when in production mode. Switch back to development mode to use Fast Refresh."
    };
  }

  id perfMonitor = [self _moduleInstanceForBridge:bridge named:@"PerfMonitor"];
  if (perfMonitor && isDevModeEnabled) {
    items[@"dev-perf-monitor"] = @{
      @"label": devSettings.isPerfMonitorShown ? @"Hide Performance Monitor" : @"Show Performance Monitor",
      @"isEnabled": @YES,
    };
  } else {
    items[@"dev-perf-monitor"] = @{
      @"label": @"Performance Monitor Unavailable",
      @"isEnabled": @NO,
    };
  }

  return items;
}

- (void)selectDevMenuItemWithKey:(NSString *)key onBridge:(id)bridge
{
  ABI50_0_0RCTAssertMainQueue();
  ABI50_0_0RCTDevSettings *devSettings = (ABI50_0_0RCTDevSettings *)[self _moduleInstanceForBridge:bridge named:@"DevSettings"];
  if ([key isEqualToString:@"dev-reload"]) {
    // bridge could be an ABI50_0_0RCTBridge of any version and we need to cast it since ARC needs to know
    // the return type
    [(ABI50_0_0RCTBridgeHack *)bridge reload];
  } else if ([key isEqualToString:@"dev-remote-debug"]) {
    if ([self _isBridgeInspectable:bridge]) {
      [self _openJsInspector:bridge];
    } else {
      devSettings.isDebuggingRemotely = !devSettings.isDebuggingRemotely;
    }
  } else if ([key isEqualToString:@"dev-profiler"]) {
    devSettings.isProfilingEnabled = !devSettings.isProfilingEnabled;
  } else if ([key isEqualToString:@"dev-hmr"]) {
    devSettings.isHotLoadingEnabled = !devSettings.isHotLoadingEnabled;
  } else if ([key isEqualToString:@"dev-inspector"]) {
    [devSettings toggleElementInspector];
  } else if ([key isEqualToString:@"dev-perf-monitor"]) {
    id perfMonitor = [self _moduleInstanceForBridge:bridge named:@"PerfMonitor"];
    if (perfMonitor) {
      if (devSettings.isPerfMonitorShown) {
        [perfMonitor hide];
        devSettings.isPerfMonitorShown = NO;
      } else {
        [perfMonitor show];
        devSettings.isPerfMonitorShown = YES;
      }
    }
  }
}

- (void)showDevMenuForBridge:(id)bridge
{
  ABI50_0_0RCTAssertMainQueue();
  id devMenu = [self _moduleInstanceForBridge:bridge named:@"DevMenu"];
  // respondsToSelector: check is required because it's possible this bridge
  // was instantiated with a `disabledDevMenu` instance and the gesture preference was recently updated.
  if ([devMenu respondsToSelector:@selector(show)]) {
    [((ABI50_0_0RCTDevMenu *)devMenu) show];
  }
}

- (void)disableRemoteDebuggingForBridge:(id)bridge
{
  ABI50_0_0RCTDevSettings *devSettings = (ABI50_0_0RCTDevSettings *)[self _moduleInstanceForBridge:bridge named:@"DevSettings"];
  devSettings.isDebuggingRemotely = NO;
}

- (void)toggleRemoteDebuggingForBridge:(id)bridge
{
  ABI50_0_0RCTDevSettings *devSettings = (ABI50_0_0RCTDevSettings *)[self _moduleInstanceForBridge:bridge named:@"DevSettings"];
  devSettings.isDebuggingRemotely = !devSettings.isDebuggingRemotely;
}

- (void)togglePerformanceMonitorForBridge:(id)bridge
{
  ABI50_0_0RCTDevSettings *devSettings = (ABI50_0_0RCTDevSettings *)[self _moduleInstanceForBridge:bridge named:@"DevSettings"];
  id perfMonitor = [self _moduleInstanceForBridge:bridge named:@"PerfMonitor"];
  if (perfMonitor) {
    if (devSettings.isPerfMonitorShown) {
      [perfMonitor hide];
      devSettings.isPerfMonitorShown = NO;
    } else {
      [perfMonitor show];
      devSettings.isPerfMonitorShown = YES;
    }
  }
}

- (void)toggleElementInspectorForBridge:(id)bridge
{
  ABI50_0_0RCTDevSettings *devSettings = (ABI50_0_0RCTDevSettings *)[self _moduleInstanceForBridge:bridge named:@"DevSettings"];
  [devSettings toggleElementInspector];
}

- (uint32_t)addWebSocketNotificationHandler:(void (^)(NSDictionary<NSString *, id> *))handler
                                    queue:(dispatch_queue_t)queue
                                forMethod:(NSString *)method
{
  return [[ABI50_0_0RCTPackagerConnection sharedPackagerConnection] addNotificationHandler:handler queue:queue forMethod:method];
}

#pragma mark - internal

- (BOOL)_isDevModeEnabledForBridge:(id)bridge
{
  return ([ABI50_0_0RCTGetURLQueryParam([bridge bundleURL], @"dev") boolValue]);
}

- (BOOL)_isBridgeInspectable:(id)bridge
{
  return [[bridge batchedBridge] isInspectable];
}

- (void)_openJsInspector:(id)bridge
{
  NSInteger port = [[[bridge bundleURL] port] integerValue] ?: ABI50_0_0RCT_METRO_PORT;
  NSString *host = [[bridge bundleURL] host] ?: @"localhost";
  NSString *url =
      [NSString stringWithFormat:@"http://%@:%lld/inspector?applicationId=%@", host, (long long)port, NSBundle.mainBundle.bundleIdentifier];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  request.HTTPMethod = @"PUT";
  [[[NSURLSession sharedSession] dataTaskWithRequest:request] resume];
}

- (id<ABI50_0_0RCTBridgeModule>)_moduleInstanceForBridge:(id)bridge named:(NSString *)name
{
  return [bridge moduleForClass:[self getModuleClassFromName:[name UTF8String]]];
}

- (NSArray *)extraModulesForBridge:(id)bridge
{
  NSDictionary *params = _params;
  NSDictionary *services = params[@"services"];
  NSMutableArray *extraModules = [NSMutableArray new];

  // add scoped modules
  [extraModules addObjectsFromArray:[self _newScopedModulesForServices:services params:params]];

  if (params[@"testEnvironment"]) {
    ABI50_0_0EXTestEnvironment testEnvironment = (ABI50_0_0EXTestEnvironment)[params[@"testEnvironment"] unsignedIntegerValue];
    if (testEnvironment != ABI50_0_0EXTestEnvironmentNone) {
      ABI50_0_0EXTest *testModule = [[ABI50_0_0EXTest alloc] initWithEnvironment:testEnvironment];
      [extraModules addObject:testModule];
    }
  }

  if (params[@"browserModuleClass"]) {
    Class browserModuleClass = params[@"browserModuleClass"];
    id homeModule = [[browserModuleClass alloc] initWithExperienceStableLegacyId:self.manifest.stableLegacyId
                                                                        scopeKey:self.manifest.scopeKey
                                                                    easProjectId:self.manifest.easProjectId
                                                           kernelServiceDelegate:services[@"EXHomeModuleManager"]
                                                                          params:params];
    [extraModules addObject:homeModule];
  }

  if (!ABI50_0_0RCTTurboModuleEnabled()) {
    [extraModules addObject:[self getModuleInstanceFromClass:[self getModuleClassFromName:"DevSettings"]]];
    id exceptionsManager = [self getModuleInstanceFromClass:ABI50_0_0RCTExceptionsManagerCls()];
    if (exceptionsManager) {
      [extraModules addObject:exceptionsManager];
    }
    [extraModules addObject:[self getModuleInstanceFromClass:[self getModuleClassFromName:"DevMenu"]]];
    [extraModules addObject:[self getModuleInstanceFromClass:[self getModuleClassFromName:"RedBox"]]];
    [extraModules addObject:[self getModuleInstanceFromClass:ABI50_0_0RNCAsyncStorage.class]];
  }

  return extraModules;
}

- (NSArray *)_newScopedModulesForServices:(NSDictionary *)services params:(NSDictionary *)params
{
  NSMutableArray *result = [NSMutableArray array];
  NSDictionary<NSString *, NSDictionary *> *ABI50_0_0EXScopedModuleClasses = ABI50_0_0EXGetScopedModuleClasses();
  if (ABI50_0_0EXScopedModuleClasses) {
    [ABI50_0_0EXScopedModuleClasses enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull scopedModuleClassName, NSDictionary * _Nonnull kernelServiceClassNames, BOOL * _Nonnull stop) {
      NSMutableDictionary *moduleServices = [[NSMutableDictionary alloc] init];
      for (id kernelServiceClassName in kernelServiceClassNames) {
        NSString *kernelSerivceName = kernelServiceClassNames[kernelServiceClassName];
        id service = ([kernelSerivceName isEqualToString:ABI50_0_0EX_KERNEL_SERVICE_NONE]) ? [NSNull null] : services[kernelSerivceName];
        moduleServices[kernelServiceClassName] = service;
      }

      id scopedModule;
      Class scopedModuleClass = NSClassFromString(scopedModuleClassName);
      if (moduleServices.count > 1) {
        scopedModule = [[scopedModuleClass alloc] initWithExperienceStableLegacyId:self.manifest.stableLegacyId
                                                                          scopeKey:self.manifest.scopeKey
                                                                      easProjectId:self.manifest.easProjectId
                                                            kernelServiceDelegates:moduleServices
                                                                            params:params];
      } else if (moduleServices.count == 0) {
        scopedModule = [[scopedModuleClass alloc] initWithExperienceStableLegacyId:self.manifest.stableLegacyId
                                                                          scopeKey:self.manifest.scopeKey
                                                                      easProjectId:self.manifest.easProjectId
                                                             kernelServiceDelegate:nil
                                                                            params:params];
      } else {
        scopedModule = [[scopedModuleClass alloc] initWithExperienceStableLegacyId:self.manifest.stableLegacyId
                                                                          scopeKey:self.manifest.scopeKey
                                                                      easProjectId:self.manifest.easProjectId
                                                             kernelServiceDelegate:moduleServices[[moduleServices allKeys][0]]
                                                                            params:params];
      }

      if (scopedModule) {
        [result addObject:scopedModule];
      }
    }];
  }
  return result;
}

- (Class)getModuleClassFromName:(const char *)name
{
  if (strcmp(name, "DevSettings") == 0) {
    return ABI50_0_0EXDevSettings.class;
  }
  if (strcmp(name, "DevMenu") == 0) {
    if (![_params[@"isStandardDevMenuAllowed"] boolValue] || ![_params[@"isDeveloper"] boolValue]) {
      // non-kernel, or non-development kernel, uses expo menu instead of ABI50_0_0RCTDevMenu
      return ABI50_0_0EXDisabledDevMenu.class;
    }
  }
  if (strcmp(name, "RedBox") == 0) {
    if (![_params[@"isDeveloper"] boolValue]) {
      // user-facing (not debugging).
      // additionally disable ABI50_0_0RCTRedBox
      return ABI50_0_0EXDisabledRedBox.class;
    }
  }
  return ABI50_0_0RCTCoreModulesClassProvider(name);
}

- (id<ABI50_0_0RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass
{
  // Standard
  if (moduleClass == ABI50_0_0RCTImageLoader.class) {
    return [[moduleClass alloc] initWithRedirectDelegate:nil loadersProvider:^NSArray<id<ABI50_0_0RCTImageURLLoader>> *(ABI50_0_0RCTModuleRegistry *) {
      return @[[ABI50_0_0RCTLocalAssetImageLoader new], [ABI50_0_0EXMediaLibraryImageLoader new]];
    } decodersProvider:^NSArray<id<ABI50_0_0RCTImageDataDecoder>> *(ABI50_0_0RCTModuleRegistry *) {
      return @[[ABI50_0_0RCTGIFImageDecoder new]];
    }];
  } else if (moduleClass == ABI50_0_0RCTNetworking.class) {
    return [[moduleClass alloc] initWithHandlersProvider:^NSArray<id<ABI50_0_0RCTURLRequestHandler>> *(ABI50_0_0RCTModuleRegistry *) {
      return @[
        [ABI50_0_0RCTHTTPRequestHandler new],
        [ABI50_0_0RCTDataRequestHandler new],
        [ABI50_0_0RCTFileRequestHandler new],
      ];
    }];
  }

  // Expo-specific
  if (moduleClass == ABI50_0_0EXDevSettings.class) {
    BOOL isDevelopment = ![self _isOpeningHomeInProductionMode] && [_params[@"isDeveloper"] boolValue];
    return [[moduleClass alloc] initWithScopeKey:self.manifest.scopeKey isDevelopment:isDevelopment];
  } else if (moduleClass == ABI50_0_0RCTExceptionsManagerCls()) {
    id exceptionsManagerDelegate = _params[@"exceptionsManagerDelegate"];
    if (exceptionsManagerDelegate) {
      return [[moduleClass alloc] initWithDelegate:exceptionsManagerDelegate];
    } else {
      ABI50_0_0RCTLogWarn(@"No exceptions manager provided when building extra modules for bridge.");
    }
  } else if (moduleClass == ABI50_0_0RNCAsyncStorage.class) {
    NSString *documentDirectory;
    if (_params[@"fileSystemDirectories"]) {
      documentDirectory = _params[@"fileSystemDirectories"][@"documentDirectory"];
    } else {
      NSArray<NSString *> *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      documentDirectory = [documentPaths objectAtIndex:0];
    }
    NSString *localStorageDirectory = [documentDirectory stringByAppendingPathComponent:@"RCTAsyncLocalStorage"];
    return [[moduleClass alloc] initWithStorageDirectory:localStorageDirectory];
  }

  return [moduleClass new];
}

- (BOOL)_isOpeningHomeInProductionMode
{
  return _params[@"browserModuleClass"] && !self.manifest.developer;
}

- (void *)versionedJsExecutorFactoryForBridge:(nonnull ABI50_0_0RCTBridge *)bridge
{
  return [ABI50_0_0EXVersionUtils versionedJsExecutorFactoryForBridge:bridge engine:_manifest.jsEngine];
}

@end
