// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXSingletonModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXTaskServiceInterface.h>
#import <ABI50_0_0EXTaskManager/ABI50_0_0EXTask.h>
#import <ABI50_0_0EXTaskManager/ABI50_0_0EXTaskExecutionRequest.h>

@interface ABI50_0_0EXTaskService : ABI50_0_0EXSingletonModule <ABI50_0_0EXTaskServiceInterface, ABI50_0_0EXTaskDelegate>

+ (BOOL)hasBackgroundModeEnabled:(nonnull NSString *)backgroundMode;

// AppDelegate handlers
- (void)applicationDidFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions;
- (void)runTasksWithReason:(ABI50_0_0EXTaskLaunchReason)launchReason
                  userInfo:(nullable NSDictionary *)userInfo
         completionHandler:(nullable void (^)(UIBackgroundFetchResult))completionHandler;

@end
