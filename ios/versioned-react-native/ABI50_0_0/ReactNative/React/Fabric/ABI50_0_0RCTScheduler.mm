/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTScheduler.h"

#import <ABI50_0_0React/renderer/animations/ABI50_0_0LayoutAnimationDriver.h>
#import <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorFactory.h>
#import <ABI50_0_0React/renderer/debug/ABI50_0_0SystraceSection.h>
#import <ABI50_0_0React/renderer/scheduler/ABI50_0_0Scheduler.h>
#import <ABI50_0_0React/renderer/scheduler/ABI50_0_0SchedulerDelegate.h>
#import <ABI50_0_0React/utils/ABI50_0_0RunLoopObserver.h>

#import "ABI50_0_0RCTFollyConvert.h"

#import "ABI50_0_0RCTConversions.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

class SchedulerDelegateProxy : public SchedulerDelegate {
 public:
  SchedulerDelegateProxy(void *scheduler) : scheduler_(scheduler) {}

  void schedulerDidFinishTransaction(const MountingCoordinator::Shared &mountingCoordinator) override
  {
    ABI50_0_0RCTScheduler *scheduler = (__bridge ABI50_0_0RCTScheduler *)scheduler_;
    [scheduler.delegate schedulerDidFinishTransaction:mountingCoordinator];
  }

  void schedulerDidRequestPreliminaryViewAllocation(SurfaceId surfaceId, const ShadowNode &shadowNode) override
  {
    // Does nothing.
    // This delegate method is not currently used on iOS.
  }

  void schedulerDidDispatchCommand(
      const ShadowView &shadowView,
      const std::string &commandName,
      const folly::dynamic &args) override
  {
    ABI50_0_0RCTScheduler *scheduler = (__bridge ABI50_0_0RCTScheduler *)scheduler_;
    [scheduler.delegate schedulerDidDispatchCommand:shadowView commandName:commandName args:args];
  }

  void schedulerDidSetIsJSResponder(const ShadowView &shadowView, bool isJSResponder, bool blockNativeResponder)
      override
  {
    ABI50_0_0RCTScheduler *scheduler = (__bridge ABI50_0_0RCTScheduler *)scheduler_;
    [scheduler.delegate schedulerDidSetIsJSResponder:isJSResponder
                                blockNativeResponder:blockNativeResponder
                                       forShadowView:shadowView];
  }

  void schedulerDidSendAccessibilityEvent(const ShadowView &shadowView, const std::string &eventType) override
  {
    ABI50_0_0RCTScheduler *scheduler = (__bridge ABI50_0_0RCTScheduler *)scheduler_;
    [scheduler.delegate schedulerDidSendAccessibilityEvent:shadowView eventType:eventType];
  }

 private:
  void *scheduler_;
};

class LayoutAnimationDelegateProxy : public LayoutAnimationStatusDelegate, public RunLoopObserver::Delegate {
 public:
  LayoutAnimationDelegateProxy(void *scheduler) : scheduler_(scheduler) {}
  virtual ~LayoutAnimationDelegateProxy() {}

  void onAnimationStarted() override
  {
    ABI50_0_0RCTScheduler *scheduler = (__bridge ABI50_0_0RCTScheduler *)scheduler_;
    [scheduler onAnimationStarted];
  }

  /**
   * Called when the LayoutAnimation engine completes all pending animations.
   */
  void onAllAnimationsComplete() override
  {
    ABI50_0_0RCTScheduler *scheduler = (__bridge ABI50_0_0RCTScheduler *)scheduler_;
    [scheduler onAllAnimationsComplete];
  }

  void activityDidChange(const RunLoopObserver::Delegate *delegate, RunLoopObserver::Activity activity)
      const noexcept override
  {
    ABI50_0_0RCTScheduler *scheduler = (__bridge ABI50_0_0RCTScheduler *)scheduler_;
    [scheduler animationTick];
  }

 private:
  void *scheduler_;
};

@implementation ABI50_0_0RCTScheduler {
  std::unique_ptr<Scheduler> _scheduler;
  std::shared_ptr<LayoutAnimationDriver> _animationDriver;
  std::shared_ptr<SchedulerDelegateProxy> _delegateProxy;
  std::shared_ptr<LayoutAnimationDelegateProxy> _layoutAnimationDelegateProxy;
  RunLoopObserver::Unique _uiRunLoopObserver;
}

- (instancetype)initWithToolbox:(SchedulerToolbox)toolbox
{
  if (self = [super init]) {
    auto reactNativeConfig =
        toolbox.contextContainer->at<std::shared_ptr<const ABI50_0_0ReactNativeConfig>>("ABI50_0_0ReactNativeConfig");

    _delegateProxy = std::make_shared<SchedulerDelegateProxy>((__bridge void *)self);

    if (reactNativeConfig->getBool("ABI50_0_0React_fabric:enabled_layout_animations_ios")) {
      _layoutAnimationDelegateProxy = std::make_shared<LayoutAnimationDelegateProxy>((__bridge void *)self);
      _animationDriver = std::make_shared<LayoutAnimationDriver>(
          toolbox.runtimeExecutor, toolbox.contextContainer, _layoutAnimationDelegateProxy.get());
      _uiRunLoopObserver =
          toolbox.mainRunLoopObserverFactory(RunLoopObserver::Activity::BeforeWaiting, _layoutAnimationDelegateProxy);
      _uiRunLoopObserver->setDelegate(_layoutAnimationDelegateProxy.get());
    }

    _scheduler = std::make_unique<Scheduler>(
        toolbox, (_animationDriver ? _animationDriver.get() : nullptr), _delegateProxy.get());
  }

  return self;
}

- (void)animationTick
{
  _scheduler->animationTick();
}

- (void)reportMount:(ABI50_0_0facebook::ABI50_0_0React::SurfaceId)surfaceId
{
  _scheduler->reportMount(surfaceId);
}

- (void)dealloc
{
  if (_animationDriver) {
    _animationDriver->setLayoutAnimationStatusDelegate(nullptr);
  }

  _scheduler->setDelegate(nullptr);
}

- (void)registerSurface:(const ABI50_0_0facebook::ABI50_0_0React::SurfaceHandler &)surfaceHandler
{
  _scheduler->registerSurface(surfaceHandler);
}

- (void)unregisterSurface:(const ABI50_0_0facebook::ABI50_0_0React::SurfaceHandler &)surfaceHandler
{
  _scheduler->unregisterSurface(surfaceHandler);
}

- (const ComponentDescriptor *)findComponentDescriptorByHandle_DO_NOT_USE_THIS_IS_BROKEN:(ComponentHandle)handle
{
  return _scheduler->findComponentDescriptorByHandle_DO_NOT_USE_THIS_IS_BROKEN(handle);
}

- (void)setupAnimationDriver:(const ABI50_0_0facebook::ABI50_0_0React::SurfaceHandler &)surfaceHandler
{
  surfaceHandler.getMountingCoordinator()->setMountingOverrideDelegate(_animationDriver);
}

- (void)onAnimationStarted
{
  if (_uiRunLoopObserver) {
    _uiRunLoopObserver->enable();
  }
}

- (void)onAllAnimationsComplete
{
  if (_uiRunLoopObserver) {
    _uiRunLoopObserver->disable();
  }
}

- (void)addEventListener:(const std::shared_ptr<EventListener> &)listener
{
  return _scheduler->addEventListener(listener);
}

- (void)removeEventListener:(const std::shared_ptr<EventListener> &)listener
{
  return _scheduler->removeEventListener(listener);
}

- (const std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::UIManager>)uiManager
{
  return _scheduler->getUIManager();
}

@end
