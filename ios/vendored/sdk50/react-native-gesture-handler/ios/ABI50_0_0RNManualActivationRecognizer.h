#import <UIKit/UIGestureRecognizerSubclass.h>

@class ABI50_0_0RNGestureHandler;

@interface ABI50_0_0RNManualActivationRecognizer : UIGestureRecognizer <UIGestureRecognizerDelegate>

- (id)initWithGestureHandler:(ABI50_0_0RNGestureHandler *)gestureHandler;
- (void)fail;

@end
