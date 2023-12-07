/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGForeignObjectManager.h"
#import "ABI50_0_0RNSVGForeignObject.h"

@implementation ABI50_0_0RNSVGForeignObjectManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGForeignObject *)node
{
  return [ABI50_0_0RNSVGForeignObject new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(x, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(y, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(height, id, ABI50_0_0RNSVGForeignObject)
{
  view.foreignObjectheight = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(width, id, ABI50_0_0RNSVGForeignObject)
{
  view.foreignObjectwidth = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}

@end
