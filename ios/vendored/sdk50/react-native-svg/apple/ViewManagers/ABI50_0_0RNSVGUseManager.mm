/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGUseManager.h"
#import "ABI50_0_0RNSVGUse.h"

@implementation ABI50_0_0RNSVGUseManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGNode *)node
{
  return [ABI50_0_0RNSVGUse new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(href, NSString)
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(x, id, ABI50_0_0RNSVGUse)
{
  view.x = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(y, id, ABI50_0_0RNSVGUse)
{
  view.y = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(height, id, ABI50_0_0RNSVGUse)
{
  view.useheight = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(width, id, ABI50_0_0RNSVGUse)
{
  view.usewidth = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}

@end
