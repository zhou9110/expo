/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import "ABI50_0_0RCTConvert+RNSVG.h"
#import "ABI50_0_0RNSVGCGFCRule.h"
#import "ABI50_0_0RNSVGLength.h"
#import "ABI50_0_0RNSVGPathParser.h"
#import "ABI50_0_0RNSVGUnits.h"
#import "ABI50_0_0RNSVGVBMOS.h"

@class ABI50_0_0RNSVGBrush;

@interface ABI50_0_0RCTConvert (ABI50_0_0RNSVG)

+ (ABI50_0_0RNSVGLength *)ABI50_0_0RNSVGLength:(id)json;
+ (NSArray<ABI50_0_0RNSVGLength *> *)ABI50_0_0RNSVGLengthArray:(id)json;
+ (ABI50_0_0RNSVGCGFCRule)ABI50_0_0RNSVGCGFCRule:(id)json;
+ (ABI50_0_0RNSVGVBMOS)ABI50_0_0RNSVGVBMOS:(id)json;
+ (ABI50_0_0RNSVGUnits)ABI50_0_0RNSVGUnits:(id)json;
+ (ABI50_0_0RNSVGBrush *)ABI50_0_0RNSVGBrush:(id)json;
+ (ABI50_0_0RNSVGPathParser *)ABI50_0_0RNSVGCGPath:(NSString *)d;
+ (CGRect)ABI50_0_0RNSVGCGRect:(id)json offset:(NSUInteger)offset;
+ (ABI50_0_0RNSVGColor *)ABI50_0_0RNSVGColor:(id)json offset:(NSUInteger)offset;
+ (CGGradientRef)ABI50_0_0RNSVGCGGradient:(id)json;

@end
