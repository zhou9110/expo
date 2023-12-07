#import "ABI50_0_0RNCSafeAreaViewEdgeMode.h"
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>

@implementation ABI50_0_0RCTConvert (ABI50_0_0RNCSafeAreaViewEdgeMode)

ABI50_0_0RCT_ENUM_CONVERTER(
    ABI50_0_0RNCSafeAreaViewEdgeMode,
    (@{
      @"off" : @(ABI50_0_0RNCSafeAreaViewEdgeModeOff),
      @"additive" : @(ABI50_0_0RNCSafeAreaViewEdgeModeAdditive),
      @"maximum" : @(ABI50_0_0RNCSafeAreaViewEdgeModeMaximum),
    }),
    ABI50_0_0RNCSafeAreaViewEdgeModeOff,
    integerValue);

@end
