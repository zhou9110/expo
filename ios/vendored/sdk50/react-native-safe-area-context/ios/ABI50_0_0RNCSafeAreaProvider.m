#import "ABI50_0_0RNCSafeAreaProvider.h"

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import "ABI50_0_0RNCSafeAreaUtils.h"

@implementation ABI50_0_0RNCSafeAreaProvider {
  UIEdgeInsets _currentSafeAreaInsets;
  CGRect _currentFrame;
  BOOL _initialInsetsSent;
}

- (instancetype)init
{
  if ((self = [super init])) {
#if !TARGET_OS_TV
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(invalidateSafeAreaInsets)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(invalidateSafeAreaInsets)
                                               name:UIKeyboardDidHideNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(invalidateSafeAreaInsets)
                                               name:UIKeyboardDidChangeFrameNotification
                                             object:nil];
#endif
  }
  return self;
}

- (void)safeAreaInsetsDidChange
{
  [self invalidateSafeAreaInsets];
}

- (void)invalidateSafeAreaInsets
{
  // This gets called before the view size is set by react-native so
  // make sure to wait so we don't set wrong insets to JS.
  if (CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
    return;
  }

  UIEdgeInsets safeAreaInsets = self.safeAreaInsets;
  CGRect frame = [self convertRect:self.bounds toView:nil];

  if (_initialInsetsSent &&
      UIEdgeInsetsEqualToEdgeInsetsWithThreshold(safeAreaInsets, _currentSafeAreaInsets, 1.0 / ABI50_0_0RCTScreenScale()) &&
      CGRectEqualToRect(frame, _currentFrame)) {
    return;
  }

  _initialInsetsSent = YES;
  _currentSafeAreaInsets = safeAreaInsets;
  _currentFrame = frame;

  [NSNotificationCenter.defaultCenter postNotificationName:ABI50_0_0RNCSafeAreaDidChange object:self userInfo:nil];

  self.onInsetsChange(@{
    @"insets" : @{
      @"top" : @(safeAreaInsets.top),
      @"right" : @(safeAreaInsets.right),
      @"bottom" : @(safeAreaInsets.bottom),
      @"left" : @(safeAreaInsets.left),
    },
    @"frame" : @{
      @"x" : @(frame.origin.x),
      @"y" : @(frame.origin.y),
      @"width" : @(frame.size.width),
      @"height" : @(frame.size.height),
    },
  });
}

- (void)layoutSubviews
{
  [super layoutSubviews];

  [self invalidateSafeAreaInsets];
}

@end
