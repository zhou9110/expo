/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGSvgViewManager.h"
#import "ABI50_0_0RNSVGSvgView.h"

@implementation ABI50_0_0RNSVGSvgViewManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGView *)view
{
  return [ABI50_0_0RNSVGSvgView new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(bbWidth, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(bbHeight, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(minX, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(minY, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(vbWidth, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(vbHeight, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(align, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(meetOrSlice, ABI50_0_0RNSVGVBMOS)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(tintColor, UIColor)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(color, tintColor, UIColor)

@end
