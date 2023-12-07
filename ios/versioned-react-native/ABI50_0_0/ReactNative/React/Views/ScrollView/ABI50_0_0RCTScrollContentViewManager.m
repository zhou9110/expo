/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTScrollContentViewManager.h"

#import "ABI50_0_0RCTScrollContentShadowView.h"
#import "ABI50_0_0RCTScrollContentView.h"

@implementation ABI50_0_0RCTScrollContentViewManager

ABI50_0_0RCT_EXPORT_MODULE()

- (ABI50_0_0RCTScrollContentView *)view
{
  return [ABI50_0_0RCTScrollContentView new];
}

- (ABI50_0_0RCTShadowView *)shadowView
{
  return [ABI50_0_0RCTScrollContentShadowView new];
}

@end
