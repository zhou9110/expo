// Copyright 2015-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXFilePermissionModuleInterface.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXInternalModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryConsumer.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0EXFilePermissionModule : NSObject <ABI50_0_0EXInternalModule, ABI50_0_0EXFilePermissionModuleInterface, ABI50_0_0EXModuleRegistryConsumer>

- (ABI50_0_0EXFileSystemPermissionFlags)getPathPermissions:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
