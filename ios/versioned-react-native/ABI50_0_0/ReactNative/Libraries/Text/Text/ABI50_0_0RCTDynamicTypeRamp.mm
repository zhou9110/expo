/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTDynamicTypeRamp.h>

@implementation ABI50_0_0RCTConvert (DynamicTypeRamp)

ABI50_0_0RCT_ENUM_CONVERTER(
    ABI50_0_0RCTDynamicTypeRamp,
    (@{
      @"caption2" : @(ABI50_0_0RCTDynamicTypeRampCaption2),
      @"caption1" : @(ABI50_0_0RCTDynamicTypeRampCaption1),
      @"footnote" : @(ABI50_0_0RCTDynamicTypeRampFootnote),
      @"subheadline" : @(ABI50_0_0RCTDynamicTypeRampSubheadline),
      @"callout" : @(ABI50_0_0RCTDynamicTypeRampCallout),
      @"body" : @(ABI50_0_0RCTDynamicTypeRampBody),
      @"headline" : @(ABI50_0_0RCTDynamicTypeRampHeadline),
      @"title3" : @(ABI50_0_0RCTDynamicTypeRampTitle3),
      @"title2" : @(ABI50_0_0RCTDynamicTypeRampTitle2),
      @"title1" : @(ABI50_0_0RCTDynamicTypeRampTitle1),
      @"largeTitle" : @(ABI50_0_0RCTDynamicTypeRampLargeTitle),
    }),
    ABI50_0_0RCTDynamicTypeRampUndefined,
    integerValue)

@end

UIFontMetrics *ABI50_0_0RCTUIFontMetricsForDynamicTypeRamp(ABI50_0_0RCTDynamicTypeRamp dynamicTypeRamp)
{
  static NSDictionary<NSNumber *, UIFontTextStyle> *mapping;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    mapping = @{
      @(ABI50_0_0RCTDynamicTypeRampCaption2) : UIFontTextStyleCaption2,
      @(ABI50_0_0RCTDynamicTypeRampCaption1) : UIFontTextStyleCaption1,
      @(ABI50_0_0RCTDynamicTypeRampFootnote) : UIFontTextStyleFootnote,
      @(ABI50_0_0RCTDynamicTypeRampSubheadline) : UIFontTextStyleSubheadline,
      @(ABI50_0_0RCTDynamicTypeRampCallout) : UIFontTextStyleCallout,
      @(ABI50_0_0RCTDynamicTypeRampBody) : UIFontTextStyleBody,
      @(ABI50_0_0RCTDynamicTypeRampHeadline) : UIFontTextStyleHeadline,
      @(ABI50_0_0RCTDynamicTypeRampTitle3) : UIFontTextStyleTitle3,
      @(ABI50_0_0RCTDynamicTypeRampTitle2) : UIFontTextStyleTitle2,
      @(ABI50_0_0RCTDynamicTypeRampTitle1) : UIFontTextStyleTitle1,
      @(ABI50_0_0RCTDynamicTypeRampLargeTitle) : UIFontTextStyleLargeTitle,
    };
  });

  id textStyle =
      mapping[@(dynamicTypeRamp)] ?: UIFontTextStyleBody; // Default to body if we don't recognize the specified ramp
  return [UIFontMetrics metricsForTextStyle:textStyle];
}

CGFloat ABI50_0_0RCTBaseSizeForDynamicTypeRamp(ABI50_0_0RCTDynamicTypeRamp dynamicTypeRamp)
{
  static NSDictionary<NSNumber *, NSNumber *> *mapping;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    // Values taken from
    // https://developer.apple.com/design/human-interface-guidelines/foundations/typography/#specifications
    mapping = @{
      @(ABI50_0_0RCTDynamicTypeRampCaption2) : @11,
      @(ABI50_0_0RCTDynamicTypeRampCaption1) : @12,
      @(ABI50_0_0RCTDynamicTypeRampFootnote) : @13,
      @(ABI50_0_0RCTDynamicTypeRampSubheadline) : @15,
      @(ABI50_0_0RCTDynamicTypeRampCallout) : @16,
      @(ABI50_0_0RCTDynamicTypeRampBody) : @17,
      @(ABI50_0_0RCTDynamicTypeRampHeadline) : @17,
      @(ABI50_0_0RCTDynamicTypeRampTitle3) : @20,
      @(ABI50_0_0RCTDynamicTypeRampTitle2) : @22,
      @(ABI50_0_0RCTDynamicTypeRampTitle1) : @28,
      @(ABI50_0_0RCTDynamicTypeRampLargeTitle) : @34,
    };
  });

  NSNumber *baseSize =
      mapping[@(dynamicTypeRamp)] ?: @17; // Default to body size if we don't recognize the specified ramp
  return CGFLOAT_IS_DOUBLE ? [baseSize doubleValue] : [baseSize floatValue];
}
