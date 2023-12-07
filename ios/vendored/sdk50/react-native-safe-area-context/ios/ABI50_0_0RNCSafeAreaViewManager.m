#import "ABI50_0_0RNCSafeAreaViewManager.h"

#import "ABI50_0_0RNCSafeAreaShadowView.h"
#import "ABI50_0_0RNCSafeAreaView.h"
#import "ABI50_0_0RNCSafeAreaViewEdges.h"
#import "ABI50_0_0RNCSafeAreaViewMode.h"

@implementation ABI50_0_0RNCSafeAreaViewManager

ABI50_0_0RCT_EXPORT_MODULE(ABI50_0_0RNCSafeAreaView)

- (UIView *)view
{
  return [[ABI50_0_0RNCSafeAreaView alloc] initWithBridge:self.bridge];
}

- (ABI50_0_0RNCSafeAreaShadowView *)shadowView
{
  return [ABI50_0_0RNCSafeAreaShadowView new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(mode, ABI50_0_0RNCSafeAreaViewMode)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(edges, ABI50_0_0RNCSafeAreaViewEdges)

@end
