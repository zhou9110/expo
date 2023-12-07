//
//  AddToWalletButtonManager.m
//  stripe-react-native
//
//  Created by Charles Cruzan on 3/28/22.
//

#import <Foundation/Foundation.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>

@interface ABI50_0_0RCT_EXTERN_REMAP_MODULE(AddToWalletButtonManager, ABI50_0_0AddToWalletButtonManager, ABI50_0_0RCTViewManager)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(testEnv, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(iOSButtonStyle, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(cardDetails, NSDictionary)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(ephemeralKey, NSDictionary)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onCompleteAction, ABI50_0_0RCTDirectEventBlock)
@end
