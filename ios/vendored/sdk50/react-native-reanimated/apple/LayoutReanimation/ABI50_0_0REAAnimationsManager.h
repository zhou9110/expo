#import <Foundation/Foundation.h>
#import <ABI50_0_0RNReanimated/LayoutAnimationType.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REANodesManager.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REASnapshot.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAUIKit.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ViewState) {
  Inactive,
  Appearing,
  Disappearing,
  Layout,
  ToRemove,
};

typedef BOOL (^ABI50_0_0REAHasAnimationBlock)(NSNumber *_Nonnull tag, LayoutAnimationType type);
typedef BOOL (^ABI50_0_0REAShouldAnimateExitingBlock)(NSNumber *_Nonnull tag, BOOL shouldAnimate);
typedef void (
    ^ABI50_0_0REAAnimationStartingBlock)(NSNumber *_Nonnull tag, LayoutAnimationType type, NSDictionary *_Nonnull yogaValues);
typedef void (^ABI50_0_0REAAnimationRemovingBlock)(NSNumber *_Nonnull tag);
#ifndef NDEBUG
typedef void (^ABI50_0_0REACheckDuplicateSharedTagBlock)(ABI50_0_0REAUIView *view, NSNumber *_Nonnull viewTag);
#endif
typedef void (^ABI50_0_0REACancelAnimationBlock)(NSNumber *_Nonnull tag);
typedef NSNumber *_Nullable (^ABI50_0_0REAFindPrecedingViewTagForTransitionBlock)(NSNumber *_Nonnull tag);
typedef int (^ABI50_0_0REATreeVisitor)(id<ABI50_0_0RCTComponent>);
BOOL ABI50_0_0REANodeFind(id<ABI50_0_0RCTComponent> view, int (^block)(id<ABI50_0_0RCTComponent>));

@interface ABI50_0_0REAAnimationsManager : NSObject

- (instancetype)initWithUIManager:(ABI50_0_0RCTUIManager *)uiManager;
- (void)setAnimationStartingBlock:(ABI50_0_0REAAnimationStartingBlock)startAnimation;
- (void)setHasAnimationBlock:(ABI50_0_0REAHasAnimationBlock)hasAnimation;
- (void)setShouldAnimateExitingBlock:(ABI50_0_0REAShouldAnimateExitingBlock)shouldAnimateExiting;
- (void)setAnimationRemovingBlock:(ABI50_0_0REAAnimationRemovingBlock)clearAnimation;
#ifndef NDEBUG
- (void)setCheckDuplicateSharedTagBlock:(ABI50_0_0REACheckDuplicateSharedTagBlock)checkDuplicateSharedTag;
#endif
- (void)progressLayoutAnimationWithStyle:(NSDictionary *_Nonnull)newStyle
                                  forTag:(NSNumber *_Nonnull)tag
                      isSharedTransition:(BOOL)isSharedTransition;
- (void)setFindPrecedingViewTagForTransitionBlock:
    (ABI50_0_0REAFindPrecedingViewTagForTransitionBlock)findPrecedingViewTagForTransition;
- (void)setCancelAnimationBlock:(ABI50_0_0REACancelAnimationBlock)animationCancellingBlock;
- (void)endLayoutAnimationForTag:(NSNumber *_Nonnull)tag removeView:(BOOL)removeView;
- (void)endAnimationsRecursive:(ABI50_0_0REAUIView *)view;
- (void)invalidate;
- (void)viewDidMount:(ABI50_0_0REAUIView *)view withBeforeSnapshot:(ABI50_0_0REASnapshot *)snapshot withNewFrame:(CGRect)frame;
- (ABI50_0_0REASnapshot *)prepareSnapshotBeforeMountForView:(ABI50_0_0REAUIView *)view;
- (void)removeAnimationsFromSubtree:(ABI50_0_0REAUIView *)view;
- (void)reattachAnimatedChildren:(NSArray<id<ABI50_0_0RCTComponent>> *)children
                     toContainer:(id<ABI50_0_0RCTComponent>)container
                       atIndices:(NSArray<NSNumber *> *)indices;
- (void)onViewCreate:(ABI50_0_0REAUIView *)view after:(ABI50_0_0REASnapshot *)after;
- (void)onViewUpdate:(ABI50_0_0REAUIView *)view before:(ABI50_0_0REASnapshot *)before after:(ABI50_0_0REASnapshot *)after;
- (void)viewsDidLayout;
- (NSMutableDictionary *)prepareDataForLayoutAnimatingWorklet:(NSMutableDictionary *)currentValues
                                                 targetValues:(NSMutableDictionary *)targetValues;
- (ABI50_0_0REAUIView *)viewForTag:(NSNumber *)tag;
- (BOOL)hasAnimationForTag:(NSNumber *)tag type:(LayoutAnimationType)type;
- (void)clearAnimationConfigForTag:(NSNumber *)tag;
- (void)startAnimationForTag:(NSNumber *)tag type:(LayoutAnimationType)type yogaValues:(NSDictionary *)yogaValues;
- (void)onScreenRemoval:(ABI50_0_0REAUIView *)screen stack:(ABI50_0_0REAUIView *)stack;

@end

NS_ASSUME_NONNULL_END
