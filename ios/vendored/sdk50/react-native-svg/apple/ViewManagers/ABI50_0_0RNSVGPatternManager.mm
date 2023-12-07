/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGPatternManager.h"
#import "ABI50_0_0RNSVGPattern.h"

@implementation ABI50_0_0RNSVGPatternManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGPattern *)node
{
  return [ABI50_0_0RNSVGPattern new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(x, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(y, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(height, id, ABI50_0_0RNSVGPattern)
{
  view.patternheight = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(width, id, ABI50_0_0RNSVGPattern)
{
  view.patternwidth = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(patternUnits, ABI50_0_0RNSVGUnits)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(patternContentUnits, ABI50_0_0RNSVGUnits)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(patternTransform, CGAffineTransform)

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(minX, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(minY, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(vbWidth, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(vbHeight, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(align, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(meetOrSlice, ABI50_0_0RNSVGVBMOS)

@end
