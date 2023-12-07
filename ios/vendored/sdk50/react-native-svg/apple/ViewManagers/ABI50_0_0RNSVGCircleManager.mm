/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGCircleManager.h"

#import "ABI50_0_0RCTConvert+RNSVG.h"
#import "ABI50_0_0RNSVGCircle.h"

@implementation ABI50_0_0RNSVGCircleManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGRenderable *)node
{
  return [ABI50_0_0RNSVGCircle new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(cx, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(cy, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(r, ABI50_0_0RNSVGLength *)

@end
