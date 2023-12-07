// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0EXNotifications/ABI50_0_0EXBadgeModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXUtilities.h>
#import <UserNotifications/UserNotifications.h>

@implementation ABI50_0_0EXBadgeModule

ABI50_0_0EX_EXPORT_MODULE(ExpoBadgeModule)

ABI50_0_0EX_EXPORT_METHOD_AS(getBadgeCountAsync,
                    getBadgeCountAsync:(ABI50_0_0EXPromiseResolveBlock)resolve reject:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    resolve(@([ABI50_0_0EXSharedApplication() applicationIconBadgeNumber]));
  });
}

ABI50_0_0EX_EXPORT_METHOD_AS(setBadgeCountAsync,
                    setBadgeCountAsync:(NSNumber *)badgeCount
                    resolve:(ABI50_0_0EXPromiseResolveBlock)resolve
                    reject:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (settings.badgeSetting == UNNotificationSettingEnabled) {
        [ABI50_0_0EXSharedApplication() setApplicationIconBadgeNumber:badgeCount.integerValue];
        resolve(@(YES));
      } else {
        resolve(@(NO));
      }
    });
  }];
}

@end
