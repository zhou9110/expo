// Copyright 2018-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistry.h>

// Many headers of permissions requesters have refs to `ABI50_0_0UMPromise*Block` without importing
// the header declaring it, so we fix it here, but this definitely needs to be removed.
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXUnimodulesCompat.h>

typedef enum ABI50_0_0EXPermissionStatus {
  ABI50_0_0EXPermissionStatusDenied,
  ABI50_0_0EXPermissionStatusGranted,
  ABI50_0_0EXPermissionStatusUndetermined,
} ABI50_0_0EXPermissionStatus;


@protocol ABI50_0_0EXPermissionsRequester <NSObject>

+ (NSString *)permissionType;

- (void)requestPermissionsWithResolver:(ABI50_0_0EXPromiseResolveBlock)resolve rejecter:(ABI50_0_0EXPromiseRejectBlock)reject;

- (NSDictionary *)getPermissions;

@end

@protocol ABI50_0_0EXPermissionsInterface

- (void)registerRequesters:(NSArray<id<ABI50_0_0EXPermissionsRequester>> *)newRequesters;

- (void)getPermissionUsingRequesterClass:(Class)requesterClass
                                 resolve:(ABI50_0_0EXPromiseResolveBlock)resolve
                                  reject:(ABI50_0_0EXPromiseRejectBlock)reject;

- (BOOL)hasGrantedPermissionUsingRequesterClass:(Class)requesterClass;

- (void)askForPermissionUsingRequesterClass:(Class)requesterClass
                                    resolve:(ABI50_0_0EXPromiseResolveBlock)resolve
                                     reject:(ABI50_0_0EXPromiseRejectBlock)reject;

- (id<ABI50_0_0EXPermissionsRequester>)getPermissionRequesterForType:(NSString *)type;

@end
