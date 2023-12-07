#import "ABI50_0_0RNGestureHandlerButtonManager.h"
#import "ABI50_0_0RNGestureHandlerButton.h"

@implementation ABI50_0_0RNGestureHandlerButtonManager

ABI50_0_0RCT_EXPORT_MODULE(ABI50_0_0RNGestureHandlerButton)

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(enabled, BOOL, ABI50_0_0RNGestureHandlerButton)
{
  view.userEnabled = json == nil ? YES : [ABI50_0_0RCTConvert BOOL:json];
}
#if !TARGET_OS_TV
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(exclusive, BOOL, ABI50_0_0RNGestureHandlerButton)
{
  [view setExclusiveTouch:json == nil ? YES : [ABI50_0_0RCTConvert BOOL:json]];
}
#endif
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(hitSlop, UIEdgeInsets, ABI50_0_0RNGestureHandlerButton)
{
  if (json) {
    UIEdgeInsets hitSlopInsets = [ABI50_0_0RCTConvert UIEdgeInsets:json];
    view.hitTestEdgeInsets =
        UIEdgeInsetsMake(-hitSlopInsets.top, -hitSlopInsets.left, -hitSlopInsets.bottom, -hitSlopInsets.right);
  } else {
    view.hitTestEdgeInsets = defaultView.hitTestEdgeInsets;
  }
}

- (UIView *)view
{
  return [ABI50_0_0RNGestureHandlerButton new];
}

@end
