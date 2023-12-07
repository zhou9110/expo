/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

#import <ABI50_0_0React/ABI50_0_0RCTMessageThread.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0RCTJSThreadManager : NSObject

- (void)dispatchToJSThread:(dispatch_block_t)block;
- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::ABI50_0_0RCTMessageThread>)jsMessageThread;

@end

NS_ASSUME_NONNULL_END
