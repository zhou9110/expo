/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTRootView.h>

#import "ABI50_0_0RCTSurfaceHostingView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * This is a ABI50_0_0RCTRootView-compatible implementation of ABI50_0_0RCTSurfaceHostingView.
 * Use this class to replace all usages of ABI50_0_0RCTRootView in the app for easier migration
 * to ABI50_0_0RCTSurfaceHostingView.
 *
 * WARNING: In the future, ABI50_0_0RCTRootView will be deprecated in favor of ABI50_0_0RCTSurfaceHostingView.
 */
@interface ABI50_0_0RCTSurfaceHostingProxyRootView : ABI50_0_0RCTSurfaceHostingView

#pragma mark ABI50_0_0RCTRootView compatibility - keep these sync'ed with ABI50_0_0RCTRootView.h

@property (nonatomic, copy, readonly) NSString *moduleName;
@property (nonatomic, strong, readonly) ABI50_0_0RCTBridge *bridge;
@property (nonatomic, copy, readwrite) NSDictionary *appProperties;
@property (nonatomic, assign) ABI50_0_0RCTRootViewSizeFlexibility sizeFlexibility;
@property (nonatomic, weak) id<ABI50_0_0RCTRootViewDelegate> delegate;
@property (nonatomic, weak) UIViewController *ABI50_0_0ReactViewController;
@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, assign) BOOL passThroughTouches;
@property (nonatomic, assign) NSTimeInterval loadingViewFadeDelay;
@property (nonatomic, assign) NSTimeInterval loadingViewFadeDuration;
@property (nonatomic, assign) CGSize minimumSize;

- (instancetype)initWithSurface:(id<ABI50_0_0RCTSurfaceProtocol>)surface NS_DESIGNATED_INITIALIZER;

- (void)cancelTouches;

@end

NS_ASSUME_NONNULL_END
