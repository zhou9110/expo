/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>

typedef NS_ENUM(NSInteger, ABI50_0_0RCTDynamicTypeRamp) {
  ABI50_0_0RCTDynamicTypeRampUndefined,
  ABI50_0_0RCTDynamicTypeRampCaption2,
  ABI50_0_0RCTDynamicTypeRampCaption1,
  ABI50_0_0RCTDynamicTypeRampFootnote,
  ABI50_0_0RCTDynamicTypeRampSubheadline,
  ABI50_0_0RCTDynamicTypeRampCallout,
  ABI50_0_0RCTDynamicTypeRampBody,
  ABI50_0_0RCTDynamicTypeRampHeadline,
  ABI50_0_0RCTDynamicTypeRampTitle3,
  ABI50_0_0RCTDynamicTypeRampTitle2,
  ABI50_0_0RCTDynamicTypeRampTitle1,
  ABI50_0_0RCTDynamicTypeRampLargeTitle
};

@interface ABI50_0_0RCTConvert (DynamicTypeRamp)

+ (ABI50_0_0RCTDynamicTypeRamp)ABI50_0_0RCTDynamicTypeRamp:(nullable id)json;

@end

/// Generates a `UIFontMetrics` instance representing a particular Dynamic Type ramp.
UIFontMetrics *_Nonnull ABI50_0_0RCTUIFontMetricsForDynamicTypeRamp(ABI50_0_0RCTDynamicTypeRamp dynamicTypeRamp);
/// The "reference" size for a particular font scale ramp, equal to a text element's size under default text size
/// settings.
CGFloat ABI50_0_0RCTBaseSizeForDynamicTypeRamp(ABI50_0_0RCTDynamicTypeRamp dynamicTypeRamp);
