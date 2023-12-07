//
//  ABI50_0_0AIRMapWMSTileManager.m
//  AirMaps
//
//  Created by nizam on 10/28/18.
//  Copyright © 2018. All rights reserved.
//


#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert+CoreLocation.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>
#import <ABI50_0_0React/ABI50_0_0UIView+React.h>
#import "ABI50_0_0AIRMapMarker.h"
#import "ABI50_0_0AIRMapWMSTile.h"

#import "ABI50_0_0AIRMapWMSTileManager.h"

@interface ABI50_0_0AIRMapWMSTileManager()

@end

@implementation ABI50_0_0AIRMapWMSTileManager


ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
    ABI50_0_0AIRMapWMSTile *tile = [ABI50_0_0AIRMapWMSTile new];
    return tile;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(urlTemplate, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(maximumZ, NSInteger)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(maximumNativeZ, NSInteger)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(minimumZ, NSInteger)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(shouldReplaceMapContent, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(tileSize, NSInteger)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(tileCachePath, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(tileCacheMaxAge, NSInteger)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(offlineMode, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(opacity, CGFloat)

@end
