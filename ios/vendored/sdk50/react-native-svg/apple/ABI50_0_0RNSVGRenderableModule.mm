/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGRenderableModule.h"
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManagerUtils.h>
#import "ABI50_0_0RNSVGPathMeasure.h"
#import "ABI50_0_0RNSVGRenderable.h"

#import "ABI50_0_0RCTConvert+RNSVG.h"
#import "ABI50_0_0RNSVGCGFCRule.h"

@implementation ABI50_0_0RNSVGRenderableModule

ABI50_0_0RCT_EXPORT_MODULE()

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
@synthesize viewRegistry_DEPRECATED = _viewRegistry_DEPRECATED;
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
@synthesize bridge = _bridge;

ABI50_0_0RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(isPointInFill : (nonnull NSNumber *)ABI50_0_0ReactTag options : (NSDictionary *)options)
{
  ABI50_0_0RNSVGPlatformView *view = [self getRenderableView:ABI50_0_0ReactTag];

  if (![view isKindOfClass:[ABI50_0_0RNSVGRenderable class]]) {
    ABI50_0_0RCTLogError(@"Invalid svg returned from registry, expecting ABI50_0_0RNSVGRenderable, got: %@", view);
    return [NSNumber numberWithBool:false];
  }
  if (options == nil) {
    ABI50_0_0RCTLogError(@"Invalid options given to isPointInFill, got: %@", options);
    return [NSNumber numberWithBool:false];
  }
  id xo = [options objectForKey:@"x"];
  id yo = [options objectForKey:@"y"];
  if (![xo isKindOfClass:NSNumber.class] || ![yo isKindOfClass:NSNumber.class]) {
    ABI50_0_0RCTLogError(@"Invalid x or y given to isPointInFill");
    return [NSNumber numberWithBool:false];
  }
  ABI50_0_0RNSVGRenderable *svg = (ABI50_0_0RNSVGRenderable *)view;
  CGFloat x = (CGFloat)[xo doubleValue];
  CGFloat y = (CGFloat)[yo doubleValue];
  CGPoint point = CGPointMake(x, y);
  ABI50_0_0RNSVGPlatformView *target = [svg hitTest:point withEvent:nil];
  BOOL hit = target != nil;
  return [NSNumber numberWithBool:hit];
}

ABI50_0_0RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(isPointInStroke : (nonnull NSNumber *)ABI50_0_0ReactTag options : (NSDictionary *)options)
{
  ABI50_0_0RNSVGPlatformView *view = [self getRenderableView:ABI50_0_0ReactTag];

  if (![view isKindOfClass:[ABI50_0_0RNSVGRenderable class]]) {
    ABI50_0_0RCTLogError(@"Invalid svg returned from registry, expecting ABI50_0_0RNSVGRenderable, got: %@", view);
    return [NSNumber numberWithBool:false];
  }
  if (options == nil) {
    ABI50_0_0RCTLogError(@"Invalid options given to isPointInFill, got: %@", options);
    return [NSNumber numberWithBool:false];
  }
  id xo = [options objectForKey:@"x"];
  id yo = [options objectForKey:@"y"];
  if (![xo isKindOfClass:NSNumber.class] || ![yo isKindOfClass:NSNumber.class]) {
    ABI50_0_0RCTLogError(@"Invalid x or y given to isPointInFill");
    return [NSNumber numberWithBool:false];
  }
  ABI50_0_0RNSVGRenderable *svg = (ABI50_0_0RNSVGRenderable *)view;
  CGFloat x = (CGFloat)[xo doubleValue];
  CGFloat y = (CGFloat)[yo doubleValue];
  CGPoint point = CGPointMake(x, y);
  BOOL hit = CGPathContainsPoint(svg.strokePath, nil, point, NO);

  return [NSNumber numberWithBool:hit];
}

ABI50_0_0RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getTotalLength : (nonnull NSNumber *)ABI50_0_0ReactTag)
{
  ABI50_0_0RNSVGPlatformView *view = [self getRenderableView:ABI50_0_0ReactTag];

  if (![view isKindOfClass:[ABI50_0_0RNSVGRenderable class]]) {
    ABI50_0_0RCTLogError(@"Invalid svg returned from registry, expecting ABI50_0_0RNSVGRenderable, got: %@", view);
    return [NSNumber numberWithDouble:0];
  }

  ABI50_0_0RNSVGPathMeasure *measure = [[ABI50_0_0RNSVGPathMeasure alloc] init];
  ABI50_0_0RNSVGRenderable *svg = (ABI50_0_0RNSVGRenderable *)view;
  CGPathRef target = [svg getPath:nil];
  [measure extractPathData:target];

  return [NSNumber numberWithDouble:measure.pathLength];
}

ABI50_0_0RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getPointAtLength
                                       : (nonnull NSNumber *)ABI50_0_0ReactTag options
                                       : (NSDictionary *)options)
{
  ABI50_0_0RNSVGPlatformView *view = [self getRenderableView:ABI50_0_0ReactTag];

  if (![view isKindOfClass:[ABI50_0_0RNSVGRenderable class]]) {
    ABI50_0_0RCTLogError(@"Invalid svg returned from registry, expecting ABI50_0_0RNSVGRenderable, got: %@", view);
    return nil;
  }

  CGFloat position = (CGFloat)[[options objectForKey:@"length"] doubleValue];
  ABI50_0_0RNSVGPathMeasure *measure = [[ABI50_0_0RNSVGPathMeasure alloc] init];
  ABI50_0_0RNSVGRenderable *svg = (ABI50_0_0RNSVGRenderable *)view;
  CGPathRef target = [svg getPath:nil];
  [measure extractPathData:target];

  CGFloat x;
  CGFloat y;
  CGFloat angle;
  double midPoint = fmax(0, fmin(position, measure.pathLength));
  [measure getPosAndTan:&angle midPoint:midPoint x:&x y:&y];

  return @{@"x" : @(x), @"y" : @(y), @"angle" : @(angle)};
}

ABI50_0_0RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getBBox : (nonnull NSNumber *)ABI50_0_0ReactTag options : (NSDictionary *)options)
{
  ABI50_0_0RNSVGPlatformView *view = [self getRenderableView:ABI50_0_0ReactTag];

  if (![view isKindOfClass:[ABI50_0_0RNSVGRenderable class]]) {
    ABI50_0_0RCTLogError(@"Invalid svg returned from registry, expecting ABI50_0_0RNSVGRenderable, got: %@", view);
    return nil;
  }

  ABI50_0_0RNSVGRenderable *svg = (ABI50_0_0RNSVGRenderable *)view;
  BOOL fill = [[options objectForKey:@"fill"] boolValue];
  BOOL stroke = [[options objectForKey:@"stroke"] boolValue];
  BOOL markers = [[options objectForKey:@"markers"] boolValue];
  BOOL clipped = [[options objectForKey:@"clipped"] boolValue];
  [svg getPath:nil];

  CGRect bounds = CGRectZero;
  if (fill) {
    bounds = CGRectUnion(bounds, svg.fillBounds);
  }
  if (stroke) {
    bounds = CGRectUnion(bounds, svg.strokeBounds);
  }
  if (markers) {
    bounds = CGRectUnion(bounds, svg.markerBounds);
  }
  if (clipped) {
    CGPathRef clipPath = [svg getClipPath];
    CGRect clipBounds = CGPathGetBoundingBox(clipPath);
    if (clipPath && !CGRectIsEmpty(clipBounds)) {
      bounds = CGRectIntersection(bounds, clipBounds);
    }
  }

  CGPoint origin = bounds.origin;
  CGSize size = bounds.size;
  return @{@"x" : @(origin.x), @"y" : @(origin.y), @"width" : @(size.width), @"height" : @(size.height)};
}

ABI50_0_0RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getCTM : (nonnull NSNumber *)ABI50_0_0ReactTag)
{
  ABI50_0_0RNSVGPlatformView *view = [self getRenderableView:ABI50_0_0ReactTag];

  if (![view isKindOfClass:[ABI50_0_0RNSVGRenderable class]]) {
    ABI50_0_0RCTLogError(@"Invalid svg returned from registry, expecting ABI50_0_0RNSVGRenderable, got: %@", view);
    return nil;
  }

  ABI50_0_0RNSVGRenderable *svg = (ABI50_0_0RNSVGRenderable *)view;
  CGAffineTransform ctm = svg.ctm;
  return @{@"a" : @(ctm.a), @"b" : @(ctm.b), @"c" : @(ctm.c), @"d" : @(ctm.d), @"e" : @(ctm.tx), @"f" : @(ctm.ty)};
}

ABI50_0_0RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getScreenCTM : (nonnull NSNumber *)ABI50_0_0ReactTag)
{
  ABI50_0_0RNSVGPlatformView *view = [self getRenderableView:ABI50_0_0ReactTag];

  if (![view isKindOfClass:[ABI50_0_0RNSVGRenderable class]]) {
    ABI50_0_0RCTLogError(@"Invalid svg returned from registry, expecting ABI50_0_0RNSVGRenderable, got: %@", view);
    return nil;
  }

  ABI50_0_0RNSVGRenderable *svg = (ABI50_0_0RNSVGRenderable *)view;
  CGAffineTransform ctm = svg.ctm;
  return @{@"a" : @(ctm.a), @"b" : @(ctm.b), @"c" : @(ctm.c), @"d" : @(ctm.d), @"e" : @(ctm.tx), @"f" : @(ctm.ty)};
}

- (void)getRawResource:(NSString *)name resolve:(ABI50_0_0RCTPromiseResolveBlock)resolve reject:(ABI50_0_0RCTPromiseRejectBlock)reject
{
}

- (ABI50_0_0RNSVGPlatformView *)getRenderableView:(NSNumber *)ABI50_0_0ReactTag
{
  __block ABI50_0_0RNSVGPlatformView *view;
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  dispatch_sync(dispatch_get_main_queue(), ^{
    view = [self.viewRegistry_DEPRECATED viewForABI50_0_0ReactTag:ABI50_0_0ReactTag];
  });
#else
  dispatch_sync(dispatch_get_main_queue(), ^{
    view = [self.bridge.uiManager viewForABI50_0_0ReactTag:ABI50_0_0ReactTag];
  });
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
  return view;
}

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule>)getTurboModule:
    (const ABI50_0_0facebook::ABI50_0_0React::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<ABI50_0_0facebook::ABI50_0_0React::NativeSvgRenderableModuleSpecJSI>(params);
}
#endif

@end
