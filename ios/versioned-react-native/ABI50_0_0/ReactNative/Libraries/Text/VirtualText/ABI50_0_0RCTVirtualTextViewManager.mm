/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTVirtualTextShadowView.h>
#import <ABI50_0_0React/ABI50_0_0RCTVirtualTextView.h>
#import <ABI50_0_0React/ABI50_0_0RCTVirtualTextViewManager.h>

@implementation ABI50_0_0RCTVirtualTextViewManager

ABI50_0_0RCT_EXPORT_MODULE(ABI50_0_0RCTVirtualText)

- (UIView *)view
{
  return [ABI50_0_0RCTVirtualTextView new];
}

- (ABI50_0_0RCTShadowView *)shadowView
{
  return [ABI50_0_0RCTVirtualTextShadowView new];
}

@end
