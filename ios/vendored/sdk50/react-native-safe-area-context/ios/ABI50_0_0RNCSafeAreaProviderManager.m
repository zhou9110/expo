#import "ABI50_0_0RNCSafeAreaProviderManager.h"

#import "ABI50_0_0RNCSafeAreaProvider.h"

@implementation ABI50_0_0RNCSafeAreaProviderManager

ABI50_0_0RCT_EXPORT_MODULE(ABI50_0_0RNCSafeAreaProvider)

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onInsetsChange, ABI50_0_0RCTDirectEventBlock)

- (UIView *)view
{
  return [ABI50_0_0RNCSafeAreaProvider new];
}

@end
