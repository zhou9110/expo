//
//  ABI50_0_0AIRGoogleMapURLTileManager.m
//  Created by Nick Italiano on 11/5/16.
//

#ifdef ABI50_0_0HAVE_GOOGLE_MAPS

#import "ABI50_0_0AIRGoogleMapUrlTileManager.h"
#import "ABI50_0_0AIRGoogleMapUrlTile.h"

@interface ABI50_0_0AIRGoogleMapUrlTileManager()

@end

@implementation ABI50_0_0AIRGoogleMapUrlTileManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  ABI50_0_0AIRGoogleMapUrlTile *tileLayer = [ABI50_0_0AIRGoogleMapUrlTile new];
  return tileLayer;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(urlTemplate, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(zIndex, int)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(maximumZ, NSInteger)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(minimumZ, NSInteger)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(flipY, BOOL)

@end

#endif
