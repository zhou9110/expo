#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTViewComponentView.h>
#else
#import <ABI50_0_0React/ABI50_0_0RCTUIManagerObserverCoordinator.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>
#endif

#import "ABI50_0_0RNSScreenContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0RNSNavigationController : UINavigationController <ABI50_0_0RNSViewControllerDelegate>

@end

@interface ABI50_0_0RNSScreenStackView :
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
    ABI50_0_0RCTViewComponentView <ABI50_0_0RNSScreenContainerDelegate>
#else
    UIView <ABI50_0_0RNSScreenContainerDelegate, ABI50_0_0RCTInvalidating>
#endif

- (void)markChildUpdated;
- (void)didUpdateChildren;

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#else
@property (nonatomic, copy) ABI50_0_0RCTDirectEventBlock onFinishTransitioning;
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@end

@interface ABI50_0_0RNSScreenStackManager : ABI50_0_0RCTViewManager <ABI50_0_0RCTInvalidating>

@end

NS_ASSUME_NONNULL_END
