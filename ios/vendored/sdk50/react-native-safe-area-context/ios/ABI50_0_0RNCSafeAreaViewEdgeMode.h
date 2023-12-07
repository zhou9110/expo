#import <Foundation/Foundation.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>

typedef NS_ENUM(NSInteger, ABI50_0_0RNCSafeAreaViewEdgeMode) {
  ABI50_0_0RNCSafeAreaViewEdgeModeOff,
  ABI50_0_0RNCSafeAreaViewEdgeModeAdditive,
  ABI50_0_0RNCSafeAreaViewEdgeModeMaximum
};

@interface ABI50_0_0RCTConvert (ABI50_0_0RNCSafeAreaViewEdgeMode)
+ (ABI50_0_0RNCSafeAreaViewEdgeMode)ABI50_0_0RNCSafeAreaViewEdgeMode:(nullable id)json;
@end
