#define LOAD_SCREENS_HEADERS                                         \
  ((!ABI50_0_0RCT_NEW_ARCH_ENABLED && __has_include(<ABI50_0_0RNScreens/ABI50_0_0RNSScreen.h>)) \
  || (ABI50_0_0RCT_NEW_ARCH_ENABLED && __has_include(<ABI50_0_0RNScreens/ABI50_0_0RNSScreen.h>) && __cplusplus))

#if LOAD_SCREENS_HEADERS
#import <ABI50_0_0RNScreens/ABI50_0_0RNSScreen.h>
#import <ABI50_0_0RNScreens/ABI50_0_0RNSScreenStack.h>
#endif

#import <ABI50_0_0RNReanimated/ABI50_0_0REAUIKit.h>

@interface ABI50_0_0REAScreensHelper : NSObject

+ (ABI50_0_0REAUIView *)getScreenForView:(ABI50_0_0REAUIView *)view;
+ (ABI50_0_0REAUIView *)getStackForView:(ABI50_0_0REAUIView *)view;
+ (bool)isScreenModal:(ABI50_0_0REAUIView *)screen;
+ (ABI50_0_0REAUIView *)getScreenWrapper:(ABI50_0_0REAUIView *)view;
+ (int)getScreenType:(ABI50_0_0REAUIView *)screen;
+ (bool)isRNSScreenType:(ABI50_0_0REAUIView *)screen;

@end
