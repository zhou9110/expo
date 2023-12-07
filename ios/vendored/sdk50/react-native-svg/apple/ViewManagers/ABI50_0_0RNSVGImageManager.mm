/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGImageManager.h"
#import "ABI50_0_0RCTConvert+RNSVG.h"
#import "ABI50_0_0RNSVGImage.h"
#import "ABI50_0_0RNSVGVBMOS.h"

@implementation ABI50_0_0RNSVGImageManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGRenderable *)node
{
  ABI50_0_0RNSVGImage *svgImage = [ABI50_0_0RNSVGImage new];
  svgImage.bridge = self.bridge;

  return svgImage;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(x, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(y, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(width, id, ABI50_0_0RNSVGImage)
{
  view.imagewidth = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(height, id, ABI50_0_0RNSVGImage)
{
  view.imageheight = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(src, ABI50_0_0RCTImageSource)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(align, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(meetOrSlice, ABI50_0_0RNSVGVBMOS)

@end
