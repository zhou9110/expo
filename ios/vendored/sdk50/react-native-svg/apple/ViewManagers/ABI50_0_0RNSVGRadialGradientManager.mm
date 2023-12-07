/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGRadialGradientManager.h"
#import "ABI50_0_0RNSVGRadialGradient.h"

@implementation ABI50_0_0RNSVGRadialGradientManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGNode *)node
{
  return [ABI50_0_0RNSVGRadialGradient new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(fx, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(fy, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(cx, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(cy, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(rx, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(ry, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(gradient, NSArray<NSNumber *>)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(gradientUnits, ABI50_0_0RNSVGUnits)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(gradientTransform, CGAffineTransform)

@end
