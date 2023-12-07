#import <Foundation/Foundation.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAScreensHelper.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REASnapshot.h>
#import <ABI50_0_0React/ABI50_0_0RCTView.h>
#import <ABI50_0_0React/ABI50_0_0UIView+React.h>

NS_ASSUME_NONNULL_BEGIN

@implementation ABI50_0_0REASnapshot

static const int ScreenStackPresentationModal = 1; // ABI50_0_0RNSScreenStackPresentationModal
static const int DEFAULT_MODAL_TOP_OFFSET = 69; // Default iOS modal is shifted from screen top edge by 69px

- (instancetype)init:(ABI50_0_0REAUIView *)view
{
  self = [super init];
  [self makeSnapshotForView:view useAbsolutePositionOnly:NO];
  return self;
}

- (instancetype)initWithAbsolutePosition:(ABI50_0_0REAUIView *)view
{
  self = [super init];
  [self makeSnapshotForView:view useAbsolutePositionOnly:YES];
  return self;
}

- (void)makeSnapshotForView:(ABI50_0_0REAUIView *)view useAbsolutePositionOnly:(BOOL)useAbsolutePositionOnly
{
  ABI50_0_0REAUIView *mainWindow = UIApplication.sharedApplication.keyWindow;
  CGPoint absolutePosition = [[view superview] convertPoint:view.center toView:nil];
  _values = [NSMutableDictionary new];
#if TARGET_OS_OSX
  _values[@"windowWidth"] = [NSNumber numberWithDouble:mainWindow.frame.size.width];
  _values[@"windowHeight"] = [NSNumber numberWithDouble:mainWindow.frame.size.height];
#else
  _values[@"windowWidth"] = [NSNumber numberWithDouble:mainWindow.bounds.size.width];
  _values[@"windowHeight"] = [NSNumber numberWithDouble:mainWindow.bounds.size.height];
#endif
  _values[@"width"] = [NSNumber numberWithDouble:(double)(view.bounds.size.width)];
  _values[@"height"] = [NSNumber numberWithDouble:(double)(view.bounds.size.height)];
  _values[@"globalOriginX"] = [NSNumber numberWithDouble:absolutePosition.x - view.bounds.size.width / 2.0];
  _values[@"globalOriginY"] = [NSNumber numberWithDouble:absolutePosition.y - view.bounds.size.height / 2.0];
  if (useAbsolutePositionOnly) {
    _values[@"originX"] = _values[@"globalOriginX"];
    _values[@"originY"] = _values[@"globalOriginY"];
    _values[@"originXByParent"] = [NSNumber numberWithDouble:view.center.x - view.bounds.size.width / 2.0];
    _values[@"originYByParent"] = [NSNumber numberWithDouble:view.center.y - view.bounds.size.height / 2.0];

#if TARGET_OS_OSX
    ABI50_0_0REAUIView *header = nil;
#else
    ABI50_0_0REAUIView *navigationContainer = view.ABI50_0_0ReactViewController.navigationController.view;
    ABI50_0_0REAUIView *header = [navigationContainer.subviews count] > 1 ? navigationContainer.subviews[1] : nil;
#endif
    if (header != nil) {
      CGFloat headerHeight = header.frame.size.height;
      CGFloat headerOriginY = header.frame.origin.y;
      ABI50_0_0REAUIView *screen = [ABI50_0_0REAScreensHelper getScreenForView:view];
      if ([ABI50_0_0REAScreensHelper isScreenModal:screen] && screen.superview == nil) {
        int additionalModalOffset = 0;
        ABI50_0_0REAUIView *screenWrapper = [ABI50_0_0REAScreensHelper getScreenWrapper:view];
        int screenType = [ABI50_0_0REAScreensHelper getScreenType:screenWrapper];
        if (screenType == ScreenStackPresentationModal) {
          additionalModalOffset = DEFAULT_MODAL_TOP_OFFSET;
        }
        float originY = [_values[@"originY"] doubleValue] + headerHeight + headerOriginY + additionalModalOffset;
        _values[@"originY"] = @(originY);
      }
      _values[@"headerHeight"] = @(headerHeight);
    } else {
      _values[@"headerHeight"] = @(0);
    }

    ABI50_0_0REAUIView *transformedView = [self findTransformedView:view];
    if (transformedView != nil) {
      // iOS affine matrix: https://developer.apple.com/documentation/corefoundation/cgaffinetransform
      CGAffineTransform transform = transformedView.transform;
      NSNumber *a = @(transform.a);
      NSNumber *b = @(transform.b);
      NSNumber *c = @(transform.c);
      NSNumber *d = @(transform.d);
      NSNumber *tx = @(transform.tx);
      NSNumber *ty = @(transform.tx);
      _values[@"transformMatrix"] = @[ a, b, @(0), c, d, @(0), tx, ty, @(1) ];
      _values[@"originX"] = @([_values[@"originX"] doubleValue] - [tx doubleValue]);
      _values[@"originY"] = @([_values[@"originY"] doubleValue] - [ty doubleValue]);
    } else {
      // Identity matrix is an default value
      _values[@"transformMatrix"] = @[ @(1), @(0), @(0), @(0), @(1), @(0), @(0), @(0), @(1) ];
    }
#if defined(ABI50_0_0RCT_NEW_ARCH_ENABLED) || TARGET_OS_TV
    _values[@"borderRadius"] = @(0);
#else
    if ([view respondsToSelector:@selector(borderRadius)]) {
      // For example `ABI50_0_0RCTTextView` doesn't have `borderRadius` selector
      _values[@"borderRadius"] = @(((ABI50_0_0RCTView *)view).borderRadius);
    } else {
      _values[@"borderRadius"] = @(0);
    }
#endif
  } else {
    _values[@"originX"] = @(view.center.x - view.bounds.size.width / 2.0);
    _values[@"originY"] = @(view.center.y - view.bounds.size.height / 2.0);
  }
}

- (ABI50_0_0REAUIView *)findTransformedView:(ABI50_0_0REAUIView *)view
{
  ABI50_0_0REAUIView *transformedView;
  bool isTransformed = false;
  do {
    if (transformedView == nil) {
      transformedView = view;
    } else {
      transformedView = transformedView.superview;
    }
    CGAffineTransform transform = transformedView.transform;
    isTransformed = transform.a != 1 || transform.b != 0 || transform.c != 0 || transform.d != 1 || transform.tx != 0 ||
        transform.ty != 0;
  } while (!isTransformed &&
           transformedView != nil
           // Ignore views above screen
           && ![ABI50_0_0REAScreensHelper isRNSScreenType:transformedView]);

  if (isTransformed && transformedView != nil) {
    return transformedView;
  }
  return nil;
}

@end

NS_ASSUME_NONNULL_END
