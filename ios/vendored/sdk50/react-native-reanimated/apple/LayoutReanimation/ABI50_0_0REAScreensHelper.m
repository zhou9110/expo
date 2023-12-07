#import <ABI50_0_0RNReanimated/ABI50_0_0REAScreensHelper.h>

@implementation ABI50_0_0REAScreensHelper

#if LOAD_SCREENS_HEADERS

+ (ABI50_0_0REAUIView *)getScreenForView:(ABI50_0_0REAUIView *)view
{
  ABI50_0_0REAUIView *screen = view;
  while (![screen isKindOfClass:[ABI50_0_0RNSScreenView class]] && screen.superview != nil) {
    screen = screen.superview;
  }
  if ([screen isKindOfClass:[ABI50_0_0RNSScreenView class]]) {
    return screen;
  }
  return nil;
}

+ (ABI50_0_0REAUIView *)getStackForView:(ABI50_0_0REAUIView *)view
{
  if ([view isKindOfClass:[ABI50_0_0RNSScreenView class]]) {
    if (view.ABI50_0_0ReactSuperview != nil) {
      if ([view.ABI50_0_0ReactSuperview isKindOfClass:[ABI50_0_0RNSScreenStackView class]]) {
        return view.ABI50_0_0ReactSuperview;
      }
    }
  }
  while (view != nil && ![view isKindOfClass:[ABI50_0_0RNSScreenStackView class]] && view.superview != nil) {
    view = view.superview;
  }
  if ([view isKindOfClass:[ABI50_0_0RNSScreenStackView class]]) {
    return view;
  }
  return nil;
}

+ (bool)isScreenModal:(ABI50_0_0REAUIView *)uiViewScreen
{
  if ([uiViewScreen isKindOfClass:[ABI50_0_0RNSScreenView class]]) {
    ABI50_0_0RNSScreenView *screen = (ABI50_0_0RNSScreenView *)uiViewScreen;
    bool isModal = [screen isModal];
    if (!isModal) {
      // case for modal with header
      ABI50_0_0RNSScreenView *parentScreen = (ABI50_0_0RNSScreenView *)[ABI50_0_0REAScreensHelper getScreenForView:screen.ABI50_0_0ReactSuperview];
      if (parentScreen != nil) {
        isModal = [parentScreen isModal];
      }
    }
    return isModal;
  }
  return false;
}

+ (ABI50_0_0REAUIView *)getScreenWrapper:(ABI50_0_0REAUIView *)view
{
  ABI50_0_0REAUIView *screen = [ABI50_0_0REAScreensHelper getScreenForView:view];
  ABI50_0_0REAUIView *stack = [ABI50_0_0REAScreensHelper getStackForView:screen];
  ABI50_0_0REAUIView *screenWrapper = [ABI50_0_0REAScreensHelper getScreenForView:stack];
  return screenWrapper;
}

+ (int)getScreenType:(ABI50_0_0REAUIView *)screen;
{
  return [[screen valueForKey:@"stackPresentation"] intValue];
}

+ (bool)isRNSScreenType:(ABI50_0_0REAUIView *)view
{
  return [view isKindOfClass:[ABI50_0_0RNSScreen class]] == YES;
}

#else

+ (ABI50_0_0REAUIView *)getScreenForView:(ABI50_0_0REAUIView *)view
{
  return nil;
}

+ (ABI50_0_0REAUIView *)getStackForView:(ABI50_0_0REAUIView *)view
{
  return nil;
}

+ (bool)isScreenModal:(ABI50_0_0REAUIView *)screen
{
  return false;
}

+ (ABI50_0_0REAUIView *)getScreenWrapper:(ABI50_0_0REAUIView *)view
{
  return nil;
}

+ (int)getScreenType:(ABI50_0_0REAUIView *)screen;
{
  return 0;
}

+ (bool)isRNSScreenType:(ABI50_0_0REAUIView *)screen
{
  return false;
}

#endif // LOAD_SCREENS_HEADERS

@end
