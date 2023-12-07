#import <ABI50_0_0RNReanimated/NativeMethods.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAUIKit.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>
#import <ABI50_0_0React/ABI50_0_0RCTScrollView.h>

namespace ABI50_0_0reanimated {

std::vector<std::pair<std::string, double>> measure(int viewTag, ABI50_0_0RCTUIManager *uiManager)
{
  ABI50_0_0REAUIView *view = [uiManager viewForABI50_0_0ReactTag:@(viewTag)];

  ABI50_0_0REAUIView *rootView = view;

  if (view == nil) {
    return std::vector<std::pair<std::string, double>>(1, std::make_pair("x", -1234567.0));
  }

  while (rootView.superview && ![rootView isABI50_0_0ReactRootView]) {
    rootView = rootView.superview;
  }

  if (rootView == nil) {
    return std::vector<std::pair<std::string, double>>(1, std::make_pair("x", -1234567.0));
  }

  CGRect frame = view.frame;
  CGRect globalBounds = [view convertRect:view.bounds toView:rootView];

  return {
      {"x", frame.origin.x},
      {"y", frame.origin.y},
      {"width", globalBounds.size.width},
      {"height", globalBounds.size.height},
      {"pageX", globalBounds.origin.x},
      {"pageY", globalBounds.origin.y},
  };
}

void scrollTo(int scrollViewTag, ABI50_0_0RCTUIManager *uiManager, double x, double y, bool animated)
{
  ABI50_0_0REAUIView *view = [uiManager viewForABI50_0_0ReactTag:@(scrollViewTag)];
  ABI50_0_0RCTScrollView *scrollView = (ABI50_0_0RCTScrollView *)view;
  [scrollView scrollToOffset:(CGPoint){(CGFloat)x, (CGFloat)y} animated:animated];
}

void setGestureState(id<ABI50_0_0RNGestureHandlerStateManager> gestureHandlerStateManager, int handlerTag, int newState)
{
  if (gestureHandlerStateManager != nil) {
    [gestureHandlerStateManager setGestureState:newState forHandler:handlerTag];
  }
}

} // namespace reanimated
