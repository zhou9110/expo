// Copyright 2018-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXPermissionsInterface.h>

@interface ABI50_0_0EXPermissionsMethodsDelegate : NSObject

+ (void)getPermissionWithPermissionsManager:(id<ABI50_0_0EXPermissionsInterface>)permissionsManager
                              withRequester:(Class)requesterClass
                                    resolve:(ABI50_0_0EXPromiseResolveBlock)resolve
                                     reject:(ABI50_0_0EXPromiseRejectBlock)reject;

+ (void)askForPermissionWithPermissionsManager:(id<ABI50_0_0EXPermissionsInterface>)permissionsManager
                                 withRequester:(Class)requesterClass
                                       resolve:(ABI50_0_0EXPromiseResolveBlock)resolve
                                        reject:(ABI50_0_0EXPromiseRejectBlock)reject;

+ (void)registerRequesters:(NSArray<id<ABI50_0_0EXPermissionsRequester>> *)newRequesters
    withPermissionsManager:(id<ABI50_0_0EXPermissionsInterface>)permissionsManager;

@end
