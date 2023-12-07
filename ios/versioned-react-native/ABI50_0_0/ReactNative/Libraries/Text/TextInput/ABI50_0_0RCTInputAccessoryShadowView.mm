/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTInputAccessoryShadowView.h>

#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>

@implementation ABI50_0_0RCTInputAccessoryShadowView

- (void)insertABI50_0_0ReactSubview:(ABI50_0_0RCTShadowView *)subview atIndex:(NSInteger)atIndex
{
  [super insertABI50_0_0ReactSubview:subview atIndex:atIndex];
  subview.width = (ABI50_0_0YGValue){static_cast<float>(ABI50_0_0RCTScreenSize().width), ABI50_0_0YGUnitPoint};
}

@end
