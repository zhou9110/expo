
#import "ABI50_0_0ReactViewPagerManager.h"

@implementation ABI50_0_0ReactViewPagerManager

#pragma mark - RTC

ABI50_0_0RCT_EXPORT_MODULE(ABI50_0_0RNCViewPager)

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(initialPage, NSInteger)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(pageMargin, NSInteger)

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(orientation, UIPageViewControllerNavigationOrientation)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPageSelected, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPageScroll, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPageScrollStateChanged, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(overdrag, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(layoutDirection, NSString)


- (void) goToPage
                  : (nonnull NSNumber *)ABI50_0_0ReactTag index
                  : (nonnull NSNumber *)index animated
                  : (BOOL)animated {
    [self.bridge.uiManager addUIBlock:^(
                                        ABI50_0_0RCTUIManager *uiManager,
                                        NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        ABI50_0_0ReactNativePageView *view = (ABI50_0_0ReactNativePageView *)viewRegistry[ABI50_0_0ReactTag];
        if (!view || ![view isKindOfClass:[ABI50_0_0ReactNativePageView class]]) {
            ABI50_0_0RCTLogError(@"Cannot find ABI50_0_0ReactNativePageView with tag #%@", ABI50_0_0ReactTag);
            return;
        }
        if (!animated || !view.animating) {
            [view goTo:index.integerValue animated:animated];
        }
    }];
}

- (void) changeScrollEnabled
: (nonnull NSNumber *)ABI50_0_0ReactTag enabled
: (BOOL)enabled {
    [self.bridge.uiManager addUIBlock:^(
                                        ABI50_0_0RCTUIManager *uiManager,
                                        NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        ABI50_0_0ReactNativePageView *view = (ABI50_0_0ReactNativePageView *)viewRegistry[ABI50_0_0ReactTag];
        if (!view || ![view isKindOfClass:[ABI50_0_0ReactNativePageView class]]) {
            ABI50_0_0RCTLogError(@"Cannot find ABI50_0_0ReactNativePageView with tag #%@", ABI50_0_0ReactTag);
            return;
        }
        [view shouldScroll:enabled];
    }];
}

ABI50_0_0RCT_EXPORT_METHOD(setPage
                  : (nonnull NSNumber *)ABI50_0_0ReactTag index
                  : (nonnull NSNumber *)index) {
    [self goToPage:ABI50_0_0ReactTag index:index animated:true];
}

ABI50_0_0RCT_EXPORT_METHOD(setPageWithoutAnimation
                  : (nonnull NSNumber *)ABI50_0_0ReactTag index
                  : (nonnull NSNumber *)index) {
    [self goToPage:ABI50_0_0ReactTag index:index animated:false];
}

ABI50_0_0RCT_EXPORT_METHOD(setScrollEnabledImperatively
                  : (nonnull NSNumber *)ABI50_0_0ReactTag enabled
                  : (nonnull NSNumber *)enabled) {
    BOOL isEnabled = [enabled boolValue];
    [self changeScrollEnabled:ABI50_0_0ReactTag enabled:isEnabled];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(scrollEnabled, BOOL, ABI50_0_0ReactNativePageView) {
    [view shouldScroll:[ABI50_0_0RCTConvert BOOL:json]];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(keyboardDismissMode, NSString, ABI50_0_0ReactNativePageView) {
    [view shouldDismissKeyboard:[ABI50_0_0RCTConvert NSString:json]];
}


- (UIView *)view {
    return [[ABI50_0_0ReactNativePageView alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}

@end
