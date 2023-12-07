// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0EXNotifications/ABI50_0_0EXNotificationPermissionsModule.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXPermissionsInterface.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXPermissionsMethodsDelegate.h>

#import <ABI50_0_0EXNotifications/ABI50_0_0EXLegacyRemoteNotificationPermissionRequester.h>
#import <ABI50_0_0EXNotifications/ABI50_0_0EXUserFacingNotificationsPermissionsRequester.h>

@interface ABI50_0_0EXNotificationPermissionsModule ()

@property (nonatomic, weak) id<ABI50_0_0EXPermissionsInterface> permissionsManager;
@property (nonatomic, strong) ABI50_0_0EXUserFacingNotificationsPermissionsRequester *requester;
@property (nonatomic, strong) ABI50_0_0EXLegacyRemoteNotificationPermissionRequester *legacyRemoteNotificationsRequester;

@end

@implementation ABI50_0_0EXNotificationPermissionsModule

ABI50_0_0EX_EXPORT_MODULE(ExpoNotificationPermissionsModule);

- (instancetype)init
{
  if (self = [super init]) {
    _requester = [[ABI50_0_0EXUserFacingNotificationsPermissionsRequester alloc] initWithMethodQueue:self.methodQueue];
  }
  return self;
}

# pragma mark - Exported methods

ABI50_0_0EX_EXPORT_METHOD_AS(getPermissionsAsync,
                    getPermissionsAsync:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  [ABI50_0_0EXPermissionsMethodsDelegate getPermissionWithPermissionsManager:_permissionsManager
                                                      withRequester:[ABI50_0_0EXUserFacingNotificationsPermissionsRequester class]
                                                            resolve:resolve
                                                             reject:reject];
}

ABI50_0_0EX_EXPORT_METHOD_AS(requestPermissionsAsync,
                    requestPermissionsAsync:(NSDictionary *)requestedPermissions
                    requester:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  [ABI50_0_0EXUserFacingNotificationsPermissionsRequester setRequestedPermissions:requestedPermissions];
  [ABI50_0_0EXPermissionsMethodsDelegate askForPermissionWithPermissionsManager:_permissionsManager
                                                         withRequester:[ABI50_0_0EXUserFacingNotificationsPermissionsRequester class]
                                                               resolve:resolve
                                                                reject:reject];
}

# pragma mark - ABI50_0_0EXModuleRegistryConsumer

- (void)setModuleRegistry:(ABI50_0_0EXModuleRegistry *)moduleRegistry {
  _permissionsManager = [moduleRegistry getModuleImplementingProtocol:@protocol(ABI50_0_0EXPermissionsInterface)];
  if (!_legacyRemoteNotificationsRequester) {
    // TODO: Remove once we deprecate and remove "notifications" permission type
    _legacyRemoteNotificationsRequester = [[ABI50_0_0EXLegacyRemoteNotificationPermissionRequester alloc] initWithUserNotificationPermissionRequester:_requester permissionPublisher:[moduleRegistry getSingletonModuleForName:@"RemoteNotificationPermissionPublisher"] withMethodQueue:self.methodQueue];
  }
  [ABI50_0_0EXPermissionsMethodsDelegate registerRequesters:@[_requester, _legacyRemoteNotificationsRequester]
                            withPermissionsManager:_permissionsManager];
}

@end
