/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>
#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>

#if ABI50_0_0RCT_DEV || ABI50_0_0RCT_REMOTE_PROFILE

@class ABI50_0_0RCTInspectorRemoteConnection;

@interface ABI50_0_0RCTInspectorLocalConnection : NSObject
- (void)sendMessage:(NSString *)message;
- (void)disconnect;
@end

@interface ABI50_0_0RCTInspectorPage : NSObject
@property (nonatomic, readonly) NSInteger id;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *vm;
@end

@interface ABI50_0_0RCTInspector : NSObject
+ (NSArray<ABI50_0_0RCTInspectorPage *> *)pages;
+ (ABI50_0_0RCTInspectorLocalConnection *)connectPage:(NSInteger)pageId
                         forRemoteConnection:(ABI50_0_0RCTInspectorRemoteConnection *)remote;
@end

#endif
