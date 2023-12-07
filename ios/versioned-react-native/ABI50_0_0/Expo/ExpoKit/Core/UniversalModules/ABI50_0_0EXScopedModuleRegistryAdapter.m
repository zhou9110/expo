// Copyright © 2018 650 Industries. All rights reserved.

#import "ABI50_0_0EXScopedModuleRegistry.h"

#import "ABI50_0_0EXScopedModuleRegistryAdapter.h"
#import "ABI50_0_0EXSensorsManagerBinding.h"
#import "ABI50_0_0EXConstantsBinding.h"
#import "ABI50_0_0EXUnversioned.h"
#import "ABI50_0_0EXScopedFilePermissionModule.h"
#import "ABI50_0_0EXScopedFontLoader.h"
#import "ABI50_0_0EXScopedSecureStore.h"
#import "ABI50_0_0EXScopedPermissions.h"
#import "ABI50_0_0EXScopedSegment.h"
#import "ABI50_0_0EXScopedLocalAuthentication.h"
#import "ABI50_0_0EXScopedErrorRecoveryModule.h"
#import "ABI50_0_0EXScopedFacebook.h"
#import "ABI50_0_0EXScopedFirebaseCore.h"

#import "ABI50_0_0EXScopedReactNativeAdapter.h"
#import "ABI50_0_0EXExpoUserNotificationCenterProxy.h"

#import "ABI50_0_0EXScopedNotificationsEmitter.h"
#import "ABI50_0_0EXScopedNotificationsHandlerModule.h"
#import "ABI50_0_0EXScopedNotificationBuilder.h"
#import "ABI50_0_0EXScopedNotificationSchedulerModule.h"
#import "ABI50_0_0EXScopedNotificationPresentationModule.h"
#import "ABI50_0_0EXScopedNotificationCategoriesModule.h"
#import "ABI50_0_0EXScopedServerRegistrationModule.h"

#import <ABI50_0_0ExpoFileSystem/ABI50_0_0EXFileSystem.h>

#if __has_include(<ABI50_0_0EXTaskManager/ABI50_0_0EXTaskManager.h>)
#import <ABI50_0_0EXTaskManager/ABI50_0_0EXTaskManager.h>
#endif

@implementation ABI50_0_0EXScopedModuleRegistryAdapter

- (ABI50_0_0EXModuleRegistry *)moduleRegistryForParams:(NSDictionary *)params
                  forExperienceStableLegacyId:(NSString *)experienceStableLegacyId
                                     scopeKey:(NSString *)scopeKey
                                     manifest:(ABI50_0_0EXManifestsManifest *)manifest
                           withKernelServices:(NSDictionary *)kernelServices
{
  ABI50_0_0EXModuleRegistry *moduleRegistry = [self.moduleRegistryProvider moduleRegistry];

#if __has_include(<ABI50_0_0EXConstants/ABI50_0_0EXConstantsService.h>)
  ABI50_0_0EXConstantsBinding *constantsBinding = [[ABI50_0_0EXConstantsBinding alloc] initWithParams:params];
  [moduleRegistry registerInternalModule:constantsBinding];
#endif

#if __has_include(<ABI50_0_0EXFacebook/ABI50_0_0EXFacebook.h>)
  // only override in Expo Go
  if ([params[@"constants"][@"appOwnership"] isEqualToString:@"expo"]) {
    ABI50_0_0EXScopedFacebook *scopedFacebook = [[ABI50_0_0EXScopedFacebook alloc] initWithScopeKey:scopeKey manifest:manifest];
    [moduleRegistry registerExportedModule:scopedFacebook];
  }
#endif

#if __has_include(<ABI50_0_0ExpoFileSystem/ABI50_0_0EXFileSystem.h>)
  if (params[@"fileSystemDirectories"]) {
    // Override the FileSystem module with custom document and cache directories
    NSString *documentDirectory = params[@"fileSystemDirectories"][@"documentDirectory"];
    NSString *cachesDirectory = params[@"fileSystemDirectories"][@"cachesDirectory"];
    ABI50_0_0EXFileSystem *fileSystemModule = [[ABI50_0_0EXFileSystem alloc] initWithDocumentDirectory:documentDirectory
                                                                     cachesDirectory:cachesDirectory];
    [moduleRegistry registerExportedModule:fileSystemModule];
    [moduleRegistry registerInternalModule:fileSystemModule];
  }
#endif

#if __has_include(<ABI50_0_0EXFont/ABI50_0_0EXFontLoader.h>)
  ABI50_0_0EXScopedFontLoader *fontModule = [[ABI50_0_0EXScopedFontLoader alloc] init];
  [moduleRegistry registerExportedModule:fontModule];
#endif

#if __has_include(<ABI50_0_0EXSensors/ABI50_0_0EXSensorsManager.h>)
  ABI50_0_0EXSensorsManagerBinding *sensorsManagerBinding = [[ABI50_0_0EXSensorsManagerBinding alloc] initWithScopeKey:scopeKey andKernelService:kernelServices[@"EXSensorManager"]];
  [moduleRegistry registerInternalModule:sensorsManagerBinding];
#endif

  ABI50_0_0EXScopedReactNativeAdapter *ABI50_0_0ReactNativeAdapter = [[ABI50_0_0EXScopedReactNativeAdapter alloc] init];
  [moduleRegistry registerInternalModule:ABI50_0_0ReactNativeAdapter];

  ABI50_0_0EXExpoUserNotificationCenterProxy *userNotificationCenter = [[ABI50_0_0EXExpoUserNotificationCenterProxy alloc] initWithUserNotificationCenter:kernelServices[@"EXUserNotificationCenter"]];
  [moduleRegistry registerInternalModule:userNotificationCenter];

#if __has_include(<ABI50_0_0ExpoFileSystem/ABI50_0_0EXFilePermissionModule.h>)
  ABI50_0_0EXScopedFilePermissionModule *filePermissionModule = [[ABI50_0_0EXScopedFilePermissionModule alloc] init];
  [moduleRegistry registerInternalModule:filePermissionModule];
#endif

#if __has_include(<ABI50_0_0EXSecureStore/ABI50_0_0EXSecureStore.h>)
  ABI50_0_0EXScopedSecureStore *secureStoreModule = [[ABI50_0_0EXScopedSecureStore alloc] initWithScopeKey:scopeKey andConstantsBinding:constantsBinding];
  [moduleRegistry registerExportedModule:secureStoreModule];
#endif

#if __has_include(<ABI50_0_0ExpoModulesCore/ABI50_0_0EXPermissionsService.h>)
  ABI50_0_0EXScopedPermissions *permissionsModule = [[ABI50_0_0EXScopedPermissions alloc] initWithScopeKey:scopeKey andConstantsBinding:constantsBinding];
  [moduleRegistry registerExportedModule:permissionsModule];
  [moduleRegistry registerInternalModule:permissionsModule];
#endif

#if __has_include(<ABI50_0_0EXSegment/ABI50_0_0EXSegment.h>)
  ABI50_0_0EXScopedSegment *segmentModule = [[ABI50_0_0EXScopedSegment alloc] init];
  [moduleRegistry registerExportedModule:segmentModule];
#endif

#if __has_include(<ABI50_0_0EXLocalAuthentication/ABI50_0_0EXLocalAuthentication.h>)
  ABI50_0_0EXScopedLocalAuthentication *localAuthenticationModule = [[ABI50_0_0EXScopedLocalAuthentication alloc] init];
  [moduleRegistry registerExportedModule:localAuthenticationModule];
#endif

#if __has_include(<ABI50_0_0EXTaskManager/ABI50_0_0EXTaskManager.h>)
  // TODO: Make scoped task manager when adding support for bare ABI50_0_0React Native
  ABI50_0_0EXTaskManager *taskManagerModule = [[ABI50_0_0EXTaskManager alloc] initWithScopeKey:scopeKey];
  [moduleRegistry registerInternalModule:taskManagerModule];
  [moduleRegistry registerExportedModule:taskManagerModule];
#endif

#if __has_include(<ABI50_0_0EXErrorRecovery/ABI50_0_0EXErrorRecoveryModule.h>)
  ABI50_0_0EXScopedErrorRecoveryModule *errorRecovery = [[ABI50_0_0EXScopedErrorRecoveryModule alloc] initWithScopeKey:scopeKey];
  [moduleRegistry registerExportedModule:errorRecovery];
#endif

#if __has_include(<ABI50_0_0EXFirebaseCore/ABI50_0_0EXFirebaseCore.h>)
  ABI50_0_0EXScopedFirebaseCore *firebaseCoreModule = [[ABI50_0_0EXScopedFirebaseCore alloc] initWithScopeKey:scopeKey manifest:manifest constantsBinding:constantsBinding];
  [moduleRegistry registerExportedModule:firebaseCoreModule];
  [moduleRegistry registerInternalModule:firebaseCoreModule];
#endif

#if __has_include(<ABI50_0_0EXNotifications/ABI50_0_0EXNotificationsEmitter.h>)
  // only override in Expo Go
  if ([params[@"constants"][@"appOwnership"] isEqualToString:@"expo"]) {
    ABI50_0_0EXScopedNotificationsEmitter *notificationsEmmitter = [[ABI50_0_0EXScopedNotificationsEmitter alloc] initWithScopeKey:scopeKey];
    [moduleRegistry registerExportedModule:notificationsEmmitter];
  }
#endif

#if __has_include(<ABI50_0_0EXNotifications/ABI50_0_0EXNotificationsHandlerModule.h>)
  // only override in Expo Go
  if ([params[@"constants"][@"appOwnership"] isEqualToString:@"expo"]) {
    ABI50_0_0EXScopedNotificationsHandlerModule *notificationsHandler = [[ABI50_0_0EXScopedNotificationsHandlerModule alloc] initWithScopeKey:scopeKey];
    [moduleRegistry registerExportedModule:notificationsHandler];
  }
#endif

#if __has_include(<ABI50_0_0EXNotifications/ABI50_0_0EXNotificationsHandlerModule.h>)
  ABI50_0_0EXScopedNotificationBuilder *notificationsBuilder = [[ABI50_0_0EXScopedNotificationBuilder alloc] initWithScopeKey:scopeKey
                                                                                                  andConstantsBinding:constantsBinding];
  [moduleRegistry registerInternalModule:notificationsBuilder];
#endif

#if __has_include(<ABI50_0_0EXNotifications/ABI50_0_0EXNotificationSchedulerModule.h>)
  // only override in Expo Go
  if ([params[@"constants"][@"appOwnership"] isEqualToString:@"expo"]) {
    ABI50_0_0EXScopedNotificationSchedulerModule *schedulerModule = [[ABI50_0_0EXScopedNotificationSchedulerModule alloc] initWithScopeKey:scopeKey];
    [moduleRegistry registerExportedModule:schedulerModule];
  }
#endif

#if __has_include(<ABI50_0_0EXNotifications/ABI50_0_0EXNotificationPresentationModule.h>)
  // only override in Expo Go
  if ([params[@"constants"][@"appOwnership"] isEqualToString:@"expo"]) {
    ABI50_0_0EXScopedNotificationPresentationModule *notificationPresentationModule = [[ABI50_0_0EXScopedNotificationPresentationModule alloc] initWithScopeKey:scopeKey];
    [moduleRegistry registerExportedModule:notificationPresentationModule];
  }
#endif

#if __has_include(<ABI50_0_0EXNotifications/ABI50_0_0EXNotificationCategoriesModule.h>)
  // only override in Expo Go
  if ([params[@"constants"][@"appOwnership"] isEqualToString:@"expo"]) {
    ABI50_0_0EXScopedNotificationCategoriesModule *scopedCategoriesModule = [[ABI50_0_0EXScopedNotificationCategoriesModule alloc] initWithScopeKey:scopeKey];
    [moduleRegistry registerExportedModule:scopedCategoriesModule];
  }
  [ABI50_0_0EXScopedNotificationCategoriesModule maybeMigrateLegacyCategoryIdentifiersForProjectWithExperienceStableLegacyId:experienceStableLegacyId
                                                                                                 scopeKey:scopeKey
                                                                                                         isInExpoGo:[params[@"constants"][@"appOwnership"] isEqualToString:@"expo"]];
#endif

#if __has_include(<ABI50_0_0EXNotifications/ABI50_0_0EXServerRegistrationModule.h>)
  ABI50_0_0EXScopedServerRegistrationModule *serverRegistrationModule = [[ABI50_0_0EXScopedServerRegistrationModule alloc] initWithScopeKey:scopeKey];
  [moduleRegistry registerExportedModule:serverRegistrationModule];
#endif

  return moduleRegistry;
}

@end
