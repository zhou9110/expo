// Copyright 2018-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXSingletonModule.h>
#import <UserNotifications/UserNotifications.h>
#import <ABI50_0_0EXNotifications/ABI50_0_0EXNotificationsDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ABI50_0_0EXNotificationCenterDelegate

- (void)addDelegate:(id<ABI50_0_0EXNotificationsDelegate>)delegate;
- (void)removeDelegate:(id<ABI50_0_0EXNotificationsDelegate>)delegate;

@end

@interface ABI50_0_0EXNotificationCenterDelegate : ABI50_0_0EXSingletonModule <UIApplicationDelegate, UNUserNotificationCenterDelegate, ABI50_0_0EXNotificationCenterDelegate>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler;
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler;
- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification;

@end

NS_ASSUME_NONNULL_END
