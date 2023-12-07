/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTHost.h"
#import "ABI50_0_0RCTHost+Internal.h"

#import <ABI50_0_0React/ABI50_0_0RCTAssert.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricSurface.h>
#import <ABI50_0_0React/ABI50_0_0RCTJSThread.h>
#import <ABI50_0_0React/ABI50_0_0RCTLog.h>
#import <ABI50_0_0React/ABI50_0_0RCTMockDef.h>
#import <ABI50_0_0React/ABI50_0_0RCTPerformanceLogger.h>
#import <ABI50_0_0React/ABI50_0_0RCTReloadCommand.h>

ABI50_0_0RCT_MOCK_DEF(ABI50_0_0RCTHost, _ABI50_0_0RCTLogNativeInternal);
#define _ABI50_0_0RCTLogNativeInternal ABI50_0_0RCT_MOCK_USE(ABI50_0_0RCTHost, _ABI50_0_0RCTLogNativeInternal)

using namespace ABI50_0_0facebook::ABI50_0_0React;

@interface ABI50_0_0RCTHost () <ABI50_0_0RCTReloadListener, ABI50_0_0RCTInstanceDelegate>
@end

@implementation ABI50_0_0RCTHost {
  ABI50_0_0RCTInstance *_instance;

  __weak id<ABI50_0_0RCTHostDelegate> _hostDelegate;
  __weak id<ABI50_0_0RCTTurboModuleManagerDelegate> _turboModuleManagerDelegate;
  __weak id<ABI50_0_0RCTContextContainerHandling> _contextContainerHandler;

  NSURL *_oldDelegateBundleURL;
  NSURL *_bundleURL;
  ABI50_0_0RCTBundleManager *_bundleManager;
  ABI50_0_0RCTHostBundleURLProvider _bundleURLProvider;
  ABI50_0_0RCTHostJSEngineProvider _jsEngineProvider;

  // All the surfaces that need to be started after main bundle execution
  NSMutableArray<ABI50_0_0RCTFabricSurface *> *_surfaceStartBuffer;
  std::mutex _surfaceStartBufferMutex;

  ABI50_0_0RCTInstanceInitialBundleLoadCompletionBlock _onInitialBundleLoad;
  std::vector<__weak ABI50_0_0RCTFabricSurface *> _attachedSurfaces;

  ABI50_0_0RCTModuleRegistry *_moduleRegistry;
}

+ (void)initialize
{
  _ABI50_0_0RCTInitializeJSThreadConstantInternal();
}

/**
 Host initialization should not be resource intensive. A host may be created before any intention of using ABI50_0_0React Native
 has been expressed.
 */
- (instancetype)initWithBundleURL:(NSURL *)bundleURL
                     hostDelegate:(id<ABI50_0_0RCTHostDelegate>)hostDelegate
       turboModuleManagerDelegate:(id<ABI50_0_0RCTTurboModuleManagerDelegate>)turboModuleManagerDelegate
                 jsEngineProvider:(ABI50_0_0RCTHostJSEngineProvider)jsEngineProvider
{
  if (self = [super init]) {
    _hostDelegate = hostDelegate;
    _turboModuleManagerDelegate = turboModuleManagerDelegate;
    _surfaceStartBuffer = [NSMutableArray new];
    _bundleManager = [ABI50_0_0RCTBundleManager new];
    _moduleRegistry = [ABI50_0_0RCTModuleRegistry new];
    _jsEngineProvider = [jsEngineProvider copy];

    __weak ABI50_0_0RCTHost *weakSelf = self;

    auto bundleURLGetter = ^NSURL *()
    {
      ABI50_0_0RCTHost *strongSelf = weakSelf;
      if (!strongSelf) {
        return nil;
      }

      return strongSelf->_bundleURL;
    };

    auto bundleURLSetter = ^(NSURL *bundleURL_) {
      [weakSelf _setBundleURL:bundleURL];
    };

    auto defaultBundleURLGetter = ^NSURL *()
    {
      ABI50_0_0RCTHost *strongSelf = weakSelf;
      if (!strongSelf || !strongSelf->_bundleURLProvider) {
        return nil;
      }

      return strongSelf->_bundleURLProvider();
    };

    [self _setBundleURL:bundleURL];
    [_bundleManager setBridgelessBundleURLGetter:bundleURLGetter
                                       andSetter:bundleURLSetter
                                andDefaultGetter:defaultBundleURLGetter];

    /**
     * TODO (T108401473) Remove _onInitialBundleLoad, because it was initially
     * introduced to start surfaces after the main JSBundle was fully executed.
     * It is no longer needed because Fabric now dispatches all native-to-JS calls
     * onto the JS thread, including JS calls to start Fabric surfaces.
     * JS calls should be dispatched using the BufferedRuntimeExecutor, which can buffer
     * JS calls before the main JSBundle finishes execution, and execute them after.
     */
    _onInitialBundleLoad = ^{
      ABI50_0_0RCTHost *strongSelf = weakSelf;
      if (!strongSelf) {
        return;
      }

      NSArray<ABI50_0_0RCTFabricSurface *> *unstartedSurfaces = @[];

      {
        std::lock_guard<std::mutex> guard{strongSelf->_surfaceStartBufferMutex};
        unstartedSurfaces = [NSArray arrayWithArray:strongSelf->_surfaceStartBuffer];
        strongSelf->_surfaceStartBuffer = nil;
      }

      for (ABI50_0_0RCTFabricSurface *surface in unstartedSurfaces) {
        [surface start];
      }
    };

    // Listen to reload commands
    dispatch_async(dispatch_get_main_queue(), ^{
      ABI50_0_0RCTRegisterReloadCommandListener(self);
    });
  }
  return self;
}

#pragma mark - Public

- (void)start
{
  if (_instance) {
    ABI50_0_0RCTLogWarn(
        @"ABI50_0_0RCTHost should not be creating a new instance if one already exists. This implies there is a bug with how/when this method is being called.");
    [_instance invalidate];
  }
  _instance = [[ABI50_0_0RCTInstance alloc] initWithDelegate:self
                                   jsEngineInstance:[self _provideJSEngine]
                                      bundleManager:_bundleManager
                         turboModuleManagerDelegate:_turboModuleManagerDelegate
                                onInitialBundleLoad:_onInitialBundleLoad
                                     moduleRegistry:_moduleRegistry];
  [_hostDelegate hostDidStart:self];
}

- (ABI50_0_0RCTFabricSurface *)createSurfaceWithModuleName:(NSString *)moduleName
                                             mode:(DisplayMode)displayMode
                                initialProperties:(NSDictionary *)properties
{
  ABI50_0_0RCTFabricSurface *surface = [[ABI50_0_0RCTFabricSurface alloc] initWithSurfacePresenter:[self getSurfacePresenter]
                                                                      moduleName:moduleName
                                                               initialProperties:properties];
  surface.surfaceHandler.setDisplayMode(displayMode);
  [self _attachSurface:surface];

  {
    std::lock_guard<std::mutex> guard{_surfaceStartBufferMutex};
    if (_surfaceStartBuffer) {
      [_surfaceStartBuffer addObject:surface];
      return surface;
    }
  }

  [surface start];
  return surface;
}

- (ABI50_0_0RCTFabricSurface *)createSurfaceWithModuleName:(NSString *)moduleName initialProperties:(NSDictionary *)properties
{
  return [self createSurfaceWithModuleName:moduleName mode:DisplayMode::Visible initialProperties:properties];
}

- (ABI50_0_0RCTModuleRegistry *)getModuleRegistry
{
  return _moduleRegistry;
}

- (ABI50_0_0RCTSurfacePresenter *)getSurfacePresenter
{
  return [_instance surfacePresenter];
}

- (void)callFunctionOnJSModule:(NSString *)moduleName method:(NSString *)method args:(NSArray *)args
{
  [_instance callFunctionOnJSModule:moduleName method:method args:args];
}

#pragma mark - ABI50_0_0RCTReloadListener

- (void)didReceiveReloadCommand
{
  [_instance invalidate];
  _instance = nil;
  if (_bundleURLProvider) {
    [self _setBundleURL:_bundleURLProvider()];
  }

  // Ensure all attached surfaces are restarted after reload
  {
    std::lock_guard<std::mutex> guard{_surfaceStartBufferMutex};
    _surfaceStartBuffer = [NSMutableArray arrayWithArray:[self _getAttachedSurfaces]];
  }

  _instance = [[ABI50_0_0RCTInstance alloc] initWithDelegate:self
                                   jsEngineInstance:[self _provideJSEngine]
                                      bundleManager:_bundleManager
                         turboModuleManagerDelegate:_turboModuleManagerDelegate
                                onInitialBundleLoad:_onInitialBundleLoad
                                     moduleRegistry:_moduleRegistry];
  [_hostDelegate hostDidStart:self];

  for (ABI50_0_0RCTFabricSurface *surface in [self _getAttachedSurfaces]) {
    [surface resetWithSurfacePresenter:[self getSurfacePresenter]];
  }
}

- (void)dealloc
{
  [_instance invalidate];
}

#pragma mark - ABI50_0_0RCTInstanceDelegate

- (void)instance:(ABI50_0_0RCTInstance *)instance
    didReceiveJSErrorStack:(NSArray<NSDictionary<NSString *, id> *> *)stack
                   message:(NSString *)message
               exceptionId:(NSUInteger)exceptionId
                   isFatal:(BOOL)isFatal
{
  [_hostDelegate host:self didReceiveJSErrorStack:stack message:message exceptionId:exceptionId isFatal:isFatal];
}

- (void)instance:(ABI50_0_0RCTInstance *)instance didInitializeRuntime:(ABI50_0_0facebook::jsi::Runtime &)runtime
{
  [self.runtimeDelegate host:self didInitializeRuntime:runtime];
}

#pragma mark - ABI50_0_0RCTContextContainerHandling

- (void)didCreateContextContainer:(std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::ContextContainer>)contextContainer
{
  [_contextContainerHandler didCreateContextContainer:contextContainer];
}

#pragma mark - Internal

- (void)registerSegmentWithId:(NSNumber *)segmentId path:(NSString *)path
{
  [_instance registerSegmentWithId:segmentId path:path];
}

- (void)setBundleURLProvider:(ABI50_0_0RCTHostBundleURLProvider)bundleURLProvider
{
  _bundleURLProvider = [bundleURLProvider copy];
}

- (void)setContextContainerHandler:(id<ABI50_0_0RCTContextContainerHandling>)contextContainerHandler
{
  _contextContainerHandler = contextContainerHandler;
}

#pragma mark - Private

- (void)_attachSurface:(ABI50_0_0RCTFabricSurface *)surface
{
  _attachedSurfaces.push_back(surface);
}

- (NSArray<ABI50_0_0RCTFabricSurface *> *)_getAttachedSurfaces
{
  NSMutableArray<ABI50_0_0RCTFabricSurface *> *surfaces = [NSMutableArray new];
  for (ABI50_0_0RCTFabricSurface *surface : _attachedSurfaces) {
    if (surface) {
      [surfaces addObject:surface];
    }
  }

  return surfaces;
}

- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::JSEngineInstance>)_provideJSEngine
{
  ABI50_0_0RCTAssert(_jsEngineProvider, @"_jsEngineProvider must be non-nil");
  std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::JSEngineInstance> jsEngine = _jsEngineProvider();
  ABI50_0_0RCTAssert(jsEngine != nullptr, @"_jsEngineProvider must return a nonnull pointer");

  return jsEngine;
}

- (void)_setBundleURL:(NSURL *)bundleURL
{
  // Reset the _bundleURL ivar if the ABI50_0_0RCTHost delegate presents a new bundleURL
  NSURL *newDelegateBundleURL = bundleURL;
  if (newDelegateBundleURL && ![newDelegateBundleURL isEqual:_oldDelegateBundleURL]) {
    _oldDelegateBundleURL = newDelegateBundleURL;
    _bundleURL = newDelegateBundleURL;
  }

  // Sanitize the bundle URL
  _bundleURL = [ABI50_0_0RCTConvert NSURL:_bundleURL.absoluteString];

  // Update the global bundle URLq
  ABI50_0_0RCTReloadCommandSetBundleURL(_bundleURL);
}

@end
