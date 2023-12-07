#import "ABI50_0_0RNSScreen.h"

@interface ABI50_0_0RNSScreenStackAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithOperation:(UINavigationControllerOperation)operation;
+ (BOOL)isCustomAnimation:(ABI50_0_0RNSScreenStackAnimation)animation;

@end
