/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>
#import <ABI50_0_0React/ABI50_0_0RCTInspectorPackagerConnection.h>

#if ABI50_0_0RCT_DEV || ABI50_0_0RCT_REMOTE_PROFILE

@interface ABI50_0_0RCTInspectorDevServerHelper : NSObject

+ (ABI50_0_0RCTInspectorPackagerConnection *)connectWithBundleURL:(NSURL *)bundleURL;
+ (void)disableDebugger;
+ (void)openDebugger:(NSURL *)bundleURL withErrorMessage:(NSString *)errorMessage;
@end

#endif
