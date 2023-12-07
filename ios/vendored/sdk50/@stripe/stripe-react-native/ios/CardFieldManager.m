#import <Foundation/Foundation.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>

@interface ABI50_0_0RCT_EXTERN_REMAP_MODULE(CardFieldManager, ABI50_0_0CardFieldManager, ABI50_0_0RCTViewManager)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(postalCodeEnabled, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(countryCode, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onCardChange, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onFocusChange, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(cardStyle, NSDictionary)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(placeholders, NSDictionary)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(autofocus, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(disabled, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(dangerouslyGetFullCardDetails, BOOL)
ABI50_0_0RCT_EXTERN_METHOD(focus:(nonnull NSNumber*) ABI50_0_0ReactTag)
ABI50_0_0RCT_EXTERN_METHOD(blur:(nonnull NSNumber*) ABI50_0_0ReactTag)
ABI50_0_0RCT_EXTERN_METHOD(clear:(nonnull NSNumber*) ABI50_0_0ReactTag)
@end
