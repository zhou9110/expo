/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTInvalidating.h>

typedef NS_ENUM(NSInteger, ABI50_0_0RCTAlertViewStyle) {
  ABI50_0_0RCTAlertViewStyleDefault = 0,
  ABI50_0_0RCTAlertViewStyleSecureTextInput,
  ABI50_0_0RCTAlertViewStylePlainTextInput,
  ABI50_0_0RCTAlertViewStyleLoginAndPasswordInput
};

@interface ABI50_0_0RCTAlertManager : NSObject <ABI50_0_0RCTBridgeModule, ABI50_0_0RCTInvalidating>

@end
