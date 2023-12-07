/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTView.h>

NS_ASSUME_NONNULL_BEGIN

@class ABI50_0_0RCTBridge;

@interface ABI50_0_0RCTSafeAreaView : ABI50_0_0RCTView

- (instancetype)initWithBridge:(ABI50_0_0RCTBridge *)bridge;

@end

NS_ASSUME_NONNULL_END
