/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTMountingManagerDelegate.h>
#import <ABI50_0_0React/ABI50_0_0RCTPrimitives.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0ComponentDescriptor.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0RawProps.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>
#import <ABI50_0_0React/renderer/mounting/ABI50_0_0MountingCoordinator.h>
#import <ABI50_0_0React/renderer/mounting/ABI50_0_0ShadowView.h>
#import <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>

NS_ASSUME_NONNULL_BEGIN

@class ABI50_0_0RCTComponentViewRegistry;

/**
 * Manages mounting process.
 */
@interface ABI50_0_0RCTMountingManager : NSObject

@property (nonatomic, weak) id<ABI50_0_0RCTMountingManagerDelegate> delegate;
@property (nonatomic, strong) ABI50_0_0RCTComponentViewRegistry *componentViewRegistry;

- (void)setContextContainer:(ABI50_0_0facebook::ABI50_0_0React::ContextContainer::Shared)contextContainer;

/**
 * Designates the view as a rendering viewport of a ABI50_0_0React Native surface.
 * The provided view must not have any subviews, and the caller is not supposed to interact with the view hierarchy
 * inside the provided view. The view hierarchy created by mounting infrastructure inside the provided view does not
 * influence the intrinsic size of the view and cannot be measured using UIView/UIKit layout API.
 * Must be called on the main thead.
 */
- (void)attachSurfaceToView:(UIView *)view surfaceId:(ABI50_0_0facebook::ABI50_0_0React::SurfaceId)surfaceId;

/**
 * Stops designating the view as a rendering viewport of a ABI50_0_0React Native surface.
 */
- (void)detachSurfaceFromView:(UIView *)view surfaceId:(ABI50_0_0facebook::ABI50_0_0React::SurfaceId)surfaceId;

/**
 * Schedule a mounting transaction to be performed on the main thread.
 * Can be called from any thread.
 */
- (void)scheduleTransaction:(ABI50_0_0facebook::ABI50_0_0React::MountingCoordinator::Shared)mountingCoordinator;

/**
 * Dispatch a command to be performed on the main thread.
 * Can be called from any thread.
 */
- (void)dispatchCommand:(ABI50_0_0ReactTag)ABI50_0_0ReactTag commandName:(NSString *)commandName args:(NSArray *)args;

/**
 * Dispatch an accessibility event to be performed on the main thread.
 * Can be called from any thread.
 */
- (void)sendAccessibilityEvent:(ABI50_0_0ReactTag)ABI50_0_0ReactTag eventType:(NSString *)eventType;

- (void)setIsJSResponder:(BOOL)isJSResponder
    blockNativeResponder:(BOOL)blockNativeResponder
           forShadowView:(const ABI50_0_0facebook::ABI50_0_0React::ShadowView &)shadowView;

- (void)synchronouslyUpdateViewOnUIThread:(ABI50_0_0ReactTag)ABI50_0_0ReactTag
                             changedProps:(NSDictionary *)props
                      componentDescriptor:(const ABI50_0_0facebook::ABI50_0_0React::ComponentDescriptor &)componentDescriptor;
@end

NS_ASSUME_NONNULL_END
