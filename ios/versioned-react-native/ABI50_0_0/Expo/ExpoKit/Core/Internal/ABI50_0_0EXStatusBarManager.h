
#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventEmitter.h>

@interface ABI50_0_0RCTConvert (ABI50_0_0EXStatusBar)

#if !TARGET_OS_TV
+ (UIStatusBarStyle)UIStatusBarStyle:(id)json;
+ (UIStatusBarAnimation)UIStatusBarAnimation:(id)json;
#endif

@end

@interface ABI50_0_0EXStatusBarManager : ABI50_0_0RCTEventEmitter

@end
