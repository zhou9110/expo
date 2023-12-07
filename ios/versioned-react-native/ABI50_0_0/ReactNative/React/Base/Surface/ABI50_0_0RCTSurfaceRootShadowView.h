/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTShadowView.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfaceRootShadowViewDelegate.h>
#import <ABI50_0_0yoga/ABI50_0_0YGEnums.h>

@interface ABI50_0_0RCTSurfaceRootShadowView : ABI50_0_0RCTShadowView

@property (nonatomic, assign, readonly) CGSize minimumSize;
@property (nonatomic, assign, readonly) CGSize maximumSize;

- (void)setMinimumSize:(CGSize)size maximumSize:(CGSize)maximumSize;

@property (nonatomic, assign, readonly) CGSize intrinsicSize;

@property (nonatomic, weak) id<ABI50_0_0RCTSurfaceRootShadowViewDelegate> delegate;

/**
 * Layout direction (LTR or RTL) inherited from native environment and
 * is using as a base direction value in layout engine.
 * Defaults to value inferred from current locale.
 */
@property (nonatomic, assign) ABI50_0_0YGDirection baseDirection;

- (void)layoutWithAffectedShadowViews:(NSPointerArray *)affectedShadowViews;

@end
