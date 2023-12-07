//
//  ABI50_0_0AIRGoogleMapPolylineManager.m
//
//  Created by Nick Italiano on 10/22/16.
//

#ifdef ABI50_0_0HAVE_GOOGLE_MAPS

#import "ABI50_0_0AIRGoogleMapPolylineManager.h"

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert+CoreLocation.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>
#import <ABI50_0_0React/ABI50_0_0UIView+React.h>
#import "ABI50_0_0RCTConvert+AirMap.h"
#import "ABI50_0_0AIRGoogleMapPolyline.h"

@interface ABI50_0_0AIRGoogleMapPolylineManager()

@end

@implementation ABI50_0_0AIRGoogleMapPolylineManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  ABI50_0_0AIRGoogleMapPolyline *polyline = [ABI50_0_0AIRGoogleMapPolyline new];
  polyline.bridge = self.bridge;
  return polyline;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(coordinates, ABI50_0_0AIRMapCoordinateArray)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(fillColor, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeColor, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeColors, UIColorArray)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeWidth, double)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(lineDashPattern, NSArray)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(geodesic, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(zIndex, int)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(tappable, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPress, ABI50_0_0RCTBubblingEventBlock)

@end

#endif
