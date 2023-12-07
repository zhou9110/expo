// This guard prevent this file to be compiled in the old architecture.
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTViewComponentView.h>
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <WebKit/WKDataDetectorTypes.h>
#import <UIKit/UIKit.h>
#import <react/renderer/components/ABI50_0_0RNCWebViewSpec/Props.h>

#ifndef NativeComponentExampleComponentView_h
#define NativeComponentExampleComponentView_h

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0RNCWebView : ABI50_0_0RCTViewComponentView
@end

namespace ABI50_0_0facebook {
namespace ABI50_0_0React {
    bool operator==(const ABI50_0_0RNCWebViewMenuItemsStruct& a, const ABI50_0_0RNCWebViewMenuItemsStruct& b)
    {
        return b.key == a.key && b.label == a.label;
    }
}
}

NS_ASSUME_NONNULL_END

#endif /* NativeComponentExampleComponentView_h */
#endif /* ABI50_0_0RCT_NEW_ARCH_ENABLED */
