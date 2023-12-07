#import "ABI50_0_0RNCSafeAreaViewMode.h"
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>

@implementation ABI50_0_0RCTConvert (ABI50_0_0RNCSafeAreaView)

ABI50_0_0RCT_MULTI_ENUM_CONVERTER(
    ABI50_0_0RNCSafeAreaViewMode,
    (@{
      @"padding" : @(ABI50_0_0RNCSafeAreaViewModePadding),
      @"margin" : @(ABI50_0_0RNCSafeAreaViewModeMargin),
    }),
    ABI50_0_0RNCSafeAreaViewModePadding,
    integerValue);

@end
