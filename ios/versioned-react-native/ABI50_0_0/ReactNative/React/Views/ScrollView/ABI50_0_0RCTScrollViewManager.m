/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTScrollViewManager.h"

#import "ABI50_0_0RCTBridge.h"
#import "ABI50_0_0RCTScrollView.h"
#import "ABI50_0_0RCTShadowView.h"
#import "ABI50_0_0RCTUIManager.h"

@implementation ABI50_0_0RCTConvert (UIScrollView)

ABI50_0_0RCT_ENUM_CONVERTER(
    UIScrollViewKeyboardDismissMode,
    (@{
      @"none" : @(UIScrollViewKeyboardDismissModeNone),
      @"on-drag" : @(UIScrollViewKeyboardDismissModeOnDrag),
      @"interactive" : @(UIScrollViewKeyboardDismissModeInteractive),
      // Backwards compatibility
      @"onDrag" : @(UIScrollViewKeyboardDismissModeOnDrag),
    }),
    UIScrollViewKeyboardDismissModeNone,
    integerValue)

ABI50_0_0RCT_ENUM_CONVERTER(
    UIScrollViewIndicatorStyle,
    (@{
      @"default" : @(UIScrollViewIndicatorStyleDefault),
      @"black" : @(UIScrollViewIndicatorStyleBlack),
      @"white" : @(UIScrollViewIndicatorStyleWhite),
    }),
    UIScrollViewIndicatorStyleDefault,
    integerValue)

ABI50_0_0RCT_ENUM_CONVERTER(
    UIScrollViewContentInsetAdjustmentBehavior,
    (@{
      @"automatic" : @(UIScrollViewContentInsetAdjustmentAutomatic),
      @"scrollableAxes" : @(UIScrollViewContentInsetAdjustmentScrollableAxes),
      @"never" : @(UIScrollViewContentInsetAdjustmentNever),
      @"always" : @(UIScrollViewContentInsetAdjustmentAlways),
    }),
    UIScrollViewContentInsetAdjustmentNever,
    integerValue)

@end

@implementation ABI50_0_0RCTScrollViewManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [[ABI50_0_0RCTScrollView alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(alwaysBounceHorizontal, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(alwaysBounceVertical, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(bounces, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(bouncesZoom, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(canCancelContentTouches, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(centerContent, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(maintainVisibleContentPosition, NSDictionary)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(automaticallyAdjustContentInsets, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(automaticallyAdjustKeyboardInsets, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(decelerationRate, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(directionalLockEnabled, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(indicatorStyle, UIScrollViewIndicatorStyle)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(keyboardDismissMode, UIScrollViewKeyboardDismissMode)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(maximumZoomScale, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(minimumZoomScale, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(scrollEnabled, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(pagingEnabled, BOOL)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(pinchGestureEnabled, scrollView.pinchGestureEnabled, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(scrollsToTop, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(showsHorizontalScrollIndicator, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(showsVerticalScrollIndicator, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(scrollEventThrottle, NSTimeInterval)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(zoomScale, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(contentInset, UIEdgeInsets)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(scrollIndicatorInsets, UIEdgeInsets)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(scrollToOverflowEnabled, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(snapToInterval, int)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(disableIntervalMomentum, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(snapToOffsets, NSArray<NSNumber *>)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(snapToStart, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(snapToEnd, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(snapToAlignment, NSString)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(contentOffset, scrollView.contentOffset, CGPoint)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onScrollBeginDrag, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onScroll, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onScrollToTop, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onScrollEndDrag, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onMomentumScrollBegin, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onMomentumScrollEnd, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(inverted, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(automaticallyAdjustsScrollIndicatorInsets, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(contentInsetAdjustmentBehavior, UIScrollViewContentInsetAdjustmentBehavior)

// overflow is used both in css-layout as well as by ABI50_0_0React-native. In css-layout
// we always want to treat overflow as scroll but depending on what the overflow
// is set to from js we want to clip drawing or not. This piece of code ensures
// that css-layout is always treating the contents of a scroll container as
// overflow: 'scroll'.
ABI50_0_0RCT_CUSTOM_SHADOW_PROPERTY(overflow, ABI50_0_0YGOverflow, ABI50_0_0RCTShadowView)
{
#pragma unused(json)
  view.overflow = ABI50_0_0YGOverflowScroll;
}

ABI50_0_0RCT_EXPORT_METHOD(getContentSize : (nonnull NSNumber *)ABI50_0_0ReactTag callback : (ABI50_0_0RCTResponseSenderBlock)callback)
{
  [self.bridge.uiManager
      addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, ABI50_0_0RCTScrollView *> *viewRegistry) {
        ABI50_0_0RCTScrollView *view = viewRegistry[ABI50_0_0ReactTag];
        if (!view || ![view isKindOfClass:[ABI50_0_0RCTScrollView class]]) {
          ABI50_0_0RCTLogError(@"Cannot find ABI50_0_0RCTScrollView with tag #%@", ABI50_0_0ReactTag);
          return;
        }

        CGSize size = view.scrollView.contentSize;
        callback(@[ @{@"width" : @(size.width), @"height" : @(size.height)} ]);
      }];
}

ABI50_0_0RCT_EXPORT_METHOD(scrollTo
                  : (nonnull NSNumber *)ABI50_0_0ReactTag offsetX
                  : (CGFloat)x offsetY
                  : (CGFloat)y animated
                  : (BOOL)animated)
{
  [self.bridge.uiManager
      addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        UIView *view = viewRegistry[ABI50_0_0ReactTag];
        if ([view conformsToProtocol:@protocol(ABI50_0_0RCTScrollableProtocol)]) {
          [(id<ABI50_0_0RCTScrollableProtocol>)view scrollToOffset:(CGPoint){x, y} animated:animated];
        } else {
          ABI50_0_0RCTLogError(
              @"tried to scrollTo: on non-ABI50_0_0RCTScrollableProtocol view %@ "
               "with tag #%@",
              view,
              ABI50_0_0ReactTag);
        }
      }];
}

ABI50_0_0RCT_EXPORT_METHOD(scrollToEnd : (nonnull NSNumber *)ABI50_0_0ReactTag animated : (BOOL)animated)
{
  [self.bridge.uiManager
      addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        UIView *view = viewRegistry[ABI50_0_0ReactTag];
        if ([view conformsToProtocol:@protocol(ABI50_0_0RCTScrollableProtocol)]) {
          [(id<ABI50_0_0RCTScrollableProtocol>)view scrollToEnd:animated];
        } else {
          ABI50_0_0RCTLogError(
              @"tried to scrollTo: on non-ABI50_0_0RCTScrollableProtocol view %@ "
               "with tag #%@",
              view,
              ABI50_0_0ReactTag);
        }
      }];
}

ABI50_0_0RCT_EXPORT_METHOD(zoomToRect : (nonnull NSNumber *)ABI50_0_0ReactTag withRect : (CGRect)rect animated : (BOOL)animated)
{
  [self.bridge.uiManager
      addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        UIView *view = viewRegistry[ABI50_0_0ReactTag];
        if ([view conformsToProtocol:@protocol(ABI50_0_0RCTScrollableProtocol)]) {
          [(id<ABI50_0_0RCTScrollableProtocol>)view zoomToRect:rect animated:animated];
        } else {
          ABI50_0_0RCTLogError(
              @"tried to zoomToRect: on non-ABI50_0_0RCTScrollableProtocol view %@ "
               "with tag #%@",
              view,
              ABI50_0_0ReactTag);
        }
      }];
}

ABI50_0_0RCT_EXPORT_METHOD(flashScrollIndicators : (nonnull NSNumber *)ABI50_0_0ReactTag)
{
  [self.bridge.uiManager
      addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, ABI50_0_0RCTScrollView *> *viewRegistry) {
        ABI50_0_0RCTScrollView *view = viewRegistry[ABI50_0_0ReactTag];
        if (!view || ![view isKindOfClass:[ABI50_0_0RCTScrollView class]]) {
          ABI50_0_0RCTLogError(@"Cannot find ABI50_0_0RCTScrollView with tag #%@", ABI50_0_0ReactTag);
          return;
        }

        [view.scrollView flashScrollIndicators];
      }];
}

@end
