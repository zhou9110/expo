//
//  ABI50_0_0AIRGoogleMapCalloutManager.m
//  AirMaps
//
//  Created by Gil Birman on 9/6/16.
//
//

#ifdef ABI50_0_0HAVE_GOOGLE_MAPS

#import "ABI50_0_0AIRGoogleMapCalloutManager.h"
#import "ABI50_0_0AIRGoogleMapCallout.h"
#import <ABI50_0_0React/ABI50_0_0RCTView.h>

@implementation ABI50_0_0AIRGoogleMapCalloutManager
ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  ABI50_0_0AIRGoogleMapCallout *callout = [ABI50_0_0AIRGoogleMapCallout new];
  return callout;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(tooltip, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPress, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(alphaHitTest, BOOL)

@end

#endif
