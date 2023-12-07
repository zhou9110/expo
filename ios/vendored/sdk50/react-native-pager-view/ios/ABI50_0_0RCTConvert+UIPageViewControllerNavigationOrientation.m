
#import "ABI50_0_0RCTConvert+UIPageViewControllerNavigationOrientation.h"

@implementation ABI50_0_0RCTConvert (UIPageViewControllerNavigationOrientation)

ABI50_0_0RCT_ENUM_CONVERTER(UIPageViewControllerNavigationOrientation, (@{
                                                                 @"horizontal": @(UIPageViewControllerNavigationOrientationHorizontal),
                                                                 @"vertical": @(UIPageViewControllerNavigationOrientationVertical),
                                                                 }), UIPageViewControllerNavigationOrientationHorizontal, integerValue)

@end
