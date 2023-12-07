/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGRenderableManager.h"
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManagerUtils.h>
#import "ABI50_0_0RNSVGPathMeasure.h"

#import "ABI50_0_0RCTConvert+RNSVG.h"
#import "ABI50_0_0RNSVGCGFCRule.h"

@implementation ABI50_0_0RNSVGRenderableManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGRenderable *)node
{
  return [ABI50_0_0RNSVGRenderable new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(fill, ABI50_0_0RNSVGBrush)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(fillOpacity, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(fillRule, ABI50_0_0RNSVGCGFCRule)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(stroke, ABI50_0_0RNSVGBrush)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeOpacity, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeWidth, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeLinecap, CGLineCap)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeLinejoin, CGLineJoin)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeDasharray, NSArray<ABI50_0_0RNSVGLength *>)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeDashoffset, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeMiterlimit, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(vectorEffect, int)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(propList, NSArray<NSString *>)

@end
