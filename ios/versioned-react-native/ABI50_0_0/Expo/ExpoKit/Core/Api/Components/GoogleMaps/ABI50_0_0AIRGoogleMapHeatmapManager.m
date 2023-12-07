//
//  ABI50_0_0AIRGoogleMapHeatmapManager.m
//
//  Created by David Cako on 29 April 2018.
//

#import "ABI50_0_0AIRGoogleMapHeatmapManager.h"
#import "ABI50_0_0AIRGoogleMapHeatmap.h"
#import "ABI50_0_0AIRGoogleMap.h"
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0UIView+React.h>

@interface ABI50_0_0AIRGoogleMapHeatmapManager()

@end

@implementation ABI50_0_0AIRGoogleMapHeatmapManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  ABI50_0_0AIRGoogleMapHeatmap *heatmap = [ABI50_0_0AIRGoogleMapHeatmap new];
  return heatmap;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(points, NSArray<NSDictionary *>)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(radius, NSUInteger)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(opacity, float)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(gradient, NSDictionary *)

@end