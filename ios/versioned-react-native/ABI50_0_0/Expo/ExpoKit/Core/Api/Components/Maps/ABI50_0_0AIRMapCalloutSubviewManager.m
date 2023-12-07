//
//  ABI50_0_0AIRMapCalloutSubviewManager.m
//  AirMaps
//
//  Created by Denis Oblogin on 10/8/18.
//
//

#import "ABI50_0_0AIRMapCalloutSubviewManager.h"
#import "ABI50_0_0AIRMapCalloutSubview.h"
#import <ABI50_0_0React/ABI50_0_0RCTView.h>

@implementation ABI50_0_0AIRMapCalloutSubviewManager
ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  ABI50_0_0AIRMapCalloutSubview *calloutSubview = [ABI50_0_0AIRMapCalloutSubview new];
  return calloutSubview;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPress, ABI50_0_0RCTBubblingEventBlock)

@end
