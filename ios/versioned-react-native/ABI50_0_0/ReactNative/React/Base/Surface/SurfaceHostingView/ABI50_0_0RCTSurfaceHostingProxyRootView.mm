/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTSurfaceHostingProxyRootView.h"

#import <objc/runtime.h>

#import "ABI50_0_0RCTAssert.h"
#import "ABI50_0_0RCTBridge+Private.h"
#import "ABI50_0_0RCTBridge.h"
#import "ABI50_0_0RCTLog.h"
#import "ABI50_0_0RCTPerformanceLogger.h"
#import "ABI50_0_0RCTProfile.h"
#import "ABI50_0_0RCTRootContentView.h"
#import "ABI50_0_0RCTRootViewDelegate.h"
#import "ABI50_0_0RCTSurface.h"
#import "ABI50_0_0UIView+React.h"

static ABI50_0_0RCTSurfaceSizeMeasureMode convertToSurfaceSizeMeasureMode(ABI50_0_0RCTRootViewSizeFlexibility sizeFlexibility)
{
  switch (sizeFlexibility) {
    case ABI50_0_0RCTRootViewSizeFlexibilityWidthAndHeight:
      return ABI50_0_0RCTSurfaceSizeMeasureModeWidthUndefined | ABI50_0_0RCTSurfaceSizeMeasureModeHeightUndefined;
    case ABI50_0_0RCTRootViewSizeFlexibilityWidth:
      return ABI50_0_0RCTSurfaceSizeMeasureModeWidthUndefined | ABI50_0_0RCTSurfaceSizeMeasureModeHeightExact;
    case ABI50_0_0RCTRootViewSizeFlexibilityHeight:
      return ABI50_0_0RCTSurfaceSizeMeasureModeWidthExact | ABI50_0_0RCTSurfaceSizeMeasureModeHeightUndefined;
    case ABI50_0_0RCTRootViewSizeFlexibilityNone:
      return ABI50_0_0RCTSurfaceSizeMeasureModeWidthExact | ABI50_0_0RCTSurfaceSizeMeasureModeHeightExact;
  }
}

static ABI50_0_0RCTRootViewSizeFlexibility convertToRootViewSizeFlexibility(ABI50_0_0RCTSurfaceSizeMeasureMode sizeMeasureMode)
{
  switch (sizeMeasureMode) {
    case ABI50_0_0RCTSurfaceSizeMeasureModeWidthUndefined | ABI50_0_0RCTSurfaceSizeMeasureModeHeightUndefined:
      return ABI50_0_0RCTRootViewSizeFlexibilityWidthAndHeight;
    case ABI50_0_0RCTSurfaceSizeMeasureModeWidthUndefined | ABI50_0_0RCTSurfaceSizeMeasureModeHeightExact:
      return ABI50_0_0RCTRootViewSizeFlexibilityWidth;
    case ABI50_0_0RCTSurfaceSizeMeasureModeWidthExact | ABI50_0_0RCTSurfaceSizeMeasureModeHeightUndefined:
      return ABI50_0_0RCTRootViewSizeFlexibilityHeight;
    case ABI50_0_0RCTSurfaceSizeMeasureModeWidthExact | ABI50_0_0RCTSurfaceSizeMeasureModeHeightExact:
    default:
      return ABI50_0_0RCTRootViewSizeFlexibilityNone;
  }
}

@implementation ABI50_0_0RCTSurfaceHostingProxyRootView

- (instancetype)initWithSurface:(id<ABI50_0_0RCTSurfaceProtocol>)surface
{
  if (self = [super initWithSurface:surface
                    sizeMeasureMode:ABI50_0_0RCTSurfaceSizeMeasureModeWidthExact | ABI50_0_0RCTSurfaceSizeMeasureModeHeightExact]) {
    [surface start];
  }
  return self;
}

ABI50_0_0RCT_NOT_IMPLEMENTED(-(instancetype)initWithFrame : (CGRect)frame)
ABI50_0_0RCT_NOT_IMPLEMENTED(-(instancetype)initWithCoder : (NSCoder *)aDecoder)

#pragma mark proxy methods to ABI50_0_0RCTSurfaceHostingView

- (NSString *)moduleName
{
  return super.surface.moduleName;
}

- (UIView *)view
{
  return (UIView *)super.surface.view;
}

- (UIView *)contentView
{
  return self;
}

- (NSNumber *)ABI50_0_0ReactTag
{
  return super.surface.rootViewTag;
}

- (ABI50_0_0RCTRootViewSizeFlexibility)sizeFlexibility
{
  return convertToRootViewSizeFlexibility(super.sizeMeasureMode);
}

- (void)setSizeFlexibility:(ABI50_0_0RCTRootViewSizeFlexibility)sizeFlexibility
{
  super.sizeMeasureMode = convertToSurfaceSizeMeasureMode(sizeFlexibility);
}

- (NSDictionary *)appProperties
{
  return super.surface.properties;
}

- (void)setAppProperties:(NSDictionary *)appProperties
{
  [super.surface setProperties:appProperties];
}

- (UIView *)loadingView
{
  return super.activityIndicatorViewFactory ? super.activityIndicatorViewFactory() : nil;
}

- (void)setLoadingView:(UIView *)loadingView
{
  super.activityIndicatorViewFactory = ^UIView *(void)
  {
    return loadingView;
  };
}

#pragma mark ABI50_0_0RCTSurfaceDelegate proxying

- (void)surface:(ABI50_0_0RCTSurface *)surface didChangeStage:(ABI50_0_0RCTSurfaceStage)stage
{
  [super surface:surface didChangeStage:stage];
  if (ABI50_0_0RCTSurfaceStageIsRunning(stage)) {
    [_bridge.performanceLogger markStopForTag:ABI50_0_0RCTPLTTI];
    dispatch_async(dispatch_get_main_queue(), ^{
      [[NSNotificationCenter defaultCenter] postNotificationName:ABI50_0_0RCTContentDidAppearNotification object:self];
    });
  }
}

- (void)surface:(ABI50_0_0RCTSurface *)surface didChangeIntrinsicSize:(CGSize)intrinsicSize
{
  [super surface:surface didChangeIntrinsicSize:intrinsicSize];

  [_delegate rootViewDidChangeIntrinsicSize:(ABI50_0_0RCTRootView *)self];
}

#pragma mark legacy

- (UIViewController *)ABI50_0_0ReactViewController
{
  return _ABI50_0_0ReactViewController ?: [super ABI50_0_0ReactViewController];
}

- (void)setMinimumSize:(CGSize)minimumSize
{
  if (!CGSizeEqualToSize(minimumSize, CGSizeZero)) {
    // TODO (T93859532): Investigate implementation for this.
    ABI50_0_0RCTLogError(@"ABI50_0_0RCTSurfaceHostingProxyRootView does not support changing the deprecated minimumSize");
  }
  _minimumSize = CGSizeZero;
}

#pragma mark unsupported

- (void)cancelTouches
{
  // Not supported.
}

@end
