#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTFabricSurface.h>
#import <ABI50_0_0React/ABI50_0_0RCTScheduler.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurface.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfacePresenter.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfacePresenterBridgeAdapter.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfaceView.h>
#if ABI50_0_0REACT_NATIVE_MINOR_VERSION < 73
#import <ABI50_0_0React/ABI50_0_0RCTRuntimeExecutorFromBridge.h>
#endif
#endif

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0RNReanimated/ABI50_0_0REAInitializerRCTFabricSurface.h>
#endif

#import <ABI50_0_0RNReanimated/NativeProxy.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAModule.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REANodesManager.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAUIKit.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0RNRuntimeDecorator.h>
#import <ABI50_0_0RNReanimated/ReanimatedJSIUtils.h>
#import <ABI50_0_0RNReanimated/SingleInstanceChecker.h>
#import <ABI50_0_0RNReanimated/WorkletRuntime.h>
#import <ABI50_0_0RNReanimated/WorkletRuntimeCollector.h>

#if __has_include(<UIKit/UIAccessibility.h>)
#import <UIKit/UIAccessibility.h>
#endif

using namespace ABI50_0_0facebook::ABI50_0_0React;
using namespace ABI50_0_0reanimated;

@interface ABI50_0_0RCTBridge (JSIRuntime)
- (void *)runtime;
@end

@interface ABI50_0_0RCTBridge (ABI50_0_0RCTTurboModule)
- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker>)jsCallInvoker;
- (void)_tryAndHandleError:(dispatch_block_t)block;
@end

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
static __strong ABI50_0_0REAInitializerRCTFabricSurface *reaSurface;
#else
typedef void (^AnimatedOperation)(ABI50_0_0REANodesManager *nodesManager);
#endif

@implementation ABI50_0_0REAModule {
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  __weak ABI50_0_0RCTSurfacePresenter *_surfacePresenter;
  std::weak_ptr<NativeReanimatedModule> weakNativeReanimatedModule_;
#else
  NSMutableArray<AnimatedOperation> *_operations;
#endif
#ifndef NDEBUG
  SingleInstanceChecker<ABI50_0_0REAModule> singleInstanceChecker_;
#endif
  bool hasListeners;
}

ABI50_0_0RCT_EXPORT_MODULE(ReanimatedModule);

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
+ (BOOL)requiresMainQueueSetup
{
  return YES;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

- (void)invalidate
{
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
  [_nodesManager invalidate];
  [super invalidate];
}

- (dispatch_queue_t)methodQueue
{
  // This module needs to be on the same queue as the UIManager to avoid
  // having to lock `_operations` and `_preOperations` since `uiManagerWillPerformMounting`
  // will be called from that queue.
  return ABI50_0_0RCTGetUIManagerQueue();
}

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED

- (std::shared_ptr<UIManager>)getUIManager
{
  ABI50_0_0RCTScheduler *scheduler = [_surfacePresenter scheduler];
  return scheduler.uiManager;
}

- (void)injectDependencies:(jsi::Runtime &)runtime
{
  const auto &uiManager = [self getUIManager];
  react_native_assert(uiManager.get() != nil);
  if (auto nativeReanimatedModule = weakNativeReanimatedModule_.lock()) {
    nativeReanimatedModule->initializeFabric(uiManager);
  }
}

#pragma mark-- Initialize

- (void)installReanimatedAfterReload
{
  // called from ABI50_0_0REAInitializerRCTFabricSurface::start
  __weak __typeof__(self) weakSelf = self;
  _surfacePresenter = self.bridge.surfacePresenter;
  [_nodesManager setSurfacePresenter:_surfacePresenter];

  // to avoid deadlock we can't use Executor from ABI50_0_0React Native
  // but we can create own and use it because initialization is already synchronized
  react_native_assert(self.bridge != nil);
  ABI50_0_0RCTRuntimeExecutorFromBridge(self.bridge)(^(jsi::Runtime &runtime) {
    if (__typeof__(self) strongSelf = weakSelf) {
      [strongSelf injectDependencies:runtime];
    }
  });
}

- (void)handleJavaScriptDidLoadNotification:(NSNotification *)notification
{
  _surfacePresenter = self.bridge.surfacePresenter;
  ABI50_0_0RCTScheduler *scheduler = [_surfacePresenter scheduler];
  __weak __typeof__(self) weakSelf = self;
  _surfacePresenter.runtimeExecutor(^(jsi::Runtime &runtime) {
    __typeof__(self) strongSelf = weakSelf;
    if (strongSelf == nil) {
      return;
    }
    if (auto nativeReanimatedModule = strongSelf->weakNativeReanimatedModule_.lock()) {
      auto eventListener =
          std::make_shared<ABI50_0_0facebook::ABI50_0_0React::EventListener>([nativeReanimatedModule](const RawEvent &rawEvent) {
            if (!ABI50_0_0RCTIsMainQueue()) {
              // event listener called on the JS thread, let's ignore this event
              // as we cannot safely access worklet runtime here
              // and also we don't care about topLayout events
              return false;
            }
            return nativeReanimatedModule->handleRawEvent(rawEvent, CACurrentMediaTime() * 1000);
          });
      [scheduler addEventListener:eventListener];
    }
  });
}

- (void)setBridge:(ABI50_0_0RCTBridge *)bridge
{
  [super setBridge:bridge];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleJavaScriptDidLoadNotification:)
                                               name:ABI50_0_0RCTJavaScriptDidLoadNotification
                                             object:nil];

  [[self.moduleRegistry moduleForName:"EventDispatcher"] addDispatchObserver:self];
  [bridge.uiManager.observerCoordinator addObserver:self];

  // only within the first loading `self.bridge.surfacePresenter` exists
  // during the reload `self.bridge.surfacePresenter` is null
  _surfacePresenter = self.bridge.surfacePresenter;
#ifndef NDEBUG
  if (reaSurface == nil) {
    // we need only one instance because SurfacePresenter is the same during the application lifetime
    reaSurface = [[ABI50_0_0REAInitializerRCTFabricSurface alloc] init];
    [_surfacePresenter registerSurface:reaSurface];
  }
  reaSurface.reaModule = self;
#endif

  if (_surfacePresenter == nil) {
    // _surfacePresenter will be set in installReanimatedAfterReload
    _nodesManager = [[ABI50_0_0REANodesManager alloc] initWithModule:self bridge:self.bridge surfacePresenter:nil];
    return;
  }

  _nodesManager = [[ABI50_0_0REANodesManager alloc] initWithModule:self bridge:self.bridge surfacePresenter:_surfacePresenter];
}

#else

- (void)setBridge:(ABI50_0_0RCTBridge *)bridge
{
  [super setBridge:bridge];

  _nodesManager = [[ABI50_0_0REANodesManager alloc] initWithModule:self uiManager:self.bridge.uiManager];
  _operations = [NSMutableArray new];

  [bridge.uiManager.observerCoordinator addObserver:self];
  _animationsManager = [[ABI50_0_0REAAnimationsManager alloc] initWithUIManager:bridge.uiManager];
}

#pragma mark-- Batch handling

- (void)addOperationBlock:(AnimatedOperation)operation
{
  [_operations addObject:operation];
}

#pragma mark - ABI50_0_0RCTUIManagerObserver

- (void)uiManagerWillPerformMounting:(ABI50_0_0RCTUIManager *)uiManager
{
  [_nodesManager maybeFlushUpdateBuffer];
  if (_operations.count == 0) {
    return;
  }

  NSArray<AnimatedOperation> *operations = _operations;
  _operations = [NSMutableArray new];

  ABI50_0_0REANodesManager *nodesManager = _nodesManager;

  [uiManager
      addUIBlock:^(__unused ABI50_0_0RCTUIManager *manager, __unused NSDictionary<NSNumber *, ABI50_0_0REAUIView *> *viewRegistry) {
        for (AnimatedOperation operation in operations) {
          operation(nodesManager);
        }
        [nodesManager operationsBatchDidComplete];
      }];
}

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

#pragma mark-- Events

- (NSArray<NSString *> *)supportedEvents
{
  return @[ @"onReanimatedCall", @"onReanimatedPropsChange" ];
}

- (void)eventDispatcherWillDispatchEvent:(id<ABI50_0_0RCTEvent>)event
{
  // Events can be dispatched from any queue
  [_nodesManager dispatchEvent:event];
}

- (void)startObserving
{
  hasListeners = YES;
}

- (void)stopObserving
{
  hasListeners = NO;
}

- (void)sendEventWithName:(NSString *)eventName body:(id)body
{
  if (hasListeners) {
    [super sendEventWithName:eventName body:body];
  }
}

ABI50_0_0RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(installTurboModule)
{
  ABI50_0_0facebook::jsi::Runtime *jsiRuntime = [self.bridge respondsToSelector:@selector(runtime)]
      ? reinterpret_cast<ABI50_0_0facebook::jsi::Runtime *>(self.bridge.runtime)
      : nullptr;

  if (jsiRuntime) {
    auto nativeReanimatedModule = ABI50_0_0reanimated::createReanimatedModule(self.bridge, self.bridge.jsCallInvoker);

    jsi::Runtime &rnRuntime = *jsiRuntime;
    WorkletRuntimeCollector::install(rnRuntime);

#if __has_include(<UIKit/UIAccessibility.h>)
    auto isReducedMotion = UIAccessibilityIsReduceMotionEnabled();
#else
    auto isReducedMotion = NSWorkspace.sharedWorkspace.accessibilityDisplayShouldReduceMotion;
#endif

    ABI50_0_0RNRuntimeDecorator::decorate(rnRuntime, nativeReanimatedModule, isReducedMotion);

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
    weakNativeReanimatedModule_ = nativeReanimatedModule;
    if (_surfacePresenter != nil) {
      // reload, uiManager is null right now, we need to wait for `installReanimatedAfterReload`
      [self injectDependencies:rnRuntime];
    }
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
  }

  return nil;
}

@end
