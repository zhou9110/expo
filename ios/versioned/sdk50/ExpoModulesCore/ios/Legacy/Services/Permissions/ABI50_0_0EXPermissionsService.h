// Copyright 2016-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXExportedModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryConsumer.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXPermissionsInterface.h>

@interface ABI50_0_0EXPermissionsService : ABI50_0_0EXExportedModule <ABI50_0_0EXPermissionsInterface, ABI50_0_0EXModuleRegistryConsumer>

+ (ABI50_0_0EXPermissionStatus)statusForPermission:(NSDictionary *)permission;

+ (NSString *)permissionStringForStatus:(ABI50_0_0EXPermissionStatus)status;

- (void)askForGlobalPermissionUsingRequesterClass:(Class)requesterClass
                                    withResolver:(ABI50_0_0EXPromiseResolveBlock)resolver
                                    withRejecter:(ABI50_0_0EXPromiseRejectBlock)reject;

- (NSDictionary *)getPermissionUsingRequesterClass:(Class)requesterClass;

@end
