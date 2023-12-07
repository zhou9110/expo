/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTAppDelegate.h"
#import <ABI50_0_0React/ABI50_0_0RCTCxxBridgeDelegate.h>
#import <ABI50_0_0React/ABI50_0_0RCTRootView.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfacePresenterBridgeAdapter.h>
#import <ABI50_0_0React/renderer/runtimescheduler/ABI50_0_0RuntimeScheduler.h>
#import "ABI50_0_0RCTAppSetupUtils.h"
#import "ABI50_0_0RCTLegacyInteropComponents.h"

#if ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0CoreModulesPlugins.h>
#import <ABI50_0_0React/ABI50_0_0RCTBundleURLProvider.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponentViewFactory.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponentViewProtocol.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricSurface.h>
#import <ABI50_0_0React/ABI50_0_0RCTLegacyViewManagerInteropComponentView.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfaceHostingProxyRootView.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfacePresenter.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTContextContainerHandling.h>
#if USE_HERMES
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTHermesInstance.h>
#else
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTJscInstance.h>
#endif
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTHost+Internal.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTHost.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTTurboModuleManager.h>
#import <ABI50_0_0React/ABI50_0_0config/ABI50_0_0ReactNativeConfig.h>
#import <ABI50_0_0React/renderer/runtimescheduler/ABI50_0_0RuntimeScheduler.h>
#import <ABI50_0_0React/renderer/runtimescheduler/ABI50_0_0RuntimeSchedulerCallInvoker.h>
#import <ABI50_0_0React/ABI50_0_0runtime/JSEngineInstance.h>

static NSString *const kRNConcurrentRoot = @"concurrentRoot";

@interface ABI50_0_0RCTAppDelegate () <
    ABI50_0_0RCTTurboModuleManagerDelegate,
    ABI50_0_0RCTComponentViewFactoryComponentProvider,
    ABI50_0_0RCTContextContainerHandling> {
  std::shared_ptr<const ABI50_0_0facebook::ABI50_0_0React::ABI50_0_0ReactNativeConfig> _ABI50_0_0ReactNativeConfig;
  ABI50_0_0facebook::ABI50_0_0React::ContextContainer::Shared _contextContainer;
}
@end

#endif

@interface ABI50_0_0RCTAppDelegate () <ABI50_0_0RCTCxxBridgeDelegate> {
  std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::RuntimeScheduler> _runtimeScheduler;
}
@end

@implementation ABI50_0_0RCTAppDelegate {
#if ABI50_0_0RCT_NEW_ARCH_ENABLED
  ABI50_0_0RCTHost *_ABI50_0_0ReactHost;
#endif
}

#if ABI50_0_0RCT_NEW_ARCH_ENABLED
- (instancetype)init
{
  if (self = [super init]) {
    _contextContainer = std::make_shared<ABI50_0_0facebook::ABI50_0_0React::ContextContainer const>();
    _ABI50_0_0ReactNativeConfig = std::make_shared<ABI50_0_0facebook::ABI50_0_0React::EmptyABI50_0_0ReactNativeConfig const>();
    _contextContainer->insert("ABI50_0_0ReactNativeConfig", _ABI50_0_0ReactNativeConfig);
  }
  return self;
}
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  BOOL enableTM = NO;
  BOOL enableBridgeless = NO;
#if ABI50_0_0RCT_NEW_ARCH_ENABLED
  enableTM = self.turboModuleEnabled;
  enableBridgeless = self.bridgelessEnabled;
#endif

  ABI50_0_0RCTAppSetupPrepareApp(application, enableTM);

  UIView *rootView;

  if (enableBridgeless) {
#if ABI50_0_0RCT_NEW_ARCH_ENABLED
    // Enable native view config interop only if both bridgeless mode and Fabric is enabled.
    ABI50_0_0RCTSetUseNativeViewConfigsInBridgelessMode([self fabricEnabled]);

    // Enable TurboModule interop by default in Bridgeless mode
    ABI50_0_0RCTEnableTurboModuleInterop(YES);
    ABI50_0_0RCTEnableTurboModuleInteropBridgeProxy(YES);

    [self createABI50_0_0ReactHost];
    [self unstable_registerLegacyComponents];
    [ABI50_0_0RCTComponentViewFactory currentComponentViewFactory].thirdPartyFabricComponentsProvider = self;
    ABI50_0_0RCTFabricSurface *surface = [_ABI50_0_0ReactHost createSurfaceWithModuleName:self.moduleName
                                                      initialProperties:launchOptions];

    ABI50_0_0RCTSurfaceHostingProxyRootView *surfaceHostingProxyRootView = [[ABI50_0_0RCTSurfaceHostingProxyRootView alloc]
        initWithSurface:surface
        sizeMeasureMode:ABI50_0_0RCTSurfaceSizeMeasureModeWidthExact | ABI50_0_0RCTSurfaceSizeMeasureModeHeightExact];

    rootView = (ABI50_0_0RCTRootView *)surfaceHostingProxyRootView;
#endif
  } else {
    if (!self.bridge) {
      self.bridge = [self createBridgeWithDelegate:self launchOptions:launchOptions];
    }
#if ABI50_0_0RCT_NEW_ARCH_ENABLED
    self.bridgeAdapter = [[ABI50_0_0RCTSurfacePresenterBridgeAdapter alloc] initWithBridge:self.bridge
                                                                 contextContainer:_contextContainer];
    self.bridge.surfacePresenter = self.bridgeAdapter.surfacePresenter;

    [self unstable_registerLegacyComponents];
    [ABI50_0_0RCTComponentViewFactory currentComponentViewFactory].thirdPartyFabricComponentsProvider = self;
#endif
    NSDictionary *initProps = [self prepareInitialProps];
    rootView = [self createRootViewWithBridge:self.bridge moduleName:self.moduleName initProps:initProps];
  }
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [self createRootViewController];
  [self setRootView:rootView toRootViewController:rootViewController];
  self.window.rootViewController = rootViewController;
  self.window.windowScene.delegate = self;
  [self.window makeKeyAndVisible];

  return YES;
}

- (NSURL *)sourceURLForBridge:(ABI50_0_0RCTBridge *)bridge
{
  [NSException raise:@"ABI50_0_0RCTBridgeDelegate::sourceURLForBridge not implemented"
              format:@"Subclasses must implement a valid sourceURLForBridge method"];
  return nil;
}

- (NSDictionary *)prepareInitialProps
{
  NSMutableDictionary *initProps = self.initialProps ? [self.initialProps mutableCopy] : [NSMutableDictionary new];

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  // Hardcoding the Concurrent Root as it it not recommended to
  // have the concurrentRoot turned off when Fabric is enabled.
  initProps[kRNConcurrentRoot] = @([self fabricEnabled]);
#endif

  return initProps;
}

- (ABI50_0_0RCTBridge *)createBridgeWithDelegate:(id<ABI50_0_0RCTBridgeDelegate>)delegate launchOptions:(NSDictionary *)launchOptions
{
  return [[ABI50_0_0RCTBridge alloc] initWithDelegate:delegate launchOptions:launchOptions];
}

- (UIView *)createRootViewWithBridge:(ABI50_0_0RCTBridge *)bridge
                          moduleName:(NSString *)moduleName
                           initProps:(NSDictionary *)initProps
{
  BOOL enableFabric = NO;
#if ABI50_0_0RCT_NEW_ARCH_ENABLED
  enableFabric = self.fabricEnabled;
#endif
  UIView *rootView = ABI50_0_0RCTAppSetupDefaultRootView(bridge, moduleName, initProps, enableFabric);

  rootView.backgroundColor = [UIColor systemBackgroundColor];

  return rootView;
}

- (UIViewController *)createRootViewController
{
  return [UIViewController new];
}

- (void)setRootView:(UIView *)rootView toRootViewController:(UIViewController *)rootViewController
{
  rootViewController.view = rootView;
}

- (BOOL)runtimeSchedulerEnabled
{
  return YES;
}

#pragma mark - UISceneDelegate
- (void)windowScene:(UIWindowScene *)windowScene
    didUpdateCoordinateSpace:(id<UICoordinateSpace>)previousCoordinateSpace
        interfaceOrientation:(UIInterfaceOrientation)previousInterfaceOrientation
             traitCollection:(UITraitCollection *)previousTraitCollection API_AVAILABLE(ios(13.0))
{
  [[NSNotificationCenter defaultCenter] postNotificationName:ABI50_0_0RCTWindowFrameDidChangeNotification object:self];
}

#pragma mark - ABI50_0_0RCTCxxBridgeDelegate
- (std::unique_ptr<ABI50_0_0facebook::ABI50_0_0React::JSExecutorFactory>)jsExecutorFactoryForBridge:(ABI50_0_0RCTBridge *)bridge
{
  _runtimeScheduler = std::make_shared<ABI50_0_0facebook::ABI50_0_0React::RuntimeScheduler>(ABI50_0_0RCTRuntimeExecutorFromBridge(bridge));
#if ABI50_0_0RCT_NEW_ARCH_ENABLED
  std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker> callInvoker =
      std::make_shared<ABI50_0_0facebook::ABI50_0_0React::RuntimeSchedulerCallInvoker>(_runtimeScheduler);
  ABI50_0_0RCTTurboModuleManager *turboModuleManager = [[ABI50_0_0RCTTurboModuleManager alloc] initWithBridge:bridge
                                                                                   delegate:self
                                                                                  jsInvoker:callInvoker];
  _contextContainer->erase("RuntimeScheduler");
  _contextContainer->insert("RuntimeScheduler", _runtimeScheduler);
  return ABI50_0_0RCTAppSetupDefaultJsExecutorFactory(bridge, turboModuleManager, _runtimeScheduler);
#else
  return ABI50_0_0RCTAppSetupJsExecutorFactoryForOldArch(bridge, _runtimeScheduler);
#endif
}

#if ABI50_0_0RCT_NEW_ARCH_ENABLED

#pragma mark - ABI50_0_0RCTTurboModuleManagerDelegate

- (Class)getModuleClassFromName:(const char *)name
{
  return ABI50_0_0RCTCoreModulesClassProvider(name);
}

- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule>)getTurboModule:(const std::string &)name
                                                      jsInvoker:(std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker>)jsInvoker
{
  return nullptr;
}

- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule>)getTurboModule:(const std::string &)name
                                                     initParams:
                                                         (const ABI50_0_0facebook::ABI50_0_0React::ObjCTurboModule::InitParams &)params
{
  return nullptr;
}

- (id<ABI50_0_0RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass
{
  return ABI50_0_0RCTAppSetupDefaultModuleFromClass(moduleClass);
}

#pragma mark - ABI50_0_0RCTComponentViewFactoryComponentProvider

- (NSDictionary<NSString *, Class<ABI50_0_0RCTComponentViewProtocol>> *)thirdPartyFabricComponents
{
  return @{};
}

#pragma mark - New Arch Enabled settings

- (BOOL)turboModuleEnabled
{
  return YES;
}

- (BOOL)fabricEnabled
{
  return YES;
}

- (BOOL)bridgelessEnabled
{
  return NO;
}

#pragma mark - New Arch Utilities

- (void)unstable_registerLegacyComponents
{
  for (NSString *legacyComponent in [ABI50_0_0RCTLegacyInteropComponents legacyInteropComponents]) {
    [ABI50_0_0RCTLegacyViewManagerInteropComponentView supportLegacyViewManagerWithName:legacyComponent];
  }
}

- (void)createABI50_0_0ReactHost
{
  __weak __typeof(self) weakSelf = self;
  _ABI50_0_0ReactHost = [[ABI50_0_0RCTHost alloc] initWithBundleURL:[self getBundleURL]
                                     hostDelegate:nil
                       turboModuleManagerDelegate:self
                                 jsEngineProvider:^std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::JSEngineInstance>() {
                                   return [weakSelf createJSEngineInstance];
                                 }];
  [_ABI50_0_0ReactHost setBundleURLProvider:^NSURL *() {
    return [weakSelf getBundleURL];
  }];
  [_ABI50_0_0ReactHost setContextContainerHandler:self];
  [_ABI50_0_0ReactHost start];
}

- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::JSEngineInstance>)createJSEngineInstance
{
#if USE_HERMES
  return std::make_shared<ABI50_0_0facebook::ABI50_0_0React::ABI50_0_0RCTHermesInstance>(_ABI50_0_0ReactNativeConfig, nullptr);
#else
  return std::make_shared<ABI50_0_0facebook::ABI50_0_0React::ABI50_0_0RCTJscInstance>();
#endif
}

- (void)didCreateContextContainer:(std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::ContextContainer>)contextContainer
{
  contextContainer->insert("ABI50_0_0ReactNativeConfig", _ABI50_0_0ReactNativeConfig);
}

- (NSURL *)getBundleURL
{
  [NSException raise:@"ABI50_0_0RCTAppDelegate::getBundleURL not implemented"
              format:@"Subclasses must implement a valid getBundleURL method"];
  return nullptr;
}

#endif

@end
