/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGRectManager.h"

#import "ABI50_0_0RCTConvert+RNSVG.h"
#import "ABI50_0_0RNSVGRect.h"

@implementation ABI50_0_0RNSVGRectManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGRenderable *)node
{
  return [ABI50_0_0RNSVGRect new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(x, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(y, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(height, id, ABI50_0_0RNSVGRect)
{
  view.rectheight = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(width, id, ABI50_0_0RNSVGRect)
{
  view.rectwidth = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(rx, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(ry, ABI50_0_0RNSVGLength *)

@end
