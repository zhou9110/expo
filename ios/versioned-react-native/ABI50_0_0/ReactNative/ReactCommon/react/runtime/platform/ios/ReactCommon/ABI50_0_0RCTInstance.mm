/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTInstance.h"
#import <ABI50_0_0React/ABI50_0_0RCTBridgeProxy.h>

#import <memory>

#import <ABI50_0_0React/ABI50_0_0NSDataBigString.h>
#import <ABI50_0_0React/ABI50_0_0RCTAssert.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeModuleDecorator.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponentViewFactory.h>
#import <ABI50_0_0React/ABI50_0_0RCTConstants.h>
#import <ABI50_0_0React/ABI50_0_0RCTCxxUtils.h>
#import <ABI50_0_0React/ABI50_0_0RCTDevSettings.h>
#import <ABI50_0_0React/ABI50_0_0RCTDisplayLink.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcherProtocol.h>
#import <ABI50_0_0React/ABI50_0_0RCTFollyConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTJavaScriptLoader.h>
#import <ABI50_0_0React/ABI50_0_0RCTLog.h>
#import <ABI50_0_0React/ABI50_0_0RCTLogBox.h>
#import <ABI50_0_0React/ABI50_0_0RCTModuleData.h>
#import <ABI50_0_0React/ABI50_0_0RCTPerformanceLogger.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfacePresenter.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTTurboModuleManager.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RuntimeExecutor.h>
#import <ABI50_0_0cxxreact/ABI50_0_0ReactMarker.h>
#import <ABI50_0_0jsireact/ABI50_0_0JSIExecutor.h>
#import <ABI50_0_0React/runtime/ABI50_0_0BridgelessJSCallInvoker.h>
#import <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>
#import <ABI50_0_0React/utils/ABI50_0_0ManagedObjectWrapper.h>

#import "ABI50_0_0ObjCTimerRegistry.h"
#import "ABI50_0_0RCTJSThreadManager.h"
#import "ABI50_0_0RCTLegacyUIManagerConstantsProvider.h"
#import "ABI50_0_0RCTPerformanceLoggerUtils.h"

#if ABI50_0_0RCT_DEV_MENU && __has_include(<ABI50_0_0React/ABI50_0_0RCTDevLoadingViewProtocol.h>)
#import <ABI50_0_0React/ABI50_0_0RCTDevLoadingViewProtocol.h>
#endif

using namespace ABI50_0_0facebook;
using namespace ABI50_0_0facebook::ABI50_0_0React;

static NSString *sRuntimeDiagnosticFlags = nil;
NSString *ABI50_0_0RCTInstanceRuntimeDiagnosticFlags(void)
{
  return sRuntimeDiagnosticFlags ? [sRuntimeDiagnosticFlags copy] : [NSString new];
}

void ABI50_0_0RCTInstanceSetRuntimeDiagnosticFlags(NSString *flags)
{
  if (!flags) {
    return;
  }
  sRuntimeDiagnosticFlags = [flags copy];
}

@interface ABI50_0_0RCTInstance () <ABI50_0_0RCTTurboModuleManagerDelegate>
@end

@implementation ABI50_0_0RCTInstance {
  std::unique_ptr<ABI50_0_0ReactInstance> _ABI50_0_0ReactInstance;
  std::shared_ptr<JSEngineInstance> _jsEngineInstance;
  __weak id<ABI50_0_0RCTTurboModuleManagerDelegate> _appTMMDelegate;
  __weak id<ABI50_0_0RCTInstanceDelegate> _delegate;
  ABI50_0_0RCTSurfacePresenter *_surfacePresenter;
  ABI50_0_0RCTPerformanceLogger *_performanceLogger;
  ABI50_0_0RCTDisplayLink *_displayLink;
  ABI50_0_0RCTInstanceInitialBundleLoadCompletionBlock _onInitialBundleLoad;
  ABI50_0_0RCTTurboModuleManager *_turboModuleManager;
  std::mutex _invalidationMutex;
  std::atomic<bool> _valid;
  ABI50_0_0RCTJSThreadManager *_jsThreadManager;

  // APIs supporting interop with native modules and view managers
  ABI50_0_0RCTBridgeModuleDecorator *_bridgeModuleDecorator;
}

#pragma mark - Public

- (instancetype)initWithDelegate:(id<ABI50_0_0RCTInstanceDelegate>)delegate
                jsEngineInstance:(std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::JSEngineInstance>)jsEngineInstance
                   bundleManager:(ABI50_0_0RCTBundleManager *)bundleManager
      turboModuleManagerDelegate:(id<ABI50_0_0RCTTurboModuleManagerDelegate>)tmmDelegate
             onInitialBundleLoad:(ABI50_0_0RCTInstanceInitialBundleLoadCompletionBlock)onInitialBundleLoad
                  moduleRegistry:(ABI50_0_0RCTModuleRegistry *)moduleRegistry
{
  if (self = [super init]) {
    _performanceLogger = [ABI50_0_0RCTPerformanceLogger new];
    registerPerformanceLoggerHooks(_performanceLogger);
    [_performanceLogger markStartForTag:ABI50_0_0RCTPLABI50_0_0ReactInstanceInit];

    _delegate = delegate;
    _jsEngineInstance = jsEngineInstance;
    _appTMMDelegate = tmmDelegate;
    _jsThreadManager = [ABI50_0_0RCTJSThreadManager new];
    _onInitialBundleLoad = onInitialBundleLoad;
    _bridgeModuleDecorator = [[ABI50_0_0RCTBridgeModuleDecorator alloc] initWithViewRegistry:[ABI50_0_0RCTViewRegistry new]
                                                                     moduleRegistry:moduleRegistry
                                                                      bundleManager:bundleManager
                                                                  callableJSModules:[ABI50_0_0RCTCallableJSModules new]];
    {
      __weak __typeof(self) weakSelf = self;
      [_bridgeModuleDecorator.callableJSModules
          setBridgelessJSModuleMethodInvoker:^(
              NSString *moduleName, NSString *methodName, NSArray *args, dispatch_block_t onComplete) {
            // TODO: Make ABI50_0_0RCTInstance call onComplete
            [weakSelf callFunctionOnJSModule:moduleName method:methodName args:args];
          }];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_notifyEventDispatcherObserversOfEvent_DEPRECATED:)
                                                 name:@"ABI50_0_0RCTNotifyEventDispatcherObserversOfEvent_DEPRECATED"
                                               object:nil];

    [self _start];
  }
  return self;
}

- (void)callFunctionOnJSModule:(NSString *)moduleName method:(NSString *)method args:(NSArray *)args
{
  if (_valid) {
    _ABI50_0_0ReactInstance->callFunctionOnModule(
        [moduleName UTF8String], [method UTF8String], convertIdToFollyDynamic(args ?: @[]));
  }
}

- (void)invalidate
{
  std::lock_guard<std::mutex> lock(_invalidationMutex);
  _valid = false;

  [_surfacePresenter suspend];
  [_jsThreadManager dispatchToJSThread:^{
    /**
     * Every TurboModule is invalidated on its own method queue.
     * TurboModuleManager invalidate blocks the calling thread until all TurboModules are invalidated.
     */
    [self->_turboModuleManager invalidate];

    // Clean up all the Resources
    self->_ABI50_0_0ReactInstance = nullptr;
    self->_jsEngineInstance = nullptr;
    self->_appTMMDelegate = nil;
    self->_delegate = nil;
    self->_displayLink = nil;

    self->_turboModuleManager = nil;
    self->_performanceLogger = nil;

    // Terminate the JavaScript thread, so that no other work executes after this block.
    self->_jsThreadManager = nil;
  }];
}

- (void)registerSegmentWithId:(NSNumber *)segmentId path:(NSString *)path
{
  if (_valid) {
    _ABI50_0_0ReactInstance->registerSegment(static_cast<uint32_t>([segmentId unsignedIntValue]), path.UTF8String);
  }
}

#pragma mark - ABI50_0_0RCTTurboModuleManagerDelegate

- (Class)getModuleClassFromName:(const char *)name
{
  if ([_appTMMDelegate respondsToSelector:@selector(getModuleClassFromName:)]) {
    return [_appTMMDelegate getModuleClassFromName:name];
  }

  return nil;
}

- (id<ABI50_0_0RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass
{
  if ([_appTMMDelegate respondsToSelector:@selector(getModuleInstanceFromClass:)]) {
    id<ABI50_0_0RCTTurboModule> module = [_appTMMDelegate getModuleInstanceFromClass:moduleClass];
    [self _attachBridgelessAPIsToModule:module];
    return module;
  }

  return nil;
}

- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule>)getTurboModule:(const std::string &)name
                                                      jsInvoker:(std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker>)jsInvoker
{
  if ([_appTMMDelegate respondsToSelector:@selector(getTurboModule:jsInvoker:)]) {
    return [_appTMMDelegate getTurboModule:name jsInvoker:jsInvoker];
  }

  return nullptr;
}

#pragma mark - Private

- (void)_start
{
  // Set up timers
  auto objCTimerRegistry = std::make_unique<ObjCTimerRegistry>();
  auto timing = objCTimerRegistry->timing;
  auto *objCTimerRegistryRawPtr = objCTimerRegistry.get();

  auto timerManager = std::make_shared<TimerManager>(std::move(objCTimerRegistry));
  objCTimerRegistryRawPtr->setTimerManager(timerManager);

  __weak __typeof(self) weakSelf = self;
  auto jsErrorHandlingFunc = [=](MapBuffer errorMap) { [weakSelf _handleJSErrorMap:std::move(errorMap)]; };

  // Create the ABI50_0_0React Instance
  _ABI50_0_0ReactInstance = std::make_unique<ABI50_0_0ReactInstance>(
      _jsEngineInstance->createJSRuntime(_jsThreadManager.jsMessageThread),
      _jsThreadManager.jsMessageThread,
      timerManager,
      jsErrorHandlingFunc);
  _valid = true;

  RuntimeExecutor bufferedRuntimeExecutor = _ABI50_0_0ReactInstance->getBufferedRuntimeExecutor();
  timerManager->setRuntimeExecutor(bufferedRuntimeExecutor);

  ABI50_0_0RCTBridgeProxy *bridgeProxy =
      [[ABI50_0_0RCTBridgeProxy alloc] initWithViewRegistry:_bridgeModuleDecorator.viewRegistry_DEPRECATED
          moduleRegistry:_bridgeModuleDecorator.moduleRegistry
          bundleManager:_bridgeModuleDecorator.bundleManager
          callableJSModules:_bridgeModuleDecorator.callableJSModules
          dispatchToJSThread:^(dispatch_block_t block) {
            __strong __typeof(self) strongSelf = weakSelf;
            if (strongSelf && strongSelf->_valid) {
              strongSelf->_ABI50_0_0ReactInstance->getBufferedRuntimeExecutor()([=](jsi::Runtime &runtime) { block(); });
            }
          }
          registerSegmentWithId:^(NSNumber *segmentId, NSString *path) {
            __strong __typeof(self) strongSelf = weakSelf;
            if (strongSelf && strongSelf->_valid) {
              [strongSelf registerSegmentWithId:segmentId path:path];
            }
          }];

  // Set up TurboModules
  _turboModuleManager = [[ABI50_0_0RCTTurboModuleManager alloc]
        initWithBridgeProxy:bridgeProxy
      bridgeModuleDecorator:_bridgeModuleDecorator
                   delegate:self
                  jsInvoker:std::make_shared<BridgelessJSCallInvoker>(bufferedRuntimeExecutor)];

  // Initialize ABI50_0_0RCTModuleRegistry so that TurboModules can require other TurboModules.
  [_bridgeModuleDecorator.moduleRegistry setTurboModuleRegistry:_turboModuleManager];

  ABI50_0_0RCTLogSetBridgelessModuleRegistry(_bridgeModuleDecorator.moduleRegistry);
  ABI50_0_0RCTLogSetBridgelessCallableJSModules(_bridgeModuleDecorator.callableJSModules);

  auto contextContainer = std::make_shared<ContextContainer>();
  [_delegate didCreateContextContainer:contextContainer];

  contextContainer->insert(
      "ABI50_0_0RCTImageLoader", ABI50_0_0facebook::ABI50_0_0React::wrapManagedObject([_turboModuleManager moduleForName:"ABI50_0_0RCTImageLoader"]));
  contextContainer->insert(
      "ABI50_0_0RCTEventDispatcher",
      ABI50_0_0facebook::ABI50_0_0React::wrapManagedObject([_turboModuleManager moduleForName:"ABI50_0_0RCTEventDispatcher"]));
  contextContainer->insert("ABI50_0_0RCTBridgeModuleDecorator", ABI50_0_0facebook::ABI50_0_0React::wrapManagedObject(_bridgeModuleDecorator));
  contextContainer->insert("RuntimeScheduler", std::weak_ptr<RuntimeScheduler>(_ABI50_0_0ReactInstance->getRuntimeScheduler()));
  contextContainer->insert("ABI50_0_0RCTBridgeProxy", ABI50_0_0facebook::ABI50_0_0React::wrapManagedObject(bridgeProxy));

  _surfacePresenter = [[ABI50_0_0RCTSurfacePresenter alloc]
        initWithContextContainer:contextContainer
                 runtimeExecutor:bufferedRuntimeExecutor
      bridgelessBindingsExecutor:std::optional(_ABI50_0_0ReactInstance->getUnbufferedRuntimeExecutor())];

  // This enables ABI50_0_0RCTViewRegistry in modules to return UIViews from its viewForABI50_0_0ReactTag method
  __weak ABI50_0_0RCTSurfacePresenter *weakSurfacePresenter = _surfacePresenter;
  [_bridgeModuleDecorator.viewRegistry_DEPRECATED setBridgelessComponentViewProvider:^UIView *(NSNumber *ABI50_0_0ReactTag) {
    ABI50_0_0RCTSurfacePresenter *strongSurfacePresenter = weakSurfacePresenter;
    if (strongSurfacePresenter == nil) {
      return nil;
    }

    return [strongSurfacePresenter findComponentViewWithTag_DO_NOT_USE_DEPRECATED:ABI50_0_0ReactTag.integerValue];
  }];

  // DisplayLink is used to call timer callbacks.
  _displayLink = [ABI50_0_0RCTDisplayLink new];

  ABI50_0_0ReactInstance::JSRuntimeFlags options = {
      .isProfiling = false, .runtimeDiagnosticFlags = [ABI50_0_0RCTInstanceRuntimeDiagnosticFlags() UTF8String]};
  _ABI50_0_0ReactInstance->initializeRuntime(options, [=](jsi::Runtime &runtime) {
    __strong __typeof(self) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }

    [strongSelf->_turboModuleManager installJSBindings:runtime];
    ABI50_0_0facebook::ABI50_0_0React::bindNativeLogger(runtime, [](const std::string &message, unsigned int logLevel) {
      _ABI50_0_0RCTLogJavaScriptInternal(static_cast<ABI50_0_0RCTLogLevel>(logLevel), [NSString stringWithUTF8String:message.c_str()]);
    });
    ABI50_0_0RCTInstallNativeComponentRegistryBinding(runtime);

    if (ABI50_0_0RCTGetUseNativeViewConfigsInBridgelessMode()) {
      installLegacyUIManagerConstantsProviderBinding(runtime);
    }

    [strongSelf->_delegate instance:strongSelf didInitializeRuntime:runtime];

    // Set up Display Link
    ABI50_0_0RCTModuleData *timingModuleData = [[ABI50_0_0RCTModuleData alloc] initWithModuleInstance:timing
                                                                             bridge:nil
                                                                     moduleRegistry:nil
                                                            viewRegistry_DEPRECATED:nil
                                                                      bundleManager:nil
                                                                  callableJSModules:nil];
    [strongSelf->_displayLink registerModuleForFrameUpdates:timing withModuleData:timingModuleData];
    [strongSelf->_displayLink addToRunLoop:[NSRunLoop currentRunLoop]];

    // Attempt to load bundle synchronously, fallback to asynchronously.
    [strongSelf->_performanceLogger markStartForTag:ABI50_0_0RCTPLScriptDownload];
    [strongSelf _loadJSBundle:[strongSelf->_bridgeModuleDecorator.bundleManager bundleURL]];
  });

  [_performanceLogger markStopForTag:ABI50_0_0RCTPLABI50_0_0ReactInstanceInit];
}

- (void)_attachBridgelessAPIsToModule:(id<ABI50_0_0RCTTurboModule>)module
{
  __weak ABI50_0_0RCTInstance *weakSelf = self;
  if ([module respondsToSelector:@selector(setDispatchToJSThread:)]) {
    ((id<ABI50_0_0RCTJSDispatcherModule>)module).dispatchToJSThread = ^(dispatch_block_t block) {
      __strong __typeof(self) strongSelf = weakSelf;

      if (strongSelf && strongSelf->_valid) {
        strongSelf->_ABI50_0_0ReactInstance->getBufferedRuntimeExecutor()([=](jsi::Runtime &runtime) { block(); });
      }
    };
  }

  if ([module respondsToSelector:@selector(setSurfacePresenter:)]) {
    [module performSelector:@selector(setSurfacePresenter:) withObject:_surfacePresenter];
  }

  // Replaces bridge.isInspectable
  if ([module respondsToSelector:@selector(setIsInspectable:)]) {
#if ABI50_0_0RCT_DEV_MENU
    if (_valid) {
      _ABI50_0_0ReactInstance->getBufferedRuntimeExecutor()([module](jsi::Runtime &runtime) {
        ((id<ABI50_0_0RCTDevSettingsInspectable>)module).isInspectable = runtime.isInspectable();
      });
    }
#endif
  }
}

- (void)_loadJSBundle:(NSURL *)sourceURL
{
#if ABI50_0_0RCT_DEV_MENU && __has_include(<ABI50_0_0React/ABI50_0_0RCTDevLoadingViewProtocol.h>)
  {
    id<ABI50_0_0RCTDevLoadingViewProtocol> loadingView =
        (id<ABI50_0_0RCTDevLoadingViewProtocol>)[_turboModuleManager moduleForName:"DevLoadingView"];
    [loadingView showWithURL:sourceURL];
  }
#endif

  __weak __typeof(self) weakSelf = self;
  [ABI50_0_0RCTJavaScriptLoader loadBundleAtURL:sourceURL
      onProgress:^(ABI50_0_0RCTLoadingProgress *progressData) {
        __typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
          return;
        }

#if ABI50_0_0RCT_DEV_MENU && __has_include(<ABI50_0_0React/ABI50_0_0RCTDevLoadingViewProtocol.h>)
        id<ABI50_0_0RCTDevLoadingViewProtocol> loadingView =
            (id<ABI50_0_0RCTDevLoadingViewProtocol>)[strongSelf->_turboModuleManager moduleForName:"DevLoadingView"];
        [loadingView updateProgress:progressData];
#endif
      }
      onComplete:^(NSError *error, ABI50_0_0RCTSource *source) {
        __typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
          return;
        }

        if (error) {
          // TODO(T91461138): Properly address bundle loading errors.
          ABI50_0_0RCTLogError(@"ABI50_0_0RCTInstance: Error while loading bundle: %@", error);
          [strongSelf invalidate];
          return;
        }
        // DevSettings module is needed by _loadScriptFromSource's callback so prior initialization is required
        ABI50_0_0RCTDevSettings *const devSettings =
            (ABI50_0_0RCTDevSettings *)[strongSelf->_turboModuleManager moduleForName:"DevSettings"];
        [strongSelf _loadScriptFromSource:source];
        // Set up hot module reloading in Dev only.
        [strongSelf->_performanceLogger markStopForTag:ABI50_0_0RCTPLScriptDownload];
        [devSettings setupHMRClientWithBundleURL:sourceURL];
      }];
}

- (void)_loadScriptFromSource:(ABI50_0_0RCTSource *)source
{
  std::lock_guard<std::mutex> lock(_invalidationMutex);
  if (!_valid) {
    return;
  }

  auto script = std::make_unique<NSDataBigString>(source.data);
  const auto *url = deriveSourceURL(source.url).UTF8String;
  _ABI50_0_0ReactInstance->loadScript(std::move(script), url);
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ABI50_0_0RCTInstanceDidLoadBundle" object:nil];

  if (_onInitialBundleLoad) {
    _onInitialBundleLoad();
    _onInitialBundleLoad = nil;
  }
}

- (void)_notifyEventDispatcherObserversOfEvent_DEPRECATED:(NSNotification *)notification
{
  NSDictionary *userInfo = notification.userInfo;
  id<ABI50_0_0RCTEvent> event = [userInfo objectForKey:@"event"];

  ABI50_0_0RCTModuleRegistry *moduleRegistry = _bridgeModuleDecorator.moduleRegistry;
  if (event && moduleRegistry) {
    id<ABI50_0_0RCTEventDispatcherProtocol> legacyEventDispatcher = [moduleRegistry moduleForName:"EventDispatcher"
                                                                   lazilyLoadIfNecessary:YES];
    [legacyEventDispatcher notifyObserversOfEvent:event];
  }
}

- (void)_handleJSErrorMap:(ABI50_0_0facebook::ABI50_0_0React::MapBuffer)errorMap
{
  NSString *message = [NSString stringWithCString:errorMap.getString(JSErrorHandlerKey::kErrorMessage).c_str()
                                         encoding:[NSString defaultCStringEncoding]];
  std::vector<ABI50_0_0facebook::ABI50_0_0React::MapBuffer> frames = errorMap.getMapBufferList(JSErrorHandlerKey::kAllStackFrames);
  NSMutableArray<NSDictionary<NSString *, id> *> *stack = [NSMutableArray new];
  for (const ABI50_0_0facebook::ABI50_0_0React::MapBuffer &mapBuffer : frames) {
    NSDictionary *frame = @{
      @"file" : [NSString stringWithCString:mapBuffer.getString(JSErrorHandlerKey::kFrameFileName).c_str()
                                   encoding:[NSString defaultCStringEncoding]],
      @"methodName" : [NSString stringWithCString:mapBuffer.getString(JSErrorHandlerKey::kFrameMethodName).c_str()
                                         encoding:[NSString defaultCStringEncoding]],
      @"lineNumber" : [NSNumber numberWithInt:mapBuffer.getInt(JSErrorHandlerKey::kFrameLineNumber)],
      @"column" : [NSNumber numberWithInt:mapBuffer.getInt(JSErrorHandlerKey::kFrameColumnNumber)],
    };
    [stack addObject:frame];
  }
  [_delegate instance:self
      didReceiveJSErrorStack:stack
                     message:message
                 exceptionId:errorMap.getInt(JSErrorHandlerKey::kExceptionId)
                     isFatal:errorMap.getBool(JSErrorHandlerKey::kIsFatal)];
}

@end
