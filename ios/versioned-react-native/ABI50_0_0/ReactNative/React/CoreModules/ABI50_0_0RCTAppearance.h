/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventEmitter.h>

ABI50_0_0RCT_EXTERN void ABI50_0_0RCTEnableAppearancePreference(BOOL enabled);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTOverrideAppearancePreference(NSString *const);
ABI50_0_0RCT_EXTERN NSString *ABI50_0_0RCTCurrentOverrideAppearancePreference();
ABI50_0_0RCT_EXTERN NSString *ABI50_0_0RCTColorSchemePreference(UITraitCollection *traitCollection);

@interface ABI50_0_0RCTAppearance : ABI50_0_0RCTEventEmitter <ABI50_0_0RCTBridgeModule>
- (instancetype)init;
@end
