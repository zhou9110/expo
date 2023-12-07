// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXExportedModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryConsumer.h>
#import <ABI50_0_0EXNotifications/ABI50_0_0EXNotificationsDelegate.h>

@interface ABI50_0_0EXNotificationPresentationModule : ABI50_0_0EXExportedModule <ABI50_0_0EXModuleRegistryConsumer, ABI50_0_0EXNotificationsDelegate>

- (NSArray * _Nonnull)serializeNotifications:(NSArray<UNNotification *> * _Nonnull)notifications;

- (void)dismissNotificationWithIdentifier:(NSString *)identifier resolve:(ABI50_0_0EXPromiseResolveBlock)resolve reject:(ABI50_0_0EXPromiseRejectBlock)reject;

@end
