/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTModalHostViewManager.h"

#import "ABI50_0_0RCTBridge.h"
#import "ABI50_0_0RCTModalHostView.h"
#import "ABI50_0_0RCTModalHostViewController.h"
#import "ABI50_0_0RCTModalManager.h"
#import "ABI50_0_0RCTShadowView.h"
#import "ABI50_0_0RCTUtils.h"

@implementation ABI50_0_0RCTConvert (ABI50_0_0RCTModalHostView)

ABI50_0_0RCT_ENUM_CONVERTER(
    UIModalPresentationStyle,
    (@{
      @"fullScreen" : @(UIModalPresentationFullScreen),
      @"pageSheet" : @(UIModalPresentationPageSheet),
      @"formSheet" : @(UIModalPresentationFormSheet),
      @"overFullScreen" : @(UIModalPresentationOverFullScreen),
    }),
    UIModalPresentationFullScreen,
    integerValue)

@end

@interface ABI50_0_0RCTModalHostShadowView : ABI50_0_0RCTShadowView

@end

@implementation ABI50_0_0RCTModalHostShadowView

- (void)insertABI50_0_0ReactSubview:(id<ABI50_0_0RCTComponent>)subview atIndex:(NSInteger)atIndex
{
  [super insertABI50_0_0ReactSubview:subview atIndex:atIndex];
  if ([subview isKindOfClass:[ABI50_0_0RCTShadowView class]]) {
    ((ABI50_0_0RCTShadowView *)subview).size = ABI50_0_0RCTScreenSize();
  }
}

@end

@interface ABI50_0_0RCTModalHostViewManager () <ABI50_0_0RCTModalHostViewInteractor>

@end

@implementation ABI50_0_0RCTModalHostViewManager {
  NSPointerArray *_hostViews;
}

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  ABI50_0_0RCTModalHostView *view = [[ABI50_0_0RCTModalHostView alloc] initWithBridge:self.bridge];
  view.delegate = self;
  if (!_hostViews) {
    _hostViews = [NSPointerArray weakObjectsPointerArray];
  }
  [_hostViews addPointer:(__bridge void *)view];
  return view;
}

- (void)presentModalHostView:(ABI50_0_0RCTModalHostView *)modalHostView
          withViewController:(ABI50_0_0RCTModalHostViewController *)viewController
                    animated:(BOOL)animated
{
  dispatch_block_t completionBlock = ^{
    if (modalHostView.onShow) {
      modalHostView.onShow(nil);
    }
  };
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_presentationBlock) {
      self->_presentationBlock([modalHostView ABI50_0_0ReactViewController], viewController, animated, completionBlock);
    } else {
      [[modalHostView ABI50_0_0ReactViewController] presentViewController:viewController
                                                        animated:animated
                                                      completion:completionBlock];
    }
  });
}

- (void)dismissModalHostView:(ABI50_0_0RCTModalHostView *)modalHostView
          withViewController:(ABI50_0_0RCTModalHostViewController *)viewController
                    animated:(BOOL)animated
{
  dispatch_block_t completionBlock = ^{
    if (modalHostView.identifier) {
      [[self.bridge moduleForClass:[ABI50_0_0RCTModalManager class]] modalDismissed:modalHostView.identifier];
    }
  };
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_dismissalBlock) {
      self->_dismissalBlock([modalHostView ABI50_0_0ReactViewController], viewController, animated, completionBlock);
    } else {
      [viewController.presentingViewController dismissViewControllerAnimated:animated completion:completionBlock];
    }
  });
}

- (ABI50_0_0RCTShadowView *)shadowView
{
  return [ABI50_0_0RCTModalHostShadowView new];
}

- (void)invalidate
{
  for (ABI50_0_0RCTModalHostView *hostView in _hostViews) {
    [hostView invalidate];
  }
  _hostViews = nil;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(animationType, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(presentationStyle, UIModalPresentationStyle)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(transparent, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(statusBarTranslucent, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(hardwareAccelerated, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(animated, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onShow, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(identifier, NSNumber)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(supportedOrientations, NSArray)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onOrientationChange, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(visible, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onRequestClose, ABI50_0_0RCTDirectEventBlock)

// Fabric only
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onDismiss, ABI50_0_0RCTDirectEventBlock)

@end
