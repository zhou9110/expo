/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTHost.h"

#import "ABI50_0_0RCTContextContainerHandling.h"

typedef NSURL * (^ABI50_0_0RCTHostBundleURLProvider)(void);

@interface ABI50_0_0RCTHost (Internal)

- (void)registerSegmentWithId:(NSNumber *)segmentId path:(NSString *)path;
- (void)setBundleURLProvider:(ABI50_0_0RCTHostBundleURLProvider)bundleURLProvider;
- (void)setContextContainerHandler:(id<ABI50_0_0RCTContextContainerHandling>)contextContainerHandler;

@end
