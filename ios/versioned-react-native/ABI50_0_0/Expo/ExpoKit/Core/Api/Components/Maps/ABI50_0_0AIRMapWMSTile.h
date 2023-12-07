//
//  ABI50_0_0AIRMapWMSTile.h
//  AirMaps
//
//  Created by nizam on 10/28/18.
//  Copyright © 2018. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTComponent.h>
#import <ABI50_0_0React/ABI50_0_0RCTView.h>
#import "ABI50_0_0AIRMapCoordinate.h"
#import "ABI50_0_0AIRMap.h"
#import "ABI50_0_0RCTConvert+AirMap.h"
#import "ABI50_0_0AIRMapUrlTile.h"
#import "ABI50_0_0AIRMapUrlTileCachedOverlay.h"

@interface ABI50_0_0AIRMapWMSTile : ABI50_0_0AIRMapUrlTile <MKOverlay>
@end

@interface ABI50_0_0AIRMapWMSTileOverlay : MKTileOverlay
@end

@interface ABI50_0_0AIRMapWMSTileCachedOverlay : ABI50_0_0AIRMapUrlTileCachedOverlay
@end

@interface ABI50_0_0AIRMapWMSTileHelper : NSObject

+ (NSURL *)URLForTilePath:(MKTileOverlayPath)path withURLTemplate:(NSString *)URLTemplate withTileSize:(NSInteger)tileSize;

@end
