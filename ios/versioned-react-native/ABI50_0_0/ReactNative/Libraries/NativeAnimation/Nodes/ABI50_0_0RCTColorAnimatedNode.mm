/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTColorAnimatedNode.h>
#import <ABI50_0_0React/ABI50_0_0RCTValueAnimatedNode.h>

#import <ABI50_0_0React/ABI50_0_0RCTAnimationUtils.h>

@implementation ABI50_0_0RCTColorAnimatedNode

- (void)performUpdate
{
  [super performUpdate];

  ABI50_0_0RCTValueAnimatedNode *rNode = (ABI50_0_0RCTValueAnimatedNode *)[self.parentNodes objectForKey:self.config[@"r"]];
  ABI50_0_0RCTValueAnimatedNode *gNode = (ABI50_0_0RCTValueAnimatedNode *)[self.parentNodes objectForKey:self.config[@"g"]];
  ABI50_0_0RCTValueAnimatedNode *bNode = (ABI50_0_0RCTValueAnimatedNode *)[self.parentNodes objectForKey:self.config[@"b"]];
  ABI50_0_0RCTValueAnimatedNode *aNode = (ABI50_0_0RCTValueAnimatedNode *)[self.parentNodes objectForKey:self.config[@"a"]];

  _color = ABI50_0_0RCTColorFromComponents(rNode.value, gNode.value, bNode.value, aNode.value);

  // TODO (T111179606): Support platform colors for color animations
}

@end
