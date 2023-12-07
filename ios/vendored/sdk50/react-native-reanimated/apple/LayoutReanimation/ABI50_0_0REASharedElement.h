#import <ABI50_0_0RNReanimated/LayoutAnimationType.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REASnapshot.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAUIKit.h>

@interface ABI50_0_0REASharedElement : NSObject

- (instancetype)initWithSourceView:(ABI50_0_0REAUIView *)sourceView
                sourceViewSnapshot:(ABI50_0_0REASnapshot *)sourceViewSnapshot
                        targetView:(ABI50_0_0REAUIView *)targetView
                targetViewSnapshot:(ABI50_0_0REASnapshot *)targetViewSnapshot;

@property ABI50_0_0REAUIView *sourceView;
@property ABI50_0_0REASnapshot *sourceViewSnapshot;
@property ABI50_0_0REAUIView *targetView;
@property ABI50_0_0REASnapshot *targetViewSnapshot;
@property LayoutAnimationType animationType;

@end
