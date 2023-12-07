/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGMaskManager.h"
#import "ABI50_0_0RNSVGMask.h"

@implementation ABI50_0_0RNSVGMaskManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGMask *)node
{
  return [ABI50_0_0RNSVGMask new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(x, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(y, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(height, id, ABI50_0_0RNSVGMask)
{
  view.maskheight = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(width, id, ABI50_0_0RNSVGMask)
{
  view.maskwidth = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(maskUnits, ABI50_0_0RNSVGUnits)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(maskContentUnits, ABI50_0_0RNSVGUnits)

@end
