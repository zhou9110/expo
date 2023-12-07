//
//  ABI50_0_0AIRGoogleMapPolylgoneManager.m
//
//  Created by Nick Italiano on 10/22/16.
//

#ifdef ABI50_0_0HAVE_GOOGLE_MAPS
#import "ABI50_0_0AIRGoogleMapPolygonManager.h"

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert+CoreLocation.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>
#import <ABI50_0_0React/ABI50_0_0UIView+React.h>
#import "ABI50_0_0RCTConvert+AirMap.h"
#import "ABI50_0_0AIRGoogleMapPolygon.h"

@interface ABI50_0_0AIRGoogleMapPolygonManager()

@end

@implementation ABI50_0_0AIRGoogleMapPolygonManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  ABI50_0_0AIRGoogleMapPolygon *polygon = [ABI50_0_0AIRGoogleMapPolygon new];
  polygon.bridge = self.bridge;
  return polygon;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(coordinates, ABI50_0_0AIRMapCoordinateArray)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(holes, ABI50_0_0AIRMapCoordinateArrayArray)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(fillColor, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeWidth, double)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeColor, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(geodesic, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(zIndex, int)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(tappable, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPress, ABI50_0_0RCTBubblingEventBlock)

@end

#endif
