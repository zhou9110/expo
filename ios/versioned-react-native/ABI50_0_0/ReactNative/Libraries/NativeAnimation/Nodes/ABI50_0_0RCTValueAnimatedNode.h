/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import "ABI50_0_0RCTAnimatedNode.h"

@class ABI50_0_0RCTValueAnimatedNode;

@protocol ABI50_0_0RCTValueAnimatedNodeObserver <NSObject>

- (void)animatedNode:(ABI50_0_0RCTValueAnimatedNode *)node didUpdateValue:(CGFloat)value;

@end

@interface ABI50_0_0RCTValueAnimatedNode : ABI50_0_0RCTAnimatedNode

- (void)setOffset:(CGFloat)offset;
- (void)flattenOffset;
- (void)extractOffset;

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, strong, readonly) id animatedObject;
@property (nonatomic, weak) id<ABI50_0_0RCTValueAnimatedNodeObserver> valueObserver;

@end
