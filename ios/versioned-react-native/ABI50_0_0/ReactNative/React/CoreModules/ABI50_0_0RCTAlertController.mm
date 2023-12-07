/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>

#import <ABI50_0_0React/ABI50_0_0RCTAlertController.h>

@interface ABI50_0_0RCTAlertController ()

@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation ABI50_0_0RCTAlertController

- (UIWindow *)alertWindow
{
  if (_alertWindow == nil) {
    _alertWindow = [self getUIWindowFromScene];

    if (_alertWindow == nil) {
      UIWindow *keyWindow = ABI50_0_0RCTSharedApplication().keyWindow;
      if (keyWindow) {
        _alertWindow = [[UIWindow alloc] initWithFrame:keyWindow.bounds];
      } else {
        // keyWindow is nil, so we cannot create and initialize _alertWindow
        NSLog(@"Unable to create alert window: keyWindow is nil");
      }
    }

    if (_alertWindow) {
      _alertWindow.rootViewController = [UIViewController new];
      _alertWindow.windowLevel = UIWindowLevelAlert + 1;
    }
  }

  return _alertWindow;
}

- (void)show:(BOOL)animated completion:(void (^)(void))completion
{
  UIUserInterfaceStyle style = self.overrideUserInterfaceStyle;
  if (style == UIUserInterfaceStyleUnspecified) {
    style = ABI50_0_0RCTSharedApplication().delegate.window.overrideUserInterfaceStyle
        ? ABI50_0_0RCTSharedApplication().delegate.window.overrideUserInterfaceStyle
        : UIUserInterfaceStyleUnspecified;
  }

  self.overrideUserInterfaceStyle = style;

  [self.alertWindow makeKeyAndVisible];
  [self.alertWindow.rootViewController presentViewController:self animated:animated completion:completion];
}

- (void)hide
{
  [_alertWindow setHidden:YES];

  _alertWindow.windowScene = nil;

  _alertWindow = nil;
}

- (UIWindow *)getUIWindowFromScene
{
  for (UIScene *scene in ABI50_0_0RCTSharedApplication().connectedScenes) {
    if (scene.activationState == UISceneActivationStateForegroundActive &&
        [scene isKindOfClass:[UIWindowScene class]]) {
      return [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    }
  }

  return nil;
}

@end
