// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXReactCompatibleHelpers.h>

#import <ABI50_0_0React/ABI50_0_0RCTRootView.h>

#if __has_include(<ABI50_0_0React-RCTAppDelegate/ABI50_0_0RCTAppSetupUtils.h>)
#import <ABI50_0_0React-RCTAppDelegate/ABI50_0_0RCTAppSetupUtils.h>
#elif __has_include(<ABI50_0_0React_RCTAppDelegate/ABI50_0_0RCTAppSetupUtils.h>)
// for importing the header from framework, the dash will be transformed to underscore
#import <ABI50_0_0React_RCTAppDelegate/ABI50_0_0RCTAppSetupUtils.h>
#else
// react-native < 0.72
#import <ABI50_0_0React/ABI50_0_0RCTAppSetupUtils.h>
#endif

UIView *ABI50_0_0EXAppSetupDefaultRootView(ABI50_0_0RCTBridge *bridge, NSString *moduleName, NSDictionary *initialProperties, BOOL fabricEnabled)
{
  // Originally the ABI50_0_0EXAppSetupDefaultRootView is for backward compatible,
  // it is now exactly the same as ABI50_0_0RCTAppSetupDefaultRootView.
  // Would like to keep this file longer and see if we still need this in the future.
  // Remove this when we drop SDK 49
  return ABI50_0_0RCTAppSetupDefaultRootView(bridge, moduleName, initialProperties, fabricEnabled);
}

