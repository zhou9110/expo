#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTViewComponentView.h>
#else
#endif

#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ABI50_0_0RNSScreenContainerDelegate

- (void)markChildUpdated;
- (void)updateContainer;

@end

@protocol ABI50_0_0RNSViewControllerDelegate

@end

@interface ABI50_0_0RNSViewController : UIViewController <ABI50_0_0RNSViewControllerDelegate>

- (UIViewController *)findActiveChildVC;

@end

@interface ABI50_0_0RNSScreenContainerManager : ABI50_0_0RCTViewManager

@end

@interface ABI50_0_0RNSScreenContainerView :
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
    ABI50_0_0RCTViewComponentView <ABI50_0_0RNSScreenContainerDelegate>
#else
    UIView <ABI50_0_0RNSScreenContainerDelegate, ABI50_0_0RCTInvalidating>
#endif

@property (nonatomic, retain) UIViewController *controller;
@property (nonatomic, retain) NSMutableArray *ABI50_0_0ReactSubviews;

- (void)maybeDismissVC;

@end

NS_ASSUME_NONNULL_END
