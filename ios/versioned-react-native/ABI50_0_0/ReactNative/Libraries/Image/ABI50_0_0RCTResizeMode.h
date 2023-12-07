/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>

typedef NS_ENUM(NSInteger, ABI50_0_0RCTResizeMode) {
  ABI50_0_0RCTResizeModeCover = UIViewContentModeScaleAspectFill,
  ABI50_0_0RCTResizeModeContain = UIViewContentModeScaleAspectFit,
  ABI50_0_0RCTResizeModeStretch = UIViewContentModeScaleToFill,
  ABI50_0_0RCTResizeModeCenter = UIViewContentModeCenter,
  ABI50_0_0RCTResizeModeRepeat = -1, // Use negative values to avoid conflicts with iOS enum values.
};

@interface ABI50_0_0RCTConvert (ABI50_0_0RCTResizeMode)

+ (ABI50_0_0RCTResizeMode)ABI50_0_0RCTResizeMode:(id)json;

@end
