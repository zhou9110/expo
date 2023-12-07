/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>
#import <memory>

#import <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorFactory.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0ComponentDescriptor.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0EventListener.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0LayoutConstraints.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0LayoutContext.h>
#import <ABI50_0_0React/renderer/mounting/ABI50_0_0MountingCoordinator.h>
#import <ABI50_0_0React/renderer/scheduler/ABI50_0_0SchedulerToolbox.h>
#import <ABI50_0_0React/renderer/scheduler/ABI50_0_0SurfaceHandler.h>
#import <ABI50_0_0React/renderer/uimanager/ABI50_0_0UIManager.h>
#import <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>

NS_ASSUME_NONNULL_BEGIN

@class ABI50_0_0RCTMountingManager;

/**
 * Exactly same semantic as `ABI50_0_0facebook::ABI50_0_0React::SchedulerDelegate`.
 */
@protocol ABI50_0_0RCTSchedulerDelegate

- (void)schedulerDidFinishTransaction:(ABI50_0_0facebook::ABI50_0_0React::MountingCoordinator::Shared)mountingCoordinator;

- (void)schedulerDidDispatchCommand:(const ABI50_0_0facebook::ABI50_0_0React::ShadowView &)shadowView
                        commandName:(const std::string &)commandName
                               args:(const folly::dynamic &)args;

- (void)schedulerDidSendAccessibilityEvent:(const ABI50_0_0facebook::ABI50_0_0React::ShadowView &)shadowView
                                 eventType:(const std::string &)eventType;

- (void)schedulerDidSetIsJSResponder:(BOOL)isJSResponder
                blockNativeResponder:(BOOL)blockNativeResponder
                       forShadowView:(const ABI50_0_0facebook::ABI50_0_0React::ShadowView &)shadowView;

@end

/**
 * `ABI50_0_0facebook::ABI50_0_0React::Scheduler` as an Objective-C class.
 */
@interface ABI50_0_0RCTScheduler : NSObject

@property (atomic, weak, nullable) id<ABI50_0_0RCTSchedulerDelegate> delegate;
@property (readonly) const std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::UIManager> uiManager;

- (instancetype)initWithToolbox:(ABI50_0_0facebook::ABI50_0_0React::SchedulerToolbox)toolbox;

- (void)registerSurface:(const ABI50_0_0facebook::ABI50_0_0React::SurfaceHandler &)surfaceHandler;
- (void)unregisterSurface:(const ABI50_0_0facebook::ABI50_0_0React::SurfaceHandler &)surfaceHandler;

- (const ABI50_0_0facebook::ABI50_0_0React::ComponentDescriptor *)findComponentDescriptorByHandle_DO_NOT_USE_THIS_IS_BROKEN:
    (ABI50_0_0facebook::ABI50_0_0React::ComponentHandle)handle;

- (void)setupAnimationDriver:(const ABI50_0_0facebook::ABI50_0_0React::SurfaceHandler &)surfaceHandler;

- (void)onAnimationStarted;

- (void)onAllAnimationsComplete;

- (void)animationTick;

- (void)reportMount:(ABI50_0_0facebook::ABI50_0_0React::SurfaceId)surfaceId;

- (void)addEventListener:(const std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::EventListener> &)listener;

- (void)removeEventListener:(const std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::EventListener> &)listener;

@end

NS_ASSUME_NONNULL_END
