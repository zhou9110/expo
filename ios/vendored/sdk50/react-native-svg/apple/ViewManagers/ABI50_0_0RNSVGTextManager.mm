/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGTextManager.h"

#import "ABI50_0_0RCTConvert+RNSVG.h"
#import "ABI50_0_0RNSVGText.h"

@implementation ABI50_0_0RNSVGTextManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RNSVGRenderable *)node
{
  return [ABI50_0_0RNSVGText new];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(dx, id, ABI50_0_0RNSVGText)
{
  view.deltaX = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLengthArray:json];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(dy, id, ABI50_0_0RNSVGText)
{
  view.deltaY = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLengthArray:json];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(x, id, ABI50_0_0RNSVGText)
{
  view.positionX = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLengthArray:json];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(y, id, ABI50_0_0RNSVGText)
{
  view.positionY = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLengthArray:json];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(rotate, id, ABI50_0_0RNSVGText)
{
  view.rotate = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLengthArray:json];
}
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(font, NSDictionary)
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(inlineSize, id, ABI50_0_0RNSVGText)
{
  view.inlineSize = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(textLength, id, ABI50_0_0RNSVGText)
{
  view.textLength = [ABI50_0_0RCTConvert ABI50_0_0RNSVGLength:json];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(baselineShift, id, ABI50_0_0RNSVGText)
{
  if ([json isKindOfClass:[NSString class]]) {
    NSString *stringValue = (NSString *)json;
    view.baselineShift = stringValue;
  } else {
    view.baselineShift = [NSString stringWithFormat:@"%f", [json doubleValue]];
  }
}
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(lengthAdjust, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(alignmentBaseline, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(verticalAlign, NSString) // unused on iOS

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(fontSize, id, ABI50_0_0RNSVGText)
{
  if ([json isKindOfClass:[NSString class]]) {
    NSString *stringValue = (NSString *)json;
    view.font = @{@"fontSize" : stringValue};
  } else {
    NSNumber *number = (NSNumber *)json;
    double num = [number doubleValue];
    view.font = @{@"fontSize" : [NSNumber numberWithDouble:num]};
  }
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(fontWeight, id, ABI50_0_0RNSVGText)
{
  if ([json isKindOfClass:[NSString class]]) {
    NSString *stringValue = (NSString *)json;
    view.font = @{@"fontWeight" : stringValue};
  } else {
    NSNumber *number = (NSNumber *)json;
    double num = [number doubleValue];
    view.font = @{@"fontWeight" : [NSNumber numberWithDouble:num]};
  }
}

@end
