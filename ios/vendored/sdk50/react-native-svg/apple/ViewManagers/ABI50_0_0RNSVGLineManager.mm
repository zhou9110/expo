/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGLineManager.h"

#import "ABI50_0_0RCTConvert+RNSVG.h"
#import "ABI50_0_0RNSVGLine.h"

@implementation ABI50_0_0RNSVGLineManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGRenderable *)node
{
  return [ABI50_0_0RNSVGLine new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(x1, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(y1, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(x2, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(y2, ABI50_0_0RNSVGLength *)

@end
