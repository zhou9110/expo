#import "ABI50_0_0AIRGoogleMapOverlayManager.h"
#import "ABI50_0_0AIRGoogleMapOverlay.h"

@interface ABI50_0_0AIRGoogleMapOverlayManager()

@end

@implementation ABI50_0_0AIRGoogleMapOverlayManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  ABI50_0_0AIRGoogleMapOverlay *overlay = [ABI50_0_0AIRGoogleMapOverlay new];
  overlay.bridge = self.bridge;
  return overlay;
}

ABI50_0_0RCT_REMAP_VIEW_PROPERTY(bounds, boundsRect, NSArray)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(bearing, bearing, double)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(image, imageSrc, NSString)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(opacity, opacity, CGFloat)

@end
