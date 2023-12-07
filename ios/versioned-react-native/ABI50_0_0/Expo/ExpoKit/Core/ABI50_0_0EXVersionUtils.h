// Copyright 2023-present 650 Industries. All rights reserved.

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>

@interface ABI50_0_0EXVersionUtils : NSObject

+ (nonnull void *)versionedJsExecutorFactoryForBridge:(nonnull ABI50_0_0RCTBridge *)bridge
                                               engine:(nonnull NSString *)jsEngine;

@end
