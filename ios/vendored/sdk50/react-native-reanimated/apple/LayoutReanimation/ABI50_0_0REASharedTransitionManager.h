#import <ABI50_0_0RNReanimated/ABI50_0_0REAAnimationsManager.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REASnapshot.h>

@interface ABI50_0_0REASharedTransitionManager : NSObject

- (void)notifyAboutNewView:(ABI50_0_0REAUIView *)view;
- (void)notifyAboutViewLayout:(ABI50_0_0REAUIView *)view withViewFrame:(CGRect)frame;
- (void)viewsDidLayout;
- (void)finishSharedAnimation:(ABI50_0_0REAUIView *)view removeView:(BOOL)removeView;
- (void)setFindPrecedingViewTagForTransitionBlock:
    (ABI50_0_0REAFindPrecedingViewTagForTransitionBlock)findPrecedingViewTagForTransition;
- (void)setCancelAnimationBlock:(ABI50_0_0REACancelAnimationBlock)cancelAnimationBlock;
- (instancetype)initWithAnimationsManager:(ABI50_0_0REAAnimationsManager *)animationManager;
- (ABI50_0_0REAUIView *)getTransitioningView:(NSNumber *)tag;
- (NSDictionary *)prepareDataForWorklet:(NSMutableDictionary *)currentValues
                           targetValues:(NSMutableDictionary *)targetValues;
- (void)onScreenRemoval:(ABI50_0_0REAUIView *)screen stack:(ABI50_0_0REAUIView *)stack;

@end
