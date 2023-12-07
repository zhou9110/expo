// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0EXNotifications/ABI50_0_0EXBackgroundNotificationTasksModule.h>
#import <ABI50_0_0EXNotifications/ABI50_0_0EXBackgroundRemoteNotificationConsumer.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXTaskManagerInterface.h>

@interface ABI50_0_0EXBackgroundNotificationTasksModule ()

@property (nonatomic, weak) id<ABI50_0_0EXTaskManagerInterface> taskManager;

@end

@implementation ABI50_0_0EXBackgroundNotificationTasksModule

ABI50_0_0EX_EXPORT_MODULE(ExpoBackgroundNotificationTasksModule);

# pragma mark - ABI50_0_0EXModuleRegistryConsumer

- (void)setModuleRegistry:(ABI50_0_0EXModuleRegistry *)moduleRegistry
{
  _taskManager = [moduleRegistry getModuleImplementingProtocol:@protocol(ABI50_0_0EXTaskManagerInterface)];
}
# pragma mark - Exported methods

ABI50_0_0EX_EXPORT_METHOD_AS(registerTaskAsync,
                    registerTaskWithName:(nonnull NSString *)taskName
                    resolve:(ABI50_0_0EXPromiseResolveBlock)resolve
                    reject:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  if (![_taskManager hasBackgroundModeEnabled:@"remote-notification"]) {
    return reject(
                  @"E_BACKGROUND_REMOTE_NOTIFICATIONS_DISABLED",
                  @"Background remote notifications have not been configured. To enable it, add `remote-notification` to `UIBackgroundModes` in the application's Info.plist file.",
                  nil
                  );
  }

  @try {
    [_taskManager registerTaskWithName:taskName
                              consumer:ABI50_0_0EXBackgroundRemoteNotificationConsumer.class
                               options:@{}];
  }
  @catch (NSException *e) {
    return reject(e.name, e.reason, nil);
  }
  resolve(nil);
}

ABI50_0_0EX_EXPORT_METHOD_AS(unregisterTaskAsync,
                    unregisterTaskWithName:(nonnull NSString *)taskName
                    resolve:(ABI50_0_0EXPromiseResolveBlock)resolve
                    reject:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  @try {
    [_taskManager unregisterTaskWithName:taskName consumerClass:[ABI50_0_0EXBackgroundRemoteNotificationConsumer class]];
  } @catch (NSException *e) {
    return reject(e.name, e.reason, nil);
  }
  resolve(nil);
}

@end
