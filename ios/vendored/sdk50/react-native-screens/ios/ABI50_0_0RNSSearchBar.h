#import <UIKit/UIKit.h>

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTViewComponentView.h>
#import <react/renderer/components/rnscreens/ABI50_0_0RCTComponentViewHelpers.h>
#endif

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponent.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>
#import "ABI50_0_0RNSEnums.h"

@interface ABI50_0_0RNSSearchBar :
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
    ABI50_0_0RCTViewComponentView <UISearchBarDelegate, ABI50_0_0RCTRNSSearchBarViewProtocol>
#else
    UIView <UISearchBarDelegate>
#endif

@property (nonatomic) BOOL hideWhenScrolling;
@property (nonatomic) ABI50_0_0RNSSearchBarPlacement placement;
@property (nonatomic, retain) UISearchController *controller;

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && defined(__IPHONE_16_0) && \
    __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_16_0 && !TARGET_OS_TV
- (UINavigationItemSearchBarPlacement)placementAsUINavigationItemSearchBarPlacement API_AVAILABLE(ios(16.0))
    API_UNAVAILABLE(tvos, watchos);
#endif // Check for iOS >= 16 && !TARGET_OS_TV

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#else
@property (nonatomic, copy) ABI50_0_0RCTBubblingEventBlock onChangeText;
@property (nonatomic, copy) ABI50_0_0RCTBubblingEventBlock onCancelButtonPress;
@property (nonatomic, copy) ABI50_0_0RCTBubblingEventBlock onSearchButtonPress;
@property (nonatomic, copy) ABI50_0_0RCTBubblingEventBlock onFocus;
@property (nonatomic, copy) ABI50_0_0RCTBubblingEventBlock onBlur;
#endif

@end

@interface ABI50_0_0RNSSearchBarManager : ABI50_0_0RCTViewManager

@end
