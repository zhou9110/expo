/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTRawTextViewManager.h>

#import <ABI50_0_0React/ABI50_0_0RCTRawTextShadowView.h>

@implementation ABI50_0_0RCTRawTextViewManager

ABI50_0_0RCT_EXPORT_MODULE(ABI50_0_0RCTRawText)

- (UIView *)view
{
  return [UIView new];
}

- (ABI50_0_0RCTShadowView *)shadowView
{
  return [ABI50_0_0RCTRawTextShadowView new];
}

ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(text, NSString)

@end
