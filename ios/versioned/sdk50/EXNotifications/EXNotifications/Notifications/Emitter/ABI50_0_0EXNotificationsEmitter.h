// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXExportedModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXEventEmitter.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryConsumer.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXEventEmitterService.h>

#import <ABI50_0_0EXNotifications/ABI50_0_0EXNotificationsDelegate.h>

static NSString * const onDidReceiveNotification = @"onDidReceiveNotification";
static NSString * const onDidReceiveNotificationResponse = @"onDidReceiveNotificationResponse";

@interface ABI50_0_0EXNotificationsEmitter : ABI50_0_0EXExportedModule <ABI50_0_0EXEventEmitter, ABI50_0_0EXModuleRegistryConsumer, ABI50_0_0EXNotificationsDelegate>

@property (nonatomic, weak, readonly) id<ABI50_0_0EXEventEmitterService> eventEmitter;

@end
