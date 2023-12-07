// Copyright © 2018 650 Industries. All rights reserved.

#import "ABI50_0_0EXScopedReactNativeAdapter.h"
#import "ABI50_0_0EXUnversioned.h"

@interface ABI50_0_0EXReactNativeAdapter (Protected)

- (void)startObserving;

@end

@implementation ABI50_0_0EXScopedReactNativeAdapter

- (void)setBridge:(ABI50_0_0RCTBridge *)bridge
{
  if (bridge) {
    [super setBridge:bridge];
    [self setAppStateToForeground];
  }
}

- (void)startObserving
{
  // ABI50_0_0EXAppState and ABI50_0_0EXKernel handle this for us
}

@end
