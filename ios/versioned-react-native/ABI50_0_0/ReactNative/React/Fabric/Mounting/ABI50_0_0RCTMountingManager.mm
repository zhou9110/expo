/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTMountingManager.h"

#import <QuartzCore/QuartzCore.h>

#import <ABI50_0_0React/ABI50_0_0RCTAssert.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponent.h>
#import <ABI50_0_0React/ABI50_0_0RCTFollyConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTLog.h>
#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>
#import <ABI50_0_0React/config/ABI50_0_0ReactNativeConfig.h>
#import <ABI50_0_0React/renderer/components/root/ABI50_0_0RootShadowNode.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0LayoutableShadowNode.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0RawProps.h>
#import <ABI50_0_0React/renderer/debug/ABI50_0_0SystraceSection.h>
#import <ABI50_0_0React/renderer/mounting/ABI50_0_0TelemetryController.h>
#import <ABI50_0_0React/utils/ABI50_0_0CoreFeatures.h>

#import <ABI50_0_0React/ABI50_0_0RCTComponentViewProtocol.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponentViewRegistry.h>
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <ABI50_0_0React/ABI50_0_0RCTMountingTransactionObserverCoordinator.h>

using namespace ABI50_0_0facebook::ABI50_0_0React;

static SurfaceId ABI50_0_0RCTSurfaceIdForView(UIView *view)
{
  do {
    if (ABI50_0_0RCTIsABI50_0_0ReactRootView(@(view.tag))) {
      return view.tag;
    }
    view = view.superview;
  } while (view != nil);

  return -1;
}

static void ABI50_0_0RCTPerformMountInstructions(
    const ShadowViewMutationList &mutations,
    ABI50_0_0RCTComponentViewRegistry *registry,
    ABI50_0_0RCTMountingTransactionObserverCoordinator &observerCoordinator,
    SurfaceId surfaceId)
{
  SystraceSection s("ABI50_0_0RCTPerformMountInstructions");

  for (const auto &mutation : mutations) {
    switch (mutation.type) {
      case ShadowViewMutation::Create: {
        auto &newChildShadowView = mutation.newChildShadowView;
        auto &newChildViewDescriptor =
            [registry dequeueComponentViewWithComponentHandle:newChildShadowView.componentHandle
                                                          tag:newChildShadowView.tag];
        observerCoordinator.registerViewComponentDescriptor(newChildViewDescriptor, surfaceId);
        break;
      }

      case ShadowViewMutation::Delete: {
        auto &oldChildShadowView = mutation.oldChildShadowView;
        auto &oldChildViewDescriptor = [registry componentViewDescriptorWithTag:oldChildShadowView.tag];

        observerCoordinator.unregisterViewComponentDescriptor(oldChildViewDescriptor, surfaceId);

        [registry enqueueComponentViewWithComponentHandle:oldChildShadowView.componentHandle
                                                      tag:oldChildShadowView.tag
                                  componentViewDescriptor:oldChildViewDescriptor];
        break;
      }

      case ShadowViewMutation::Insert: {
        auto &oldChildShadowView = mutation.oldChildShadowView;
        auto &newChildShadowView = mutation.newChildShadowView;
        auto &parentShadowView = mutation.parentShadowView;
        auto &newChildViewDescriptor = [registry componentViewDescriptorWithTag:newChildShadowView.tag];
        auto &parentViewDescriptor = [registry componentViewDescriptorWithTag:parentShadowView.tag];

        UIView<ABI50_0_0RCTComponentViewProtocol> *newChildComponentView = newChildViewDescriptor.view;

        ABI50_0_0RCTAssert(newChildShadowView.props, @"`newChildShadowView.props` must not be null.");

        [newChildComponentView updateProps:newChildShadowView.props oldProps:oldChildShadowView.props];
        [newChildComponentView updateEventEmitter:newChildShadowView.eventEmitter];
        [newChildComponentView updateState:newChildShadowView.state oldState:oldChildShadowView.state];
        [newChildComponentView updateLayoutMetrics:newChildShadowView.layoutMetrics
                                  oldLayoutMetrics:oldChildShadowView.layoutMetrics];
        [newChildComponentView finalizeUpdates:ABI50_0_0RNComponentViewUpdateMaskAll];

        [parentViewDescriptor.view mountChildComponentView:newChildComponentView index:mutation.index];
        break;
      }

      case ShadowViewMutation::Remove: {
        auto &oldChildShadowView = mutation.oldChildShadowView;
        auto &parentShadowView = mutation.parentShadowView;
        auto &oldChildViewDescriptor = [registry componentViewDescriptorWithTag:oldChildShadowView.tag];
        auto &parentViewDescriptor = [registry componentViewDescriptorWithTag:parentShadowView.tag];
        [parentViewDescriptor.view unmountChildComponentView:oldChildViewDescriptor.view index:mutation.index];
        break;
      }

      case ShadowViewMutation::RemoveDeleteTree: {
        // TODO - not supported yet
        break;
      }

      case ShadowViewMutation::Update: {
        auto &oldChildShadowView = mutation.oldChildShadowView;
        auto &newChildShadowView = mutation.newChildShadowView;
        auto &newChildViewDescriptor = [registry componentViewDescriptorWithTag:newChildShadowView.tag];
        UIView<ABI50_0_0RCTComponentViewProtocol> *newChildComponentView = newChildViewDescriptor.view;

        auto mask = ABI50_0_0RNComponentViewUpdateMask{};

        ABI50_0_0RCTAssert(newChildShadowView.props, @"`newChildShadowView.props` must not be null.");

        if (oldChildShadowView.props != newChildShadowView.props) {
          [newChildComponentView updateProps:newChildShadowView.props oldProps:oldChildShadowView.props];
          mask |= ABI50_0_0RNComponentViewUpdateMaskProps;
        }

        if (oldChildShadowView.eventEmitter != newChildShadowView.eventEmitter) {
          [newChildComponentView updateEventEmitter:newChildShadowView.eventEmitter];
          mask |= ABI50_0_0RNComponentViewUpdateMaskEventEmitter;
        }

        if (oldChildShadowView.state != newChildShadowView.state) {
          [newChildComponentView updateState:newChildShadowView.state oldState:oldChildShadowView.state];
          mask |= ABI50_0_0RNComponentViewUpdateMaskState;
        }

        if (oldChildShadowView.layoutMetrics != newChildShadowView.layoutMetrics) {
          [newChildComponentView updateLayoutMetrics:newChildShadowView.layoutMetrics
                                    oldLayoutMetrics:oldChildShadowView.layoutMetrics];
          mask |= ABI50_0_0RNComponentViewUpdateMaskLayoutMetrics;
        }

        if (mask != ABI50_0_0RNComponentViewUpdateMaskNone) {
          [newChildComponentView finalizeUpdates:mask];
        }

        break;
      }
    }
  }
}

@implementation ABI50_0_0RCTMountingManager {
  ABI50_0_0RCTMountingTransactionObserverCoordinator _observerCoordinator;
  BOOL _transactionInFlight;
  BOOL _followUpTransactionRequired;
  ContextContainer::Shared _contextContainer;
}

- (instancetype)init
{
  if (self = [super init]) {
    _componentViewRegistry = [ABI50_0_0RCTComponentViewRegistry new];
  }

  return self;
}

- (void)setContextContainer:(ContextContainer::Shared)contextContainer
{
  _contextContainer = contextContainer;
}

- (void)attachSurfaceToView:(UIView *)view surfaceId:(SurfaceId)surfaceId
{
  ABI50_0_0RCTAssertMainQueue();

  ABI50_0_0RCTAssert(view.subviews.count == 0, @"The view must not have any subviews.");

  ABI50_0_0RCTComponentViewDescriptor rootViewDescriptor =
      [_componentViewRegistry dequeueComponentViewWithComponentHandle:RootShadowNode::Handle() tag:surfaceId];
  [view addSubview:rootViewDescriptor.view];
}

- (void)detachSurfaceFromView:(UIView *)view surfaceId:(SurfaceId)surfaceId
{
  ABI50_0_0RCTAssertMainQueue();
  ABI50_0_0RCTComponentViewDescriptor rootViewDescriptor = [_componentViewRegistry componentViewDescriptorWithTag:surfaceId];

  [rootViewDescriptor.view removeFromSuperview];

  [_componentViewRegistry enqueueComponentViewWithComponentHandle:RootShadowNode::Handle()
                                                              tag:surfaceId
                                          componentViewDescriptor:rootViewDescriptor];
}

- (void)scheduleTransaction:(MountingCoordinator::Shared)mountingCoordinator
{
  if (ABI50_0_0RCTIsMainQueue()) {
    // Already on the proper thread, so:
    // * No need to do a thread jump;
    // * No need to do expensive copy of all mutations;
    // * No need to allocate a block.
    [self initiateTransaction:*mountingCoordinator];
    return;
  }

  ABI50_0_0RCTExecuteOnMainQueue(^{
    ABI50_0_0RCTAssertMainQueue();
    [self initiateTransaction:*mountingCoordinator];
  });
}

- (void)dispatchCommand:(ABI50_0_0ReactTag)ABI50_0_0ReactTag commandName:(NSString *)commandName args:(NSArray *)args
{
  if (ABI50_0_0RCTIsMainQueue()) {
    // Already on the proper thread, so:
    // * No need to do a thread jump;
    // * No need to allocate a block.
    [self synchronouslyDispatchCommandOnUIThread:ABI50_0_0ReactTag commandName:commandName args:args];
    return;
  }

  ABI50_0_0RCTExecuteOnMainQueue(^{
    [self synchronouslyDispatchCommandOnUIThread:ABI50_0_0ReactTag commandName:commandName args:args];
  });
}

- (void)sendAccessibilityEvent:(ABI50_0_0ReactTag)ABI50_0_0ReactTag eventType:(NSString *)eventType
{
  if (ABI50_0_0RCTIsMainQueue()) {
    // Already on the proper thread, so:
    // * No need to do a thread jump;
    // * No need to allocate a block.
    [self synchronouslyDispatchAccessbilityEventOnUIThread:ABI50_0_0ReactTag eventType:eventType];
    return;
  }

  ABI50_0_0RCTExecuteOnMainQueue(^{
    [self synchronouslyDispatchAccessbilityEventOnUIThread:ABI50_0_0ReactTag eventType:eventType];
  });
}

- (void)initiateTransaction:(const MountingCoordinator &)mountingCoordinator
{
  SystraceSection s("-[ABI50_0_0RCTMountingManager initiateTransaction:]");
  ABI50_0_0RCTAssertMainQueue();

  if (_transactionInFlight) {
    _followUpTransactionRequired = YES;
    return;
  }

  do {
    _followUpTransactionRequired = NO;
    _transactionInFlight = YES;
    [self performTransaction:mountingCoordinator];
    _transactionInFlight = NO;
  } while (_followUpTransactionRequired);
}

- (void)performTransaction:(const MountingCoordinator &)mountingCoordinator
{
  SystraceSection s("-[ABI50_0_0RCTMountingManager performTransaction:]");
  ABI50_0_0RCTAssertMainQueue();

  auto surfaceId = mountingCoordinator.getSurfaceId();

  mountingCoordinator.getTelemetryController().pullTransaction(
      [&](const MountingTransaction &transaction, const SurfaceTelemetry &surfaceTelemetry) {
        [self.delegate mountingManager:self willMountComponentsWithRootTag:surfaceId];
        _observerCoordinator.notifyObserversMountingTransactionWillMount(transaction, surfaceTelemetry);
      },
      [&](const MountingTransaction &transaction, const SurfaceTelemetry &surfaceTelemetry) {
        ABI50_0_0RCTPerformMountInstructions(
            transaction.getMutations(), _componentViewRegistry, _observerCoordinator, surfaceId);
      },
      [&](const MountingTransaction &transaction, const SurfaceTelemetry &surfaceTelemetry) {
        _observerCoordinator.notifyObserversMountingTransactionDidMount(transaction, surfaceTelemetry);
        [self.delegate mountingManager:self didMountComponentsWithRootTag:surfaceId];
      });
}

- (void)setIsJSResponder:(BOOL)isJSResponder
    blockNativeResponder:(BOOL)blockNativeResponder
           forShadowView:(const ABI50_0_0facebook::ABI50_0_0React::ShadowView &)shadowView
{
  ABI50_0_0ReactTag ABI50_0_0ReactTag = shadowView.tag;
  ABI50_0_0RCTExecuteOnMainQueue(^{
    UIView<ABI50_0_0RCTComponentViewProtocol> *componentView = [self->_componentViewRegistry findComponentViewWithTag:ABI50_0_0ReactTag];
    [componentView setIsJSResponder:isJSResponder];
  });
}

- (void)synchronouslyUpdateViewOnUIThread:(ABI50_0_0ReactTag)ABI50_0_0ReactTag
                             changedProps:(NSDictionary *)props
                      componentDescriptor:(const ComponentDescriptor &)componentDescriptor
{
  ABI50_0_0RCTAssertMainQueue();
  UIView<ABI50_0_0RCTComponentViewProtocol> *componentView = [_componentViewRegistry findComponentViewWithTag:ABI50_0_0ReactTag];
  SurfaceId surfaceId = ABI50_0_0RCTSurfaceIdForView(componentView);
  Props::Shared oldProps = [componentView props];
  Props::Shared newProps = componentDescriptor.cloneProps(
                                                          PropsParserContext{surfaceId, *_contextContainer.get()}, oldProps, RawProps(convertIdToFollyDynamic(props)));

  NSSet<NSString *> *propKeys = componentView.propKeysManagedByAnimated_DO_NOT_USE_THIS_IS_BROKEN ?: [NSSet new];
  propKeys = [propKeys setByAddingObjectsFromArray:props.allKeys];
  componentView.propKeysManagedByAnimated_DO_NOT_USE_THIS_IS_BROKEN = nil;
  [componentView updateProps:newProps oldProps:oldProps];
  componentView.propKeysManagedByAnimated_DO_NOT_USE_THIS_IS_BROKEN = propKeys;

  const auto &newViewProps = static_cast<const ViewProps &>(*newProps);

  if (props[@"transform"]) {
    auto layoutMetrics = LayoutMetrics();
    layoutMetrics.frame.size.width = componentView.layer.bounds.size.width;
    layoutMetrics.frame.size.height = componentView.layer.bounds.size.height;
    CATransform3D newTransform = ABI50_0_0RCTCATransform3DFromTransformMatrix(newViewProps.resolveTransform(layoutMetrics));
    if (!CATransform3DEqualToTransform(newTransform, componentView.layer.transform)) {
      componentView.layer.transform = newTransform;
    }
  }
  if (props[@"opacity"] && componentView.layer.opacity != (float)newViewProps.opacity) {
    componentView.layer.opacity = newViewProps.opacity;
  }

  [componentView finalizeUpdates:ABI50_0_0RNComponentViewUpdateMaskProps];
}

- (void)synchronouslyDispatchCommandOnUIThread:(ABI50_0_0ReactTag)ABI50_0_0ReactTag
                                   commandName:(NSString *)commandName
                                          args:(NSArray *)args
{
  ABI50_0_0RCTAssertMainQueue();
  UIView<ABI50_0_0RCTComponentViewProtocol> *componentView = [_componentViewRegistry findComponentViewWithTag:ABI50_0_0ReactTag];
  [componentView handleCommand:commandName args:args];
}

- (void)synchronouslyDispatchAccessbilityEventOnUIThread:(ABI50_0_0ReactTag)ABI50_0_0ReactTag eventType:(NSString *)eventType
{
  if ([@"focus" isEqualToString:eventType]) {
    UIView<ABI50_0_0RCTComponentViewProtocol> *componentView = [_componentViewRegistry findComponentViewWithTag:ABI50_0_0ReactTag];
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, componentView);
  }
}

@end
