//
//  ABI50_0_0AIRGoogleMapWMSTileManager.m
//  AirMaps
//
//  Created by nizam on 10/28/18.
//  Copyright © 2018. All rights reserved.
//

#ifdef ABI50_0_0HAVE_GOOGLE_MAPS

#import "ABI50_0_0AIRGoogleMapWMSTileManager.h"
#import "ABI50_0_0AIRGoogleMapWMSTile.h"

@interface ABI50_0_0AIRGoogleMapWMSTileManager()

@end

@implementation ABI50_0_0AIRGoogleMapWMSTileManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
    ABI50_0_0AIRGoogleMapWMSTile *tileLayer = [ABI50_0_0AIRGoogleMapWMSTile new];
    return tileLayer;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(urlTemplate, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(zIndex, int)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(maximumZ, int)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(minimumZ, int)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(tileSize, int)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(opacity, float)

@end

#endif
