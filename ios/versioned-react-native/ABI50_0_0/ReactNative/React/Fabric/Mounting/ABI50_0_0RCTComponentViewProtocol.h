/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorProvider.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0EventEmitter.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0LayoutMetrics.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0Props.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0State.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * Bitmask for all types of possible updates performing during mounting.
 */
typedef NS_OPTIONS(NSInteger, ABI50_0_0RNComponentViewUpdateMask) {
  ABI50_0_0RNComponentViewUpdateMaskNone = 0,
  ABI50_0_0RNComponentViewUpdateMaskProps = 1 << 0,
  ABI50_0_0RNComponentViewUpdateMaskEventEmitter = 1 << 1,
  ABI50_0_0RNComponentViewUpdateMaskState = 1 << 3,
  ABI50_0_0RNComponentViewUpdateMaskLayoutMetrics = 1 << 4,

  ABI50_0_0RNComponentViewUpdateMaskAll = ABI50_0_0RNComponentViewUpdateMaskProps | ABI50_0_0RNComponentViewUpdateMaskEventEmitter |
      ABI50_0_0RNComponentViewUpdateMaskState | ABI50_0_0RNComponentViewUpdateMaskLayoutMetrics
};

/*
 * Represents a `UIView` instance managed by ABI50_0_0React.
 * All methods are non-@optional.
 * `UIView+ComponentViewProtocol` category provides default implementation
 * for all of them.
 */
@protocol ABI50_0_0RCTComponentViewProtocol <NSObject>

/*
 * Returns a `ComponentDescriptorProvider` of a particular `ComponentDescriptor` which this component view
 * represents.
 */
+ (ABI50_0_0facebook::ABI50_0_0React::ComponentDescriptorProvider)componentDescriptorProvider;

/*
 * Returns a list of supplemental  `ComponentDescriptorProvider`s (with do not have `ComponentView` counterparts) that
 * require for this component view.
 */
+ (std::vector<ABI50_0_0facebook::ABI50_0_0React::ComponentDescriptorProvider>)supplementalComponentDescriptorProviders;

/*
 * Called for mounting (attaching) a child component view inside `self`
 * component view.
 * Receiver must add `childComponentView` as a subview.
 */
- (void)mountChildComponentView:(UIView<ABI50_0_0RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index;

/*
 * Called for unmounting (detaching) a child component view from `self`
 * component view.
 * Receiver must remove `childComponentView` as a subview.
 */
- (void)unmountChildComponentView:(UIView<ABI50_0_0RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index;

/*
 * Called for updating component's props.
 * Receiver must update native view props accordingly changed props.
 */
- (void)updateProps:(const ABI50_0_0facebook::ABI50_0_0React::Props::Shared &)props
           oldProps:(const ABI50_0_0facebook::ABI50_0_0React::Props::Shared &)oldProps;

/*
 * Called for updating component's state.
 * Receiver must update native view according to changed state.
 */
- (void)updateState:(const ABI50_0_0facebook::ABI50_0_0React::State::Shared &)state
           oldState:(const ABI50_0_0facebook::ABI50_0_0React::State::Shared &)oldState;

/*
 * Called for updating component's event handlers set.
 * Receiver must cache `eventEmitter` object inside and use it for emitting
 * events when needed.
 */
- (void)updateEventEmitter:(const ABI50_0_0facebook::ABI50_0_0React::EventEmitter::Shared &)eventEmitter;

/*
 * Called for updating component's layout metrics.
 * Receiver must update `UIView` layout-related fields (such as `frame`,
 * `bounds`, `layer.zPosition`, and so on) accordingly.
 */
- (void)updateLayoutMetrics:(const ABI50_0_0facebook::ABI50_0_0React::LayoutMetrics &)layoutMetrics
           oldLayoutMetrics:(const ABI50_0_0facebook::ABI50_0_0React::LayoutMetrics &)oldLayoutMetrics;

/*
 * Called when receiving a command
 */
- (void)handleCommand:(const NSString *)commandName args:(const NSArray *)args;

/*
 * Called right after all update methods were called for a particular component view.
 * Useful for performing updates that require knowledge of several independent aspects of the compound mounting change
 * (e.g. props *and* layout constraints).
 */
- (void)finalizeUpdates:(ABI50_0_0RNComponentViewUpdateMask)updateMask;

/*
 * Called right after the component view is moved to a recycle pool.
 * Receiver must reset any local state and release associated
 * non-reusable resources.
 */
- (void)prepareForRecycle;

/*
 * Read the last props used to update the view.
 */
- (ABI50_0_0facebook::ABI50_0_0React::Props::Shared)props;

- (BOOL)isJSResponder;
- (void)setIsJSResponder:(BOOL)isJSResponder;

/*
 * This is broken. Do not use.
 */
- (void)setPropKeysManagedByAnimated_DO_NOT_USE_THIS_IS_BROKEN:(nullable NSSet<NSString *> *)props;
- (nullable NSSet<NSString *> *)propKeysManagedByAnimated_DO_NOT_USE_THIS_IS_BROKEN;

@end

NS_ASSUME_NONNULL_END
