// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0React/ABI50_0_0RCTBridgeDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0EXRCTBridgeDelegateInterceptor : NSObject<ABI50_0_0RCTBridgeDelegate>

@property (nonatomic, weak) id<ABI50_0_0RCTBridgeDelegate> bridgeDelegate;
@property (nonatomic, weak) id<ABI50_0_0RCTBridgeDelegate> interceptor;

- (instancetype)initWithBridgeDelegate:(id<ABI50_0_0RCTBridgeDelegate>)bridgeDelegate interceptor:(id<ABI50_0_0RCTBridgeDelegate>)interceptor;

@end

NS_ASSUME_NONNULL_END
