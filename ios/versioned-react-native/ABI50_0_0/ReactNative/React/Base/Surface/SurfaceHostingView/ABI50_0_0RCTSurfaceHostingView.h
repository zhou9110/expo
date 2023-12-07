/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTSurfaceDelegate.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfaceProtocol.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfaceSizeMeasureMode.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfaceStage.h>

@class ABI50_0_0RCTBridge;
@class ABI50_0_0RCTSurface;

typedef UIView *_Nullable (^ABI50_0_0RCTSurfaceHostingViewActivityIndicatorViewFactory)(void);

NS_ASSUME_NONNULL_BEGIN

/**
 * UIView subclass which providers interoperability between UIKit and
 * Surface regarding layout and life-cycle.
 * This class can be used as easy-to-use general purpose integration point
 * of ABI50_0_0ReactNative-powered experiences in UIKit based apps.
 */
@interface ABI50_0_0RCTSurfaceHostingView : UIView <ABI50_0_0RCTSurfaceDelegate>

/**
 * Designated initializer.
 * Instantiates a view with given Surface object.
 * Note: The view retains the surface object.
 */
- (instancetype)initWithSurface:(id<ABI50_0_0RCTSurfaceProtocol>)surface
                sizeMeasureMode:(ABI50_0_0RCTSurfaceSizeMeasureMode)sizeMeasureMode NS_DESIGNATED_INITIALIZER;

/**
 * Surface object which is currently using to power the view.
 * Read-only.
 */
@property (nonatomic, strong, readonly) id<ABI50_0_0RCTSurfaceProtocol> surface;

/**
 * Size measure mode which are defining relationship between UIKit and ABI50_0_0ReactNative
 * layout approaches.
 * Defaults to `ABI50_0_0RCTSurfaceSizeMeasureModeWidthAtMost | ABI50_0_0RCTSurfaceSizeMeasureModeHeightAtMost`.
 */
@property (nonatomic, assign) ABI50_0_0RCTSurfaceSizeMeasureMode sizeMeasureMode;

/**
 * Activity indicator factory.
 * A hosting view may use this block to instantiate and display custom activity
 * (loading) indicator (aka "spinner") when it needed.
 * Defaults to `nil` (no activity indicator).
 */
@property (nonatomic, copy, nullable) ABI50_0_0RCTSurfaceHostingViewActivityIndicatorViewFactory activityIndicatorViewFactory;

@end

NS_ASSUME_NONNULL_END
