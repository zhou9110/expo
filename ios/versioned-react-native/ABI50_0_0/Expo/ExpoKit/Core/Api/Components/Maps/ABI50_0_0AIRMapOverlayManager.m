#import "ABI50_0_0AIRMapOverlayManager.h"

#import <ABI50_0_0React/ABI50_0_0RCTConvert+CoreLocation.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import <ABI50_0_0React/ABI50_0_0UIView+React.h>
#import "ABI50_0_0AIRMapOverlay.h"

@interface ABI50_0_0AIRMapOverlayManager () <MKMapViewDelegate>

@end

@implementation ABI50_0_0AIRMapOverlayManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
    ABI50_0_0AIRMapOverlay *overlay = [ABI50_0_0AIRMapOverlay new];
    overlay.bridge = self.bridge;
    return overlay;
}

ABI50_0_0RCT_REMAP_VIEW_PROPERTY(bounds, boundsRect, NSArray)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(image, imageSrc, NSString)

@end

