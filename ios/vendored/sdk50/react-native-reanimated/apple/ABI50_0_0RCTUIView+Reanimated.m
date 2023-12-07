#if TARGET_OS_OSX

#import <ABI50_0_0RNReanimated/ABI50_0_0RCTUIView+Reanimated.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIKit.h>

@implementation ABI50_0_0RCTUIView (Reanimated)

- (CGPoint)center
{
  NSRect frameRect = self.frame;
  CGFloat xCenter = frameRect.origin.x + frameRect.size.width / 2;
  CGFloat yCenter = frameRect.origin.y + frameRect.size.height / 2;
  return CGPointMake(xCenter, yCenter);
}

- (void)setCenter:(CGPoint)point
{
  NSRect frameRect = self.frame;
  CGFloat xOrigin = point.x - frameRect.size.width / 2;
  CGFloat yOrigin = point.y - frameRect.size.height / 2;
  self.frame = CGRectMake(xOrigin, yOrigin, frameRect.size.width, frameRect.size.height);
}

@end

#endif
