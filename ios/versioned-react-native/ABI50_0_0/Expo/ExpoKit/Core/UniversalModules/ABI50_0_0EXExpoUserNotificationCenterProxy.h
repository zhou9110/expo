//  Copyright © 2018 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXInternalModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXUserNotificationCenterProxyInterface.h>

@interface ABI50_0_0EXExpoUserNotificationCenterProxy : NSObject <ABI50_0_0EXInternalModule, ABI50_0_0EXUserNotificationCenterProxyInterface>

- (instancetype)initWithUserNotificationCenter:(id<ABI50_0_0EXUserNotificationCenterProxyInterface>)userNotificationCenter;

@end
