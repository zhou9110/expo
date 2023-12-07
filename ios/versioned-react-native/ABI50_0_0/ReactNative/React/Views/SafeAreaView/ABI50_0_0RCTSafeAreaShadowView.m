/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTSafeAreaShadowView.h"

#import <ABI50_0_0React/ABI50_0_0RCTAssert.h>
#import <ABI50_0_0yoga/ABI50_0_0Yoga.h>

#import "ABI50_0_0RCTSafeAreaViewLocalData.h"

@implementation ABI50_0_0RCTSafeAreaShadowView

- (void)setLocalData:(ABI50_0_0RCTSafeAreaViewLocalData *)localData
{
  ABI50_0_0RCTAssert(
      [localData isKindOfClass:[ABI50_0_0RCTSafeAreaViewLocalData class]],
      @"Local data object for `ABI50_0_0RCTSafeAreaShadowView` must be `ABI50_0_0RCTSafeAreaViewLocalData` instance.");

  UIEdgeInsets insets = localData.insets;

  super.paddingLeft = (ABI50_0_0YGValue){insets.left, ABI50_0_0YGUnitPoint};
  super.paddingRight = (ABI50_0_0YGValue){insets.right, ABI50_0_0YGUnitPoint};
  super.paddingTop = (ABI50_0_0YGValue){insets.top, ABI50_0_0YGUnitPoint};
  super.paddingBottom = (ABI50_0_0YGValue){insets.bottom, ABI50_0_0YGUnitPoint};

  [self didSetProps:@[ @"paddingLeft", @"paddingRight", @"paddingTop", @"paddingBottom" ]];
}

/**
 * Removing support for setting padding from any outside code
 * to prevent interfering this with local data.
 */
- (void)setPadding:(__unused ABI50_0_0YGValue)value
{
}
- (void)setPaddingLeft:(__unused ABI50_0_0YGValue)value
{
}
- (void)setPaddingRight:(__unused ABI50_0_0YGValue)value
{
}
- (void)setPaddingTop:(__unused ABI50_0_0YGValue)value
{
}
- (void)setPaddingBottom:(__unused ABI50_0_0YGValue)value
{
}

@end
