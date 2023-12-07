/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTComponentViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Default implementation of ABI50_0_0RCTComponentViewProtocol.
 */
@interface UIView (ComponentViewProtocol) <ABI50_0_0RCTComponentViewProtocol>

+ (std::vector<ABI50_0_0facebook::ABI50_0_0React::ComponentDescriptorProvider>)supplementalComponentDescriptorProviders;

- (void)mountChildComponentView:(UIView<ABI50_0_0RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index;

- (void)unmountChildComponentView:(UIView<ABI50_0_0RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index;

- (void)updateProps:(const ABI50_0_0facebook::ABI50_0_0React::Props::Shared &)props
           oldProps:(const ABI50_0_0facebook::ABI50_0_0React::Props::Shared &)oldProps;

- (void)updateEventEmitter:(const ABI50_0_0facebook::ABI50_0_0React::EventEmitter::Shared &)eventEmitter;

- (void)updateState:(const ABI50_0_0facebook::ABI50_0_0React::State::Shared &)state
           oldState:(const ABI50_0_0facebook::ABI50_0_0React::State::Shared &)oldState;

- (void)updateLayoutMetrics:(const ABI50_0_0facebook::ABI50_0_0React::LayoutMetrics &)layoutMetrics
           oldLayoutMetrics:(const ABI50_0_0facebook::ABI50_0_0React::LayoutMetrics &)oldLayoutMetrics;

- (void)finalizeUpdates:(ABI50_0_0RNComponentViewUpdateMask)updateMask;

- (void)prepareForRecycle;

- (ABI50_0_0facebook::ABI50_0_0React::Props::Shared)props;

- (void)setIsJSResponder:(BOOL)isJSResponder;

- (void)setPropKeysManagedByAnimated_DO_NOT_USE_THIS_IS_BROKEN:(nullable NSSet<NSString *> *)props;
- (nullable NSSet<NSString *> *)propKeysManagedByAnimated_DO_NOT_USE_THIS_IS_BROKEN;

- (void)updateClippedSubviewsWithClipRect:(CGRect)clipRect relativeToView:(UIView *)clipView;

@end

NS_ASSUME_NONNULL_END
