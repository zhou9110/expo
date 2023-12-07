#import <ABI50_0_0React/ABI50_0_0RCTComponent.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>

#import "ABI50_0_0RNSEnums.h"
#import "ABI50_0_0RNSScreenContainer.h"

#if ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTViewComponentView.h>
#else
#import <ABI50_0_0React/ABI50_0_0RCTView.h>
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

NS_ASSUME_NONNULL_BEGIN

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
namespace ABI50_0_0React = ABI50_0_0facebook::ABI50_0_0React;
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@interface ABI50_0_0RCTConvert (ABI50_0_0RNSScreen)

+ (ABI50_0_0RNSScreenStackPresentation)ABI50_0_0RNSScreenStackPresentation:(id)json;
+ (ABI50_0_0RNSScreenStackAnimation)ABI50_0_0RNSScreenStackAnimation:(id)json;

#if !TARGET_OS_TV
+ (ABI50_0_0RNSStatusBarStyle)ABI50_0_0RNSStatusBarStyle:(id)json;
+ (UIStatusBarAnimation)UIStatusBarAnimation:(id)json;
+ (UIInterfaceOrientationMask)UIInterfaceOrientationMask:(id)json;
#endif

@end

@class ABI50_0_0RNSScreenView;

@interface ABI50_0_0RNSScreen : UIViewController <ABI50_0_0RNSViewControllerDelegate>

- (instancetype)initWithView:(UIView *)view;
- (UIViewController *)findChildVCForConfigAndTrait:(ABI50_0_0RNSWindowTrait)trait includingModals:(BOOL)includingModals;
- (BOOL)hasNestedStack;
- (void)calculateAndNotifyHeaderHeightChangeIsModal:(BOOL)isModal;
- (void)notifyFinishTransitioning;
- (ABI50_0_0RNSScreenView *)screenView;
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
- (void)setViewToSnapshot:(UIView *)snapshot;
- (void)resetViewToScreen;
#endif

@end

@class ABI50_0_0RNSScreenStackHeaderConfig;

@interface ABI50_0_0RNSScreenView :
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
    ABI50_0_0RCTViewComponentView
#else
    ABI50_0_0RCTView
#endif

@property (nonatomic) BOOL fullScreenSwipeEnabled;
@property (nonatomic) BOOL gestureEnabled;
@property (nonatomic) BOOL hasStatusBarHiddenSet;
@property (nonatomic) BOOL hasStatusBarStyleSet;
@property (nonatomic) BOOL hasStatusBarAnimationSet;
@property (nonatomic) BOOL hasHomeIndicatorHiddenSet;
@property (nonatomic) BOOL hasOrientationSet;
@property (nonatomic) ABI50_0_0RNSScreenStackAnimation stackAnimation;
@property (nonatomic) ABI50_0_0RNSScreenStackPresentation stackPresentation;
@property (nonatomic) ABI50_0_0RNSScreenSwipeDirection swipeDirection;
@property (nonatomic) ABI50_0_0RNSScreenReplaceAnimation replaceAnimation;

@property (nonatomic, retain) NSNumber *transitionDuration;
@property (nonatomic, readonly) BOOL dismissed;
@property (nonatomic) BOOL hideKeyboardOnSwipe;
@property (nonatomic) BOOL customAnimationOnSwipe;
@property (nonatomic) BOOL preventNativeDismiss;
@property (nonatomic, retain) ABI50_0_0RNSScreen *controller;
@property (nonatomic, copy) NSDictionary *gestureResponseDistance;
@property (nonatomic) int activityState;
@property (weak, nonatomic) UIView<ABI50_0_0RNSScreenContainerDelegate> *ABI50_0_0ReactSuperview;

#if !TARGET_OS_TV
@property (nonatomic) ABI50_0_0RNSStatusBarStyle statusBarStyle;
@property (nonatomic) UIStatusBarAnimation statusBarAnimation;
@property (nonatomic) UIInterfaceOrientationMask screenOrientation;
@property (nonatomic) BOOL statusBarHidden;
@property (nonatomic) BOOL homeIndicatorHidden;

// Props controlling UISheetPresentationController
@property (nonatomic) ABI50_0_0RNSScreenDetentType sheetAllowedDetents;
@property (nonatomic) ABI50_0_0RNSScreenDetentType sheetLargestUndimmedDetent;
@property (nonatomic) BOOL sheetGrabberVisible;
@property (nonatomic) CGFloat sheetCornerRadius;
@property (nonatomic) BOOL sheetExpandsWhenScrolledToEdge;
#endif // !TARGET_OS_TV

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
// we recreate the behavior of `ABI50_0_0ReactSetFrame` on new architecture
@property (nonatomic) ABI50_0_0React::LayoutMetrics oldLayoutMetrics;
@property (nonatomic) ABI50_0_0React::LayoutMetrics newLayoutMetrics;
@property (weak, nonatomic) ABI50_0_0RNSScreenStackHeaderConfig *config;
@property (nonatomic, readonly) BOOL hasHeaderConfig;
#else
@property (nonatomic, copy) ABI50_0_0RCTDirectEventBlock onAppear;
@property (nonatomic, copy) ABI50_0_0RCTDirectEventBlock onDisappear;
@property (nonatomic, copy) ABI50_0_0RCTDirectEventBlock onDismissed;
@property (nonatomic, copy) ABI50_0_0RCTDirectEventBlock onHeaderHeightChange;
@property (nonatomic, copy) ABI50_0_0RCTDirectEventBlock onWillAppear;
@property (nonatomic, copy) ABI50_0_0RCTDirectEventBlock onWillDisappear;
@property (nonatomic, copy) ABI50_0_0RCTDirectEventBlock onNativeDismissCancelled;
@property (nonatomic, copy) ABI50_0_0RCTDirectEventBlock onTransitionProgress;
@property (nonatomic, copy) ABI50_0_0RCTDirectEventBlock onGestureCancel;
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

- (void)notifyFinishTransitioning;
- (void)notifyHeaderHeightChange:(double)height;

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
- (void)notifyWillAppear;
- (void)notifyWillDisappear;
- (void)notifyAppear;
- (void)notifyDisappear;
- (void)updateBounds;
- (void)notifyDismissedWithCount:(int)dismissCount;
- (instancetype)initWithFrame:(CGRect)frame;
#endif

- (void)notifyTransitionProgress:(double)progress closing:(BOOL)closing goingForward:(BOOL)goingForward;
- (void)notifyDismissCancelledWithDismissCount:(int)dismissCount;
- (BOOL)isModal;
- (BOOL)isPresentedAsNativeModal;

/// Looks for header configuration in instance's `ABI50_0_0ReactSubviews` and returns it. If not present returns `nil`.
- (ABI50_0_0RNSScreenStackHeaderConfig *_Nullable)findHeaderConfig;

@end

@interface UIView (ABI50_0_0RNSScreen)
- (UIViewController *)parentViewController;
@end

@interface ABI50_0_0RNSScreenManager : ABI50_0_0RCTViewManager

@end

NS_ASSUME_NONNULL_END
