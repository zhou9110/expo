#pragma once

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>

#import <ABI50_0_0RNSkManager.h>

@interface ABI50_0_0SkiaManager : NSObject

- (std::shared_ptr<ABI50_0_0RNSkia::ABI50_0_0RNSkManager>)skManager;

- (instancetype)init NS_UNAVAILABLE;

- (void)invalidate;

- (instancetype)initWithBridge:(ABI50_0_0RCTBridge *)bridge;

@end
