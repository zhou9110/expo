// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXFileSystemInterface.h>

@protocol ABI50_0_0EXFilePermissionModuleInterface

- (ABI50_0_0EXFileSystemPermissionFlags)getPathPermissions:(NSString *)path;

@end

