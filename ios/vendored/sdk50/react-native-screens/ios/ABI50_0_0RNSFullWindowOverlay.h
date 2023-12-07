#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTViewComponentView.h>
#else
#import <ABI50_0_0React/ABI50_0_0RCTInvalidating.h>
#import <ABI50_0_0React/ABI50_0_0RCTView.h>
#endif

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
namespace ABI50_0_0React = ABI50_0_0facebook::ABI50_0_0React;
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@interface ABI50_0_0RNSFullWindowOverlayManager : ABI50_0_0RCTViewManager

@end

@interface ABI50_0_0RNSFullWindowOverlayContainer : UIView

@end

@interface ABI50_0_0RNSFullWindowOverlay :
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
    ABI50_0_0RCTViewComponentView
#else
    ABI50_0_0RCTView <ABI50_0_0RCTInvalidating>
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
@property (nonatomic) ABI50_0_0React::LayoutMetrics oldLayoutMetrics;
@property (nonatomic) ABI50_0_0React::LayoutMetrics newLayoutMetrics;
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@end
