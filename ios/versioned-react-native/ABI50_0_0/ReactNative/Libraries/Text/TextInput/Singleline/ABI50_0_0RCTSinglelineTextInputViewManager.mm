/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTSinglelineTextInputViewManager.h>

#import <ABI50_0_0React/ABI50_0_0RCTBaseTextInputShadowView.h>
#import <ABI50_0_0React/ABI50_0_0RCTSinglelineTextInputView.h>

@implementation ABI50_0_0RCTSinglelineTextInputViewManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RCTShadowView *)shadowView
{
  ABI50_0_0RCTBaseTextInputShadowView *shadowView = (ABI50_0_0RCTBaseTextInputShadowView *)[super shadowView];

  shadowView.maximumNumberOfLines = 1;

  return shadowView;
}

- (UIView *)view
{
  return [[ABI50_0_0RCTSinglelineTextInputView alloc] initWithBridge:self.bridge];
}

@end
