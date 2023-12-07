// Copyright 2018-present 650 Industries. All rights reserved.

#import <UIKit/UIKit.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXDefines.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>


ABI50_0_0EX_EXTERN_C_BEGIN

/**
 * Enhanced `ABI50_0_0RCTAppSetupDefaultRootView`.
 */
UIView *ABI50_0_0EXAppSetupDefaultRootView(ABI50_0_0RCTBridge *bridge, NSString *moduleName, NSDictionary *initialProperties, BOOL fabricEnabled);

ABI50_0_0EX_EXTERN_C_END
