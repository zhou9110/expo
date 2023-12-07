#if !TARGET_OS_OSX

#import <UIKit/UIKit.h>

typedef UIView ABI50_0_0REAUIView;

#else // TARGET_OS_OSX [

#import <ABI50_0_0RNReanimated/ABI50_0_0RCTUIView+Reanimated.h>

typedef ABI50_0_0RCTUIView ABI50_0_0REAUIView;

#endif // ] TARGET_OS_OSX
