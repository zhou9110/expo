/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTAppearance.h"

#import <ABI50_0_0FBReactNativeSpec/ABI50_0_0FBReactNativeSpec.h>
#import <ABI50_0_0React/ABI50_0_0RCTConstants.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventEmitter.h>
#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>

#import "ABI50_0_0CoreModulesPlugins.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

NSString *const ABI50_0_0RCTAppearanceColorSchemeLight = @"light";
NSString *const ABI50_0_0RCTAppearanceColorSchemeDark = @"dark";

static BOOL sAppearancePreferenceEnabled = YES;
void ABI50_0_0RCTEnableAppearancePreference(BOOL enabled)
{
  sAppearancePreferenceEnabled = enabled;
}

static NSString *sColorSchemeOverride = nil;
void ABI50_0_0RCTOverrideAppearancePreference(NSString *const colorSchemeOverride)
{
  sColorSchemeOverride = colorSchemeOverride;
}

NSString *ABI50_0_0RCTCurrentOverrideAppearancePreference()
{
  return sColorSchemeOverride;
}

NSString *ABI50_0_0RCTColorSchemePreference(UITraitCollection *traitCollection)
{
  static NSDictionary *appearances;
  static dispatch_once_t onceToken;

  if (sColorSchemeOverride) {
    return sColorSchemeOverride;
  }

  dispatch_once(&onceToken, ^{
    appearances = @{
      @(UIUserInterfaceStyleLight) : ABI50_0_0RCTAppearanceColorSchemeLight,
      @(UIUserInterfaceStyleDark) : ABI50_0_0RCTAppearanceColorSchemeDark
    };
  });

  if (!sAppearancePreferenceEnabled) {
    // Return the default if the app doesn't allow different color schemes.
    return ABI50_0_0RCTAppearanceColorSchemeLight;
  }

  return appearances[@(traitCollection.userInterfaceStyle)] ?: ABI50_0_0RCTAppearanceColorSchemeLight;
}

@interface ABI50_0_0RCTAppearance () <ABI50_0_0NativeAppearanceSpec>
@end

@implementation ABI50_0_0RCTAppearance {
  NSString *_currentColorScheme;
}

- (instancetype)init
{
  if ((self = [super init])) {
    UITraitCollection *traitCollection = ABI50_0_0RCTSharedApplication().delegate.window.traitCollection;
    _currentColorScheme = ABI50_0_0RCTColorSchemePreference(traitCollection);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appearanceChanged:)
                                                 name:ABI50_0_0RCTUserInterfaceStyleDidChangeNotification
                                               object:nil];
  }
  return self;
}

ABI50_0_0RCT_EXPORT_MODULE(Appearance)

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

- (std::shared_ptr<TurboModule>)getTurboModule:(const ObjCTurboModule::InitParams &)params
{
  return std::make_shared<NativeAppearanceSpecJSI>(params);
}

ABI50_0_0RCT_EXPORT_METHOD(setColorScheme : (NSString *)style)
{
  UIUserInterfaceStyle userInterfaceStyle = [ABI50_0_0RCTConvert UIUserInterfaceStyle:style];
  NSArray<__kindof UIWindow *> *windows = ABI50_0_0RCTSharedApplication().windows;

  for (UIWindow *window in windows) {
    window.overrideUserInterfaceStyle = userInterfaceStyle;
  }
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSString *, getColorScheme)
{
  return _currentColorScheme;
}

- (void)appearanceChanged:(NSNotification *)notification
{
  NSDictionary *userInfo = [notification userInfo];
  UITraitCollection *traitCollection = nil;
  if (userInfo) {
    traitCollection = userInfo[ABI50_0_0RCTUserInterfaceStyleDidChangeNotificationTraitCollectionKey];
  }
  NSString *newColorScheme = ABI50_0_0RCTColorSchemePreference(traitCollection);
  if (![_currentColorScheme isEqualToString:newColorScheme]) {
    _currentColorScheme = newColorScheme;
    [self sendEventWithName:@"appearanceChanged" body:@{@"colorScheme" : newColorScheme}];
  }
}

#pragma mark - ABI50_0_0RCTEventEmitter

- (NSArray<NSString *> *)supportedEvents
{
  return @[ @"appearanceChanged" ];
}

- (void)startObserving
{
}

- (void)stopObserving
{
}

- (void)invalidate
{
  [super invalidate];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

Class ABI50_0_0RCTAppearanceCls(void)
{
  return ABI50_0_0RCTAppearance.class;
}
