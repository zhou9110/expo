/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTValueAnimatedNode.h"

#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>

NS_ASSUME_NONNULL_BEGIN

ABI50_0_0RCT_EXTERN NSString *ABI50_0_0RCTInterpolateString(
    NSString *pattern,
    CGFloat inputValue,
    NSArray<NSNumber *> *inputRange,
    NSArray<NSArray<NSNumber *> *> *outputRange,
    NSString *extrapolateLeft,
    NSString *extrapolateRight);

@interface ABI50_0_0RCTInterpolationAnimatedNode : ABI50_0_0RCTValueAnimatedNode

@end

NS_ASSUME_NONNULL_END
