/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>
#import <ABI50_0_0React/renderer/components/view/ABI50_0_0TouchEventEmitter.h>

@protocol ABI50_0_0RCTTouchableComponentViewProtocol <NSObject>
- (ABI50_0_0facebook::ABI50_0_0React::SharedTouchEventEmitter)touchEventEmitterAtPoint:(CGPoint)point;
@end
