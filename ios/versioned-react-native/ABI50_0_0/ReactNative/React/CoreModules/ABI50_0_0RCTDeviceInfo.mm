/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTDeviceInfo.h"

#import <ABI50_0_0FBReactNativeSpec/ABI50_0_0FBReactNativeSpec.h>
#import <ABI50_0_0React/ABI50_0_0RCTAccessibilityManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTAssert.h>
#import <ABI50_0_0React/ABI50_0_0RCTConstants.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcherProtocol.h>
#import <ABI50_0_0React/ABI50_0_0RCTInitializing.h>
#import <ABI50_0_0React/ABI50_0_0RCTInvalidating.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIUtils.h>
#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>

#import "ABI50_0_0CoreModulesPlugins.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

@interface ABI50_0_0RCTDeviceInfo () <ABI50_0_0NativeDeviceInfoSpec, ABI50_0_0RCTInitializing, ABI50_0_0RCTInvalidating>
@end

@implementation ABI50_0_0RCTDeviceInfo {
  UIInterfaceOrientation _currentInterfaceOrientation;
  NSDictionary *_currentInterfaceDimensions;
  BOOL _isFullscreen;
  BOOL _invalidated;
}

@synthesize moduleRegistry = _moduleRegistry;

ABI50_0_0RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

- (void)initialize
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didReceiveNewContentSizeMultiplier)
                                               name:ABI50_0_0RCTAccessibilityManagerDidUpdateMultiplierNotification
                                             object:[_moduleRegistry moduleForName:"AccessibilityManager"]];

  _currentInterfaceOrientation = [ABI50_0_0RCTSharedApplication() statusBarOrientation];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(interfaceOrientationDidChange)
                                               name:UIApplicationDidChangeStatusBarOrientationNotification
                                             object:nil];

  _currentInterfaceDimensions = [self _exportedDimensions];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(interfaceOrientationDidChange)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(interfaceFrameDidChange)
                                               name:ABI50_0_0RCTUserInterfaceStyleDidChangeNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(interfaceFrameDidChange)
                                               name:ABI50_0_0RCTWindowFrameDidChangeNotification
                                             object:nil];
}

- (void)invalidate
{
  _invalidated = YES;
}

static BOOL ABI50_0_0RCTIsIPhoneNotched()
{
  static BOOL isIPhoneNotched = NO;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    ABI50_0_0RCTAssertMainQueue();

    // 20pt is the top safeArea value in non-notched devices
    isIPhoneNotched = ABI50_0_0RCTSharedApplication().keyWindow.safeAreaInsets.top > 20;
  });

  return isIPhoneNotched;
}

static NSDictionary *ABI50_0_0RCTExportedDimensions(CGFloat fontScale)
{
  ABI50_0_0RCTAssertMainQueue();
  ABI50_0_0RCTDimensions dimensions = ABI50_0_0RCTGetDimensions(fontScale);
  __typeof(dimensions.window) window = dimensions.window;
  NSDictionary<NSString *, NSNumber *> *dimsWindow = @{
    @"width" : @(window.width),
    @"height" : @(window.height),
    @"scale" : @(window.scale),
    @"fontScale" : @(window.fontScale)
  };
  __typeof(dimensions.screen) screen = dimensions.screen;
  NSDictionary<NSString *, NSNumber *> *dimsScreen = @{
    @"width" : @(screen.width),
    @"height" : @(screen.height),
    @"scale" : @(screen.scale),
    @"fontScale" : @(screen.fontScale)
  };
  return @{@"window" : dimsWindow, @"screen" : dimsScreen};
}

- (NSDictionary *)_exportedDimensions
{
  ABI50_0_0RCTAssert(!_invalidated, @"Failed to get exported dimensions: ABI50_0_0RCTDeviceInfo has been invalidated");
  ABI50_0_0RCTAssert(_moduleRegistry, @"Failed to get exported dimensions: ABI50_0_0RCTModuleRegistry is nil");
  ABI50_0_0RCTAccessibilityManager *accessibilityManager =
      (ABI50_0_0RCTAccessibilityManager *)[_moduleRegistry moduleForName:"AccessibilityManager"];
  ABI50_0_0RCTAssert(accessibilityManager, @"Failed to get exported dimensions: AccessibilityManager is nil");
  CGFloat fontScale = accessibilityManager ? accessibilityManager.multiplier : 1.0;
  return ABI50_0_0RCTExportedDimensions(fontScale);
}

- (NSDictionary<NSString *, id> *)constantsToExport
{
  return [self getConstants];
}

- (NSDictionary<NSString *, id> *)getConstants
{
  __block NSDictionary<NSString *, id> *constants;
  __weak __typeof(self) weakSelf = self;
  ABI50_0_0RCTUnsafeExecuteOnMainQueueSync(^{
    constants = @{
      @"Dimensions" : [weakSelf _exportedDimensions],
      // Note:
      // This prop is deprecated and will be removed in a future release.
      // Please use this only for a quick and temporary solution.
      // Use <SafeAreaView> instead.
      @"isIPhoneX_deprecated" : @(ABI50_0_0RCTIsIPhoneNotched()),
    };
  });

  return constants;
}

- (void)didReceiveNewContentSizeMultiplier
{
  __weak __typeof(self) weakSelf = self;
  ABI50_0_0RCTModuleRegistry *moduleRegistry = _moduleRegistry;
  ABI50_0_0RCTExecuteOnMainQueue(^{
  // Report the event across the bridge.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[moduleRegistry moduleForName:"EventDispatcher"] sendDeviceEventWithName:@"didUpdateDimensions"
                                                                         body:[weakSelf _exportedDimensions]];
#pragma clang diagnostic pop
  });
}

- (void)interfaceOrientationDidChange
{
  __weak __typeof(self) weakSelf = self;
  ABI50_0_0RCTExecuteOnMainQueue(^{
    [weakSelf _interfaceOrientationDidChange];
  });
}

- (void)_interfaceOrientationDidChange
{
  UIApplication *application = ABI50_0_0RCTSharedApplication();
  UIInterfaceOrientation nextOrientation = [application statusBarOrientation];

  BOOL isRunningInFullScreen =
      CGRectEqualToRect(application.delegate.window.frame, application.delegate.window.screen.bounds);
  // We are catching here two situations for multitasking view:
  // a) The app is in Split View and the container gets resized -> !isRunningInFullScreen
  // b) The app changes to/from fullscreen example: App runs in slide over mode and goes into fullscreen->
  // isRunningInFullScreen != _isFullscreen The above two cases a || b can be shortened to !isRunningInFullScreen ||
  // !_isFullscreen;
  BOOL isResizingOrChangingToFullscreen = !isRunningInFullScreen || !_isFullscreen;
  BOOL isOrientationChanging = (UIInterfaceOrientationIsPortrait(_currentInterfaceOrientation) &&
                                !UIInterfaceOrientationIsPortrait(nextOrientation)) ||
      (UIInterfaceOrientationIsLandscape(_currentInterfaceOrientation) &&
       !UIInterfaceOrientationIsLandscape(nextOrientation));

  // Update when we go from portrait to landscape, or landscape to portrait
  // Also update when the fullscreen state changes (multitasking) and only when the app is in active state.
  if ((isOrientationChanging || isResizingOrChangingToFullscreen) && ABI50_0_0RCTIsAppActive()) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[_moduleRegistry moduleForName:"EventDispatcher"] sendDeviceEventWithName:@"didUpdateDimensions"
                                                                          body:[self _exportedDimensions]];
    // We only want to track the current _currentInterfaceOrientation and _isFullscreen only
    // when it happens and only when it is published.
    _currentInterfaceOrientation = nextOrientation;
    _isFullscreen = isRunningInFullScreen;
#pragma clang diagnostic pop
  }
}

- (void)interfaceFrameDidChange
{
  __weak __typeof(self) weakSelf = self;
  ABI50_0_0RCTExecuteOnMainQueue(^{
    [weakSelf _interfaceFrameDidChange];
  });
}

- (void)_interfaceFrameDidChange
{
  NSDictionary *nextInterfaceDimensions = [self _exportedDimensions];

  // update and publish the even only when the app is in active state
  if (!([nextInterfaceDimensions isEqual:_currentInterfaceDimensions]) && ABI50_0_0RCTIsAppActive()) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[_moduleRegistry moduleForName:"EventDispatcher"] sendDeviceEventWithName:@"didUpdateDimensions"
                                                                          body:nextInterfaceDimensions];
    // We only want to track the current _currentInterfaceOrientation only
    // when it happens and only when it is published.
    _currentInterfaceDimensions = nextInterfaceDimensions;
#pragma clang diagnostic pop
  }
}

- (std::shared_ptr<TurboModule>)getTurboModule:(const ObjCTurboModule::InitParams &)params
{
  return std::make_shared<NativeDeviceInfoSpecJSI>(params);
}

@end

Class ABI50_0_0RCTDeviceInfoCls(void)
{
  return ABI50_0_0RCTDeviceInfo.class;
}
