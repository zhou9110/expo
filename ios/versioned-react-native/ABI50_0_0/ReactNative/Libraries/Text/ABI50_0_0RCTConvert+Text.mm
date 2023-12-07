/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTConvert+Text.h>

@implementation ABI50_0_0RCTConvert (Text)

+ (UITextAutocorrectionType)UITextAutocorrectionType:(id)json
{
  return json == nil           ? UITextAutocorrectionTypeDefault
      : [ABI50_0_0RCTConvert BOOL:json] ? UITextAutocorrectionTypeYes
                               : UITextAutocorrectionTypeNo;
}

+ (UITextSpellCheckingType)UITextSpellCheckingType:(id)json
{
  return json == nil           ? UITextSpellCheckingTypeDefault
      : [ABI50_0_0RCTConvert BOOL:json] ? UITextSpellCheckingTypeYes
                               : UITextSpellCheckingTypeNo;
}

ABI50_0_0RCT_ENUM_CONVERTER(
    ABI50_0_0RCTTextTransform,
    (@{
      @"none" : @(ABI50_0_0RCTTextTransformNone),
      @"capitalize" : @(ABI50_0_0RCTTextTransformCapitalize),
      @"uppercase" : @(ABI50_0_0RCTTextTransformUppercase),
      @"lowercase" : @(ABI50_0_0RCTTextTransformLowercase),
    }),
    ABI50_0_0RCTTextTransformUndefined,
    integerValue)

+ (UITextSmartInsertDeleteType)UITextSmartInsertDeleteType:(id)json
{
  return json == nil           ? UITextSmartInsertDeleteTypeDefault
      : [ABI50_0_0RCTConvert BOOL:json] ? UITextSmartInsertDeleteTypeYes
                               : UITextSmartInsertDeleteTypeNo;
}

@end
