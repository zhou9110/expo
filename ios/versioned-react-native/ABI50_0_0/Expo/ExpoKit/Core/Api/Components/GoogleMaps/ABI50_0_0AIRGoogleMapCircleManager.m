//
//  ABI50_0_0AIRGoogleMapCircleManager.m
//
//  Created by Nick Italiano on 10/24/16.
//

#ifdef ABI50_0_0HAVE_GOOGLE_MAPS

#import "ABI50_0_0AIRGoogleMapCircleManager.h"
#import "ABI50_0_0AIRGoogleMapCircle.h"
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0UIView+React.h>

@interface ABI50_0_0AIRGoogleMapCircleManager()

@end

@implementation ABI50_0_0AIRGoogleMapCircleManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  ABI50_0_0AIRGoogleMapCircle *circle = [ABI50_0_0AIRGoogleMapCircle new];
  return circle;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(radius, double)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(center, centerCoordinate, CLLocationCoordinate2D)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeColor, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeWidth, double)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(fillColor, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(zIndex, int)

@end

#endif
