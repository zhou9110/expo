/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTLegacyViewManagerInteropComponentView.h"

#import <ABI50_0_0React/ABI50_0_0RCTAssert.h>
#import <ABI50_0_0React/ABI50_0_0RCTConstants.h>
#import <ABI50_0_0React/ABI50_0_0UIView+React.h>
#import <ABI50_0_0React/renderer/components/legacyviewmanagerinterop/ABI50_0_0LegacyViewManagerInteropComponentDescriptor.h>
#import <ABI50_0_0React/renderer/components/legacyviewmanagerinterop/ABI50_0_0LegacyViewManagerInteropViewProps.h>
#import <ABI50_0_0React/utils/ABI50_0_0ManagedObjectWrapper.h>
#import "ABI50_0_0RCTLegacyViewManagerInteropCoordinatorAdapter.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

static NSString *const kABI50_0_0RCTLegacyInteropChildComponentKey = @"childComponentView";
static NSString *const kABI50_0_0RCTLegacyInteropChildIndexKey = @"index";

@implementation ABI50_0_0RCTLegacyViewManagerInteropComponentView {
  NSMutableArray<NSDictionary *> *_viewsToBeMounted;
  NSMutableArray<UIView *> *_viewsToBeUnmounted;
  ABI50_0_0RCTLegacyViewManagerInteropCoordinatorAdapter *_adapter;
  LegacyViewManagerInteropShadowNode::ConcreteState::Shared _state;
  BOOL _hasInvokedForwardingWarning;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const LegacyViewManagerInteropViewProps>();
    _props = defaultProps;
    _viewsToBeMounted = [NSMutableArray new];
    _viewsToBeUnmounted = [NSMutableArray new];
    _hasInvokedForwardingWarning = NO;
  }

  return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  UIView *result = [super hitTest:point withEvent:event];

  if (result == _adapter.paperView) {
    return self;
  }

  return result;
}

- (ABI50_0_0RCTLegacyViewManagerInteropCoordinator *)_coordinator
{
  if (_state != nullptr) {
    const auto &state = _state->getData();
    return unwrapManagedObject(state.coordinator);
  } else {
    return nil;
  }
}

- (NSString *)componentViewName_DO_NOT_USE_THIS_IS_BROKEN
{
  const auto &state = _state->getData();
  ABI50_0_0RCTLegacyViewManagerInteropCoordinator *coordinator = unwrapManagedObject(state.coordinator);
  return coordinator.componentViewName;
}

#pragma mark - Method forwarding

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
  if (!_hasInvokedForwardingWarning) {
    _hasInvokedForwardingWarning = YES;
    NSLog(
        @"Invoked unsupported method on ABI50_0_0RCTLegacyViewManagerInteropComponentView. Resulting to noop instead of a crash.");
  }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
  return [super methodSignatureForSelector:aSelector] ?: [self.contentView methodSignatureForSelector:aSelector];
}

#pragma mark - Supported ViewManagers

+ (NSMutableSet<NSString *> *)supportedViewManagers
{
  static NSMutableSet<NSString *> *supported = [NSMutableSet setWithObjects:@"DatePicker",
                                                                            @"ProgressView",
                                                                            @"SegmentedControl",
                                                                            @"MaskedView",
                                                                            @"ABI50_0_0ARTSurfaceView",
                                                                            @"ABI50_0_0ARTText",
                                                                            @"ABI50_0_0ARTShape",
                                                                            @"ABI50_0_0ARTGroup",
                                                                            nil];
  return supported;
}

+ (NSMutableSet<NSString *> *)supportedViewManagersPrefixes
{
  static NSMutableSet<NSString *> *supported = [NSMutableSet new];
  return supported;
}

+ (BOOL)isSupported:(NSString *)componentName
{
  // Step 1: check if ViewManager with specified name is supported.
  BOOL isComponentNameSupported =
      [[ABI50_0_0RCTLegacyViewManagerInteropComponentView supportedViewManagers] containsObject:componentName];
  if (isComponentNameSupported) {
    return YES;
  }

  // Step 2: check if component has supported prefix.
  for (NSString *item in [ABI50_0_0RCTLegacyViewManagerInteropComponentView supportedViewManagersPrefixes]) {
    if ([componentName hasPrefix:item]) {
      return YES;
    }
  }

  return NO;
}

+ (void)supportLegacyViewManagersWithPrefix:(NSString *)prefix
{
  [[ABI50_0_0RCTLegacyViewManagerInteropComponentView supportedViewManagersPrefixes] addObject:prefix];
}

+ (void)supportLegacyViewManagerWithName:(NSString *)componentName
{
  [[ABI50_0_0RCTLegacyViewManagerInteropComponentView supportedViewManagers] addObject:componentName];
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

- (void)prepareForRecycle
{
  _adapter = nil;
  [_viewsToBeMounted removeAllObjects];
  [_viewsToBeUnmounted removeAllObjects];
  _state.reset();
  self.contentView = nil;
  _hasInvokedForwardingWarning = NO;
  [super prepareForRecycle];
}

- (void)mountChildComponentView:(UIView<ABI50_0_0RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index
{
  [_viewsToBeMounted addObject:@{
    kABI50_0_0RCTLegacyInteropChildIndexKey : [NSNumber numberWithInteger:index],
    kABI50_0_0RCTLegacyInteropChildComponentKey : childComponentView
  }];
}

- (void)unmountChildComponentView:(UIView<ABI50_0_0RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index
{
  if (_adapter) {
    [_adapter.paperView removeABI50_0_0ReactSubview:childComponentView];
  } else {
    [_viewsToBeUnmounted addObject:childComponentView];
  }
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<LegacyViewManagerInteropComponentDescriptor>();
}

- (void)updateState:(const State::Shared &)state oldState:(const State::Shared &)oldState
{
  _state = std::static_pointer_cast<LegacyViewManagerInteropShadowNode::ConcreteState const>(state);
}

- (void)finalizeUpdates:(ABI50_0_0RNComponentViewUpdateMask)updateMask
{
  [super finalizeUpdates:updateMask];

  if (!_adapter) {
    _adapter = [[ABI50_0_0RCTLegacyViewManagerInteropCoordinatorAdapter alloc] initWithCoordinator:[self _coordinator]
                                                                                 ABI50_0_0ReactTag:self.tag];
    __weak __typeof(self) weakSelf = self;
    _adapter.eventInterceptor = ^(std::string eventName, folly::dynamic event) {
      if (weakSelf) {
        __typeof(self) strongSelf = weakSelf;
        const auto &eventEmitter =
            static_cast<LegacyViewManagerInteropViewEventEmitter const &>(*strongSelf->_eventEmitter);
        eventEmitter.dispatchEvent(eventName, event);
      }
    };
    self.contentView = _adapter.paperView;
  }

  for (NSDictionary *mountInstruction in _viewsToBeMounted) {
    NSNumber *index = mountInstruction[kABI50_0_0RCTLegacyInteropChildIndexKey];
    UIView *childView = mountInstruction[kABI50_0_0RCTLegacyInteropChildComponentKey];
    if ([childView isKindOfClass:[ABI50_0_0RCTLegacyViewManagerInteropComponentView class]]) {
      UIView *target = ((ABI50_0_0RCTLegacyViewManagerInteropComponentView *)childView).contentView;
      [_adapter.paperView insertABI50_0_0ReactSubview:target atIndex:index.integerValue];
    } else {
      [_adapter.paperView insertABI50_0_0ReactSubview:childView atIndex:index.integerValue];
    }
  }

  [_viewsToBeMounted removeAllObjects];

  for (UIView *view in _viewsToBeUnmounted) {
    [_adapter.paperView removeABI50_0_0ReactSubview:view];
  }

  [_viewsToBeUnmounted removeAllObjects];

  [_adapter.paperView didUpdateABI50_0_0ReactSubviews];

  if (updateMask & ABI50_0_0RNComponentViewUpdateMaskProps) {
    const auto &newProps = static_cast<const LegacyViewManagerInteropViewProps &>(*_props);
    [_adapter setProps:newProps.otherProps];
  }
}

#pragma mark - Native Commands

- (void)handleCommand:(const NSString *)commandName args:(const NSArray *)args
{
  [_adapter handleCommand:(NSString *)commandName args:(NSArray *)args];
}

@end
