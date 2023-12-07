/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGMarkerManager.h"
#import "ABI50_0_0RNSVGMarker.h"

@implementation ABI50_0_0RNSVGMarkerManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGMarker *)node
{
  return [ABI50_0_0RNSVGMarker new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(refX, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(refY, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(markerHeight, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(markerWidth, ABI50_0_0RNSVGLength *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(markerUnits, NSString *)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(orient, NSString *)

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(minX, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(minY, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(vbWidth, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(vbHeight, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(align, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(meetOrSlice, ABI50_0_0RNSVGVBMOS)

@end
