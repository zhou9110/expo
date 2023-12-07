/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGPathManager.h"

#import "ABI50_0_0RCTConvert+RNSVG.h"
#import "ABI50_0_0RNSVGPath.h"

@implementation ABI50_0_0RNSVGPathManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGRenderable *)node
{
  return [ABI50_0_0RNSVGPath new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(d, ABI50_0_0RNSVGCGPath)

@end
