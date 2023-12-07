/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTResizeMode.h>

@implementation ABI50_0_0RCTConvert (ABI50_0_0RCTResizeMode)

ABI50_0_0RCT_ENUM_CONVERTER(
    ABI50_0_0RCTResizeMode,
    (@{
      @"cover" : @(ABI50_0_0RCTResizeModeCover),
      @"contain" : @(ABI50_0_0RCTResizeModeContain),
      @"stretch" : @(ABI50_0_0RCTResizeModeStretch),
      @"center" : @(ABI50_0_0RCTResizeModeCenter),
      @"repeat" : @(ABI50_0_0RCTResizeModeRepeat),
    }),
    ABI50_0_0RCTResizeModeStretch,
    integerValue)

@end
