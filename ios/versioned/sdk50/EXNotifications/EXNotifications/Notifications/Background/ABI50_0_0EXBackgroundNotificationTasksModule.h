// Copyright 2021-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXExportedModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryConsumer.h>
#import <ABI50_0_0EXNotifications/ABI50_0_0EXNotificationsDelegate.h>

typedef NS_ENUM(NSUInteger, ABI50_0_0EXBackgroundNotificationResult) {
  ABI50_0_0EXBackgroundNotificationResultNoData = 1,
  ABI50_0_0EXBackgroundNotificationResultNewData = 2,
  ABI50_0_0EXBackgroundNotificationResultFailed = 3,
};

@interface ABI50_0_0EXBackgroundNotificationTasksModule : ABI50_0_0EXExportedModule <ABI50_0_0EXModuleRegistryConsumer>


@end
