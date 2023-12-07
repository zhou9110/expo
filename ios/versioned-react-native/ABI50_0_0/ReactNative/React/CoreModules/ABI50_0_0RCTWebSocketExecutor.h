/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>
#import <ABI50_0_0React/ABI50_0_0RCTJavaScriptExecutor.h>

#if ABI50_0_0RCT_DEV // Debug executors are only supported in dev mode

@interface ABI50_0_0RCTWebSocketExecutor : NSObject <ABI50_0_0RCTJavaScriptExecutor>

- (instancetype)initWithURL:(NSURL *)URL;

@end

#endif
