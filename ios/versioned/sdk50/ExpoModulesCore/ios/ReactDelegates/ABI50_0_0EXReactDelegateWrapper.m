// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXReactDelegateWrapper.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXAppDefines.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXReactDelegateWrapper+Private.h>

@interface ABI50_0_0EXReactDelegateWrapper()

@property (nonatomic, weak) ABI50_0_0EXReactDelegate *expoReactDelegate;

@end

@implementation ABI50_0_0EXReactDelegateWrapper

- (instancetype)initWithExpoReactDelegate:(ABI50_0_0EXReactDelegate *)expoReactDelegate
{
  if (self = [super init]) {
    _expoReactDelegate = expoReactDelegate;
  }
  return self;
}

- (ABI50_0_0RCTBridge *)createBridgeWithDelegate:(id<ABI50_0_0RCTBridgeDelegate>)delegate
                          launchOptions:(nullable NSDictionary *)launchOptions
{
  return [_expoReactDelegate createBridgeWithDelegate:delegate launchOptions:launchOptions];
}

- (ABI50_0_0RCTRootView *)createRootViewWithBridge:(ABI50_0_0RCTBridge *)bridge
                               moduleName:(NSString *)moduleName
                        initialProperties:(nullable NSDictionary *)initialProperties
{
  return [_expoReactDelegate createRootViewWithBridge:bridge
                                           moduleName:moduleName
                                    initialProperties:initialProperties
                                        fabricEnabled:ABI50_0_0EXAppDefines.APP_NEW_ARCH_ENABLED];
}

- (ABI50_0_0RCTRootView *)createRootViewWithBridge:(ABI50_0_0RCTBridge *)bridge
                               moduleName:(NSString *)moduleName
                        initialProperties:(nullable NSDictionary *)initialProperties
                            fabricEnabled:(BOOL)fabricEnabled
{
  return [_expoReactDelegate createRootViewWithBridge:bridge moduleName:moduleName initialProperties:initialProperties fabricEnabled:fabricEnabled];
}

- (UIViewController *)createRootViewController
{
  return [_expoReactDelegate createRootViewController];
}

@end
