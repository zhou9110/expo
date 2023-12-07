//
//  AddressSheetViewManager.m
//  stripe-react-native
//
//  Created by Charles Cruzan on 10/11/22.
//

#import <Foundation/Foundation.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>

@interface ABI50_0_0RCT_EXTERN_REMAP_MODULE(AddressSheetViewManager, ABI50_0_0AddressSheetViewManager, ABI50_0_0RCTViewManager)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(visible, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(presentationStyle, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(animationStyle, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(appearance, NSDictionary)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(defaultValues, NSDictionary)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(additionalFields, NSDictionary)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(allowedCountries, NSArray)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(autocompleteCountries, NSArray)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(primaryButtonTitle, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(sheetTitle, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onSubmitAction, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onErrorAction, ABI50_0_0RCTDirectEventBlock)
@end
