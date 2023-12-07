/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTSurfacePresenter.h"

#import <mutex>
#import <shared_mutex>

#import <ABI50_0_0React/ABI50_0_0RCTAssert.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponentViewFactory.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponentViewRegistry.h>
#import <ABI50_0_0React/ABI50_0_0RCTConstants.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricSurface.h>
#import "ABI50_0_0RCTFollyConvert.h"
#import <ABI50_0_0React/ABI50_0_0RCTI18nUtil.h>
#import <ABI50_0_0React/ABI50_0_0RCTMountingManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTMountingManagerDelegate.h>
#import <ABI50_0_0React/ABI50_0_0RCTScheduler.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfaceRegistry.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfaceView+Internal.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfaceView.h>
#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>

#import <ABI50_0_0React/config/ABI50_0_0ReactNativeConfig.h>
#import <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorFactory.h>
#import <ABI50_0_0React/renderer/components/text/ABI50_0_0BaseTextProps.h>
#import <ABI50_0_0React/renderer/runtimescheduler/ABI50_0_0RuntimeScheduler.h>
#import <ABI50_0_0React/renderer/scheduler/ABI50_0_0AsynchronousEventBeat.h>
#import <ABI50_0_0React/renderer/scheduler/ABI50_0_0SchedulerToolbox.h>
#import <ABI50_0_0React/renderer/scheduler/ABI50_0_0SynchronousEventBeat.h>
#import <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>
#import <ABI50_0_0React/utils/ABI50_0_0CoreFeatures.h>
#import <ABI50_0_0React/utils/ABI50_0_0ManagedObjectWrapper.h>

#import "ABI50_0_0PlatformRunLoopObserver.h"
#import "ABI50_0_0RCTConversions.h"

using namespace ABI50_0_0facebook;
using namespace ABI50_0_0facebook::ABI50_0_0React;

static dispatch_queue_t ABI50_0_0RCTGetBackgroundQueue()
{
  static dispatch_queue_t queue;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dispatch_queue_attr_t attr =
        dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE, 0);
    queue = dispatch_queue_create("com.facebook.ABI50_0_0React.background", attr);
  });
  return queue;
}

static BackgroundExecutor ABI50_0_0RCTGetBackgroundExecutor()
{
  return [](std::function<void()> &&callback) {
    if (ABI50_0_0RCTIsMainQueue()) {
      callback();
      return;
    }

    auto copyableCallback = callback;
    dispatch_async(ABI50_0_0RCTGetBackgroundQueue(), ^{
      copyableCallback();
    });
  };
}

@interface ABI50_0_0RCTSurfacePresenter () <ABI50_0_0RCTSchedulerDelegate, ABI50_0_0RCTMountingManagerDelegate>
@end

@implementation ABI50_0_0RCTSurfacePresenter {
  ABI50_0_0RCTMountingManager *_mountingManager; // Thread-safe.
  ABI50_0_0RCTSurfaceRegistry *_surfaceRegistry; // Thread-safe.

  std::mutex _schedulerAccessMutex;
  std::mutex _schedulerLifeCycleMutex;
  ABI50_0_0RCTScheduler *_Nullable _scheduler; // Thread-safe. Pointer is protected by `_schedulerAccessMutex`.
  ContextContainer::Shared _contextContainer; // Protected by `_schedulerLifeCycleMutex`.
  RuntimeExecutor _runtimeExecutor; // Protected by `_schedulerLifeCycleMutex`.
  std::optional<RuntimeExecutor> _bridgelessBindingsExecutor; // Only used for installing bindings.

  std::shared_mutex _observerListMutex;
  std::vector<__weak id<ABI50_0_0RCTSurfacePresenterObserver>> _observers; // Protected by `_observerListMutex`.
}

- (instancetype)initWithContextContainer:(ContextContainer::Shared)contextContainer
                         runtimeExecutor:(RuntimeExecutor)runtimeExecutor
              bridgelessBindingsExecutor:(std::optional<RuntimeExecutor>)bridgelessBindingsExecutor
{
  if (self = [super init]) {
    assert(contextContainer && "RuntimeExecutor must be not null.");
    _runtimeExecutor = runtimeExecutor;
    _bridgelessBindingsExecutor = bridgelessBindingsExecutor;
    _contextContainer = contextContainer;

    _surfaceRegistry = [ABI50_0_0RCTSurfaceRegistry new];
    _mountingManager = [ABI50_0_0RCTMountingManager new];
    _mountingManager.contextContainer = contextContainer;
    _mountingManager.delegate = self;

    _scheduler = [self _createScheduler];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_applicationWillTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
  }

  return self;
}

- (ABI50_0_0RCTMountingManager *)mountingManager
{
  return _mountingManager;
}

- (ABI50_0_0RCTScheduler *_Nullable)scheduler
{
  std::lock_guard<std::mutex> lock(_schedulerAccessMutex);
  return _scheduler;
}

- (ContextContainer::Shared)contextContainer
{
  std::lock_guard<std::mutex> lock(_schedulerLifeCycleMutex);
  return _contextContainer;
}

- (void)setRuntimeExecutor:(RuntimeExecutor)runtimeExecutor
{
  std::lock_guard<std::mutex> lock(_schedulerLifeCycleMutex);
  _runtimeExecutor = runtimeExecutor;
}

#pragma mark - Internal Surface-dedicated Interface

- (void)registerSurface:(ABI50_0_0RCTFabricSurface *)surface
{
  [_surfaceRegistry registerSurface:surface];
  ABI50_0_0RCTScheduler *scheduler = [self scheduler];
  if (scheduler) {
    [scheduler registerSurface:surface.surfaceHandler];
  }
}

- (void)unregisterSurface:(ABI50_0_0RCTFabricSurface *)surface
{
  ABI50_0_0RCTScheduler *scheduler = [self scheduler];
  if (scheduler) {
    [scheduler unregisterSurface:surface.surfaceHandler];
  }
  [_surfaceRegistry unregisterSurface:surface];
}

- (ABI50_0_0RCTFabricSurface *)surfaceForRootTag:(ABI50_0_0ReactTag)rootTag
{
  return [_surfaceRegistry surfaceForRootTag:rootTag];
}

- (id<ABI50_0_0RCTSurfaceProtocol>)createFabricSurfaceForModuleName:(NSString *)moduleName
                                         initialProperties:(NSDictionary *)initialProperties
{
  return [[ABI50_0_0RCTFabricSurface alloc] initWithSurfacePresenter:self
                                                 moduleName:moduleName
                                          initialProperties:initialProperties];
}

- (UIView *)findComponentViewWithTag_DO_NOT_USE_DEPRECATED:(NSInteger)tag
{
  UIView<ABI50_0_0RCTComponentViewProtocol> *componentView =
      [_mountingManager.componentViewRegistry findComponentViewWithTag:tag];
  return componentView;
}

- (BOOL)synchronouslyUpdateViewOnUIThread:(NSNumber *)reactTag props:(NSDictionary *)props
{
  ABI50_0_0RCTScheduler *scheduler = [self scheduler];
  if (!scheduler) {
    return NO;
  }

  ABI50_0_0ReactTag tag = [reactTag integerValue];
  UIView<ABI50_0_0RCTComponentViewProtocol> *componentView =
      [_mountingManager.componentViewRegistry findComponentViewWithTag:tag];
  if (componentView == nil) {
    return NO; // This view probably isn't managed by Fabric
  }
  ComponentHandle handle = [[componentView class] componentDescriptorProvider].handle;
  auto *componentDescriptor = [scheduler findComponentDescriptorByHandle_DO_NOT_USE_THIS_IS_BROKEN:handle];

  if (!componentDescriptor) {
    return YES;
  }

  [_mountingManager synchronouslyUpdateViewOnUIThread:tag changedProps:props componentDescriptor:*componentDescriptor];
  return YES;
}

- (void)setupAnimationDriverWithSurfaceHandler:(const ABI50_0_0facebook::ABI50_0_0React::SurfaceHandler &)surfaceHandler
{
  [[self scheduler] setupAnimationDriver:surfaceHandler];
}

- (BOOL)suspend
{
  std::lock_guard<std::mutex> lock(_schedulerLifeCycleMutex);

  ABI50_0_0RCTScheduler *scheduler;
  {
    std::lock_guard<std::mutex> accessLock(_schedulerAccessMutex);

    if (!_scheduler) {
      return NO;
    }
    scheduler = _scheduler;
    _scheduler = nil;
  }

  [self _stopAllSurfacesWithScheduler:scheduler];

  return YES;
}

- (BOOL)resume
{
  std::lock_guard<std::mutex> lock(_schedulerLifeCycleMutex);

  ABI50_0_0RCTScheduler *scheduler;
  {
    std::lock_guard<std::mutex> accessLock(_schedulerAccessMutex);

    if (_scheduler) {
      return NO;
    }
    scheduler = [self _createScheduler];
  }

  [self _startAllSurfacesWithScheduler:scheduler];

  {
    std::lock_guard<std::mutex> accessLock(_schedulerAccessMutex);
    _scheduler = scheduler;
  }

  return YES;
}

#pragma mark - Private

- (ABI50_0_0RCTScheduler *)_createScheduler
{
  auto reactNativeConfig = _contextContainer->at<std::shared_ptr<const ABI50_0_0ReactNativeConfig>>("ABI50_0_0ReactNativeConfig");

  if (reactNativeConfig && reactNativeConfig->getBool("rn_convergence:dispatch_pointer_events")) {
    ABI50_0_0RCTSetDispatchW3CPointerEvents(YES);
  }

  if (reactNativeConfig && reactNativeConfig->getBool("ABI50_0_0React_fabric:enable_cpp_props_iterator_setter_ios")) {
    CoreFeatures::enablePropIteratorSetter = true;
  }

  if (reactNativeConfig && reactNativeConfig->getBool("ABI50_0_0React_fabric:use_native_state")) {
    CoreFeatures::useNativeState = true;
  }

  if (reactNativeConfig && reactNativeConfig->getBool("ABI50_0_0React_fabric:cancel_image_downloads_on_recycle")) {
    CoreFeatures::cancelImageDownloadsOnRecycle = true;
  }

  if (reactNativeConfig && reactNativeConfig->getBool("ABI50_0_0React_fabric:enable_granular_scroll_view_state_updates_ios")) {
    CoreFeatures::enableGranularScrollViewStateUpdatesIOS = true;
  }

  if (reactNativeConfig && reactNativeConfig->getBool("ABI50_0_0React_fabric:enable_mount_hooks_ios")) {
    CoreFeatures::enableMountHooks = true;
  }

  if (reactNativeConfig && reactNativeConfig->getBool("ABI50_0_0React_fabric:disable_scroll_event_throttle_requirement")) {
    CoreFeatures::disableScrollEventThrottleRequirement = true;
  }

  if (reactNativeConfig && reactNativeConfig->getBool("ABI50_0_0React_fabric:enable_default_async_batched_priority")) {
    CoreFeatures::enableDefaultAsyncBatchedPriority = true;
  }

  if (reactNativeConfig && reactNativeConfig->getBool("ABI50_0_0React_fabric:enable_cloneless_state_progression")) {
    CoreFeatures::enableClonelessStateProgression = true;
  }

  auto componentRegistryFactory =
      [factory = wrapManagedObject(_mountingManager.componentViewRegistry.componentViewFactory)](
          const EventDispatcher::Weak &eventDispatcher, const ContextContainer::Shared &contextContainer) {
        return [(ABI50_0_0RCTComponentViewFactory *)unwrapManagedObject(factory)
            createComponentDescriptorRegistryWithParameters:{eventDispatcher, contextContainer}];
      };

  auto runtimeExecutor = _runtimeExecutor;

  auto toolbox = SchedulerToolbox{};
  toolbox.contextContainer = _contextContainer;
  toolbox.componentRegistryFactory = componentRegistryFactory;

  auto weakRuntimeScheduler = _contextContainer->find<std::weak_ptr<RuntimeScheduler>>("RuntimeScheduler");
  auto runtimeScheduler = weakRuntimeScheduler.has_value() ? weakRuntimeScheduler.value().lock() : nullptr;
  if (runtimeScheduler) {
    runtimeExecutor = [runtimeScheduler](std::function<void(jsi::Runtime & runtime)> &&callback) {
      runtimeScheduler->scheduleWork(std::move(callback));
    };
  }

  toolbox.runtimeExecutor = runtimeExecutor;
  toolbox.bridgelessBindingsExecutor = _bridgelessBindingsExecutor;

  toolbox.mainRunLoopObserverFactory = [](RunLoopObserver::Activity activities,
                                          const RunLoopObserver::WeakOwner &owner) {
    return std::make_unique<MainRunLoopObserver>(activities, owner);
  };

  if (reactNativeConfig && reactNativeConfig->getBool("ABI50_0_0React_fabric:enable_background_executor_ios")) {
    toolbox.backgroundExecutor = ABI50_0_0RCTGetBackgroundExecutor();
  }

  toolbox.synchronousEventBeatFactory =
      [runtimeExecutor, runtimeScheduler = runtimeScheduler](const EventBeat::SharedOwnerBox &ownerBox) {
        auto runLoopObserver =
            std::make_unique<MainRunLoopObserver const>(RunLoopObserver::Activity::BeforeWaiting, ownerBox->owner);
        return std::make_unique<SynchronousEventBeat>(std::move(runLoopObserver), runtimeExecutor, runtimeScheduler);
      };

  toolbox.asynchronousEventBeatFactory =
      [runtimeExecutor](const EventBeat::SharedOwnerBox &ownerBox) -> std::unique_ptr<EventBeat> {
    auto runLoopObserver =
        std::make_unique<MainRunLoopObserver const>(RunLoopObserver::Activity::BeforeWaiting, ownerBox->owner);
    return std::make_unique<AsynchronousEventBeat>(std::move(runLoopObserver), runtimeExecutor);
  };

  ABI50_0_0RCTScheduler *scheduler = [[ABI50_0_0RCTScheduler alloc] initWithToolbox:toolbox];
  scheduler.delegate = self;

  return scheduler;
}

- (void)_startAllSurfacesWithScheduler:(ABI50_0_0RCTScheduler *)scheduler
{
  [_surfaceRegistry enumerateWithBlock:^(NSEnumerator<ABI50_0_0RCTFabricSurface *> *enumerator) {
    for (ABI50_0_0RCTFabricSurface *surface in enumerator) {
      [scheduler registerSurface:surface.surfaceHandler];
      [surface start];
    }
  }];
}

- (void)_stopAllSurfacesWithScheduler:(ABI50_0_0RCTScheduler *)scheduler
{
  [_surfaceRegistry enumerateWithBlock:^(NSEnumerator<ABI50_0_0RCTFabricSurface *> *enumerator) {
    for (ABI50_0_0RCTFabricSurface *surface in enumerator) {
      [surface stop];
      [scheduler unregisterSurface:surface.surfaceHandler];
    }
  }];
}

- (void)_applicationWillTerminate
{
  [self suspend];
}

#pragma mark - ABI50_0_0RCTSchedulerDelegate

- (void)schedulerDidFinishTransaction:(MountingCoordinator::Shared)mountingCoordinator
{
  [_mountingManager scheduleTransaction:mountingCoordinator];
}

- (void)schedulerDidDispatchCommand:(const ShadowView &)shadowView
                        commandName:(const std::string &)commandName
                               args:(const folly::dynamic &)args
{
  ABI50_0_0ReactTag tag = shadowView.tag;
  NSString *commandStr = [[NSString alloc] initWithUTF8String:commandName.c_str()];
  NSArray *argsArray = convertFollyDynamicToId(args);

  [_mountingManager dispatchCommand:tag commandName:commandStr args:argsArray];
}

- (void)schedulerDidSendAccessibilityEvent:(const ABI50_0_0facebook::ABI50_0_0React::ShadowView &)shadowView
                                 eventType:(const std::string &)eventType
{
  ABI50_0_0ReactTag tag = shadowView.tag;
  NSString *eventTypeStr = [[NSString alloc] initWithUTF8String:eventType.c_str()];

  [_mountingManager sendAccessibilityEvent:tag eventType:eventTypeStr];
}

- (void)schedulerDidSetIsJSResponder:(BOOL)isJSResponder
                blockNativeResponder:(BOOL)blockNativeResponder
                       forShadowView:(const ABI50_0_0facebook::ABI50_0_0React::ShadowView &)shadowView;
{
  [_mountingManager setIsJSResponder:isJSResponder blockNativeResponder:blockNativeResponder forShadowView:shadowView];
}

- (void)addObserver:(id<ABI50_0_0RCTSurfacePresenterObserver>)observer
{
  std::unique_lock lock(_observerListMutex);
  _observers.push_back(observer);
}

- (void)removeObserver:(id<ABI50_0_0RCTSurfacePresenterObserver>)observer
{
  std::unique_lock lock(_observerListMutex);
  std::vector<__weak id<ABI50_0_0RCTSurfacePresenterObserver>>::const_iterator it =
      std::find(_observers.begin(), _observers.end(), observer);
  if (it != _observers.end()) {
    _observers.erase(it);
  }
}

#pragma mark - ABI50_0_0RCTMountingManagerDelegate

- (void)mountingManager:(ABI50_0_0RCTMountingManager *)mountingManager willMountComponentsWithRootTag:(ABI50_0_0ReactTag)rootTag
{
  ABI50_0_0RCTAssertMainQueue();

  NSArray<id<ABI50_0_0RCTSurfacePresenterObserver>> *observersCopy;
  {
    std::shared_lock lock(_observerListMutex);
    observersCopy = [self _getObservers];
  }

  for (id<ABI50_0_0RCTSurfacePresenterObserver> observer in observersCopy) {
    if ([observer respondsToSelector:@selector(willMountComponentsWithRootTag:)]) {
      [observer willMountComponentsWithRootTag:rootTag];
    }
  }
}

- (void)mountingManager:(ABI50_0_0RCTMountingManager *)mountingManager didMountComponentsWithRootTag:(ABI50_0_0ReactTag)rootTag
{
  ABI50_0_0RCTAssertMainQueue();

  NSArray<id<ABI50_0_0RCTSurfacePresenterObserver>> *observersCopy;
  {
    std::shared_lock lock(_observerListMutex);
    observersCopy = [self _getObservers];
  }

  for (id<ABI50_0_0RCTSurfacePresenterObserver> observer in observersCopy) {
    if ([observer respondsToSelector:@selector(didMountComponentsWithRootTag:)]) {
      [observer didMountComponentsWithRootTag:rootTag];
    }
  }

  ABI50_0_0RCTScheduler *scheduler = [self scheduler];
  if (scheduler) {
    // Notify mount when the effects are visible and prevent mount hooks to
    // delay paint.
    dispatch_async(dispatch_get_main_queue(), ^{
      [scheduler reportMount:rootTag];
    });
  }
}

- (NSArray<id<ABI50_0_0RCTSurfacePresenterObserver>> *)_getObservers
{
  NSMutableArray<id<ABI50_0_0RCTSurfacePresenterObserver>> *observersCopy = [NSMutableArray new];
  for (id<ABI50_0_0RCTSurfacePresenterObserver> observer : _observers) {
    if (observer) {
      [observersCopy addObject:observer];
    }
  }

  return observersCopy;
}

@end
