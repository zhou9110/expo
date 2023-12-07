//
//  ABI50_0_0AIRGoogleMapCalloutSubviewManager.m
//  AirMaps
//
//  Created by Denis Oblogin on 10/8/18.
//
//

#ifdef ABI50_0_0HAVE_GOOGLE_MAPS

#import "ABI50_0_0AIRGoogleMapCalloutSubviewManager.h"
#import "ABI50_0_0AIRGoogleMapCalloutSubview.h"
#import <ABI50_0_0React/ABI50_0_0RCTView.h>

@implementation ABI50_0_0AIRGoogleMapCalloutSubviewManager
ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  ABI50_0_0AIRGoogleMapCalloutSubview *calloutSubview = [ABI50_0_0AIRGoogleMapCalloutSubview new];
  return calloutSubview;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPress, ABI50_0_0RCTBubblingEventBlock)

@end

#endif
