// Copyright 2016-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(unsigned int, ABI50_0_0EXFileSystemPermissionFlags) {
  ABI50_0_0EXFileSystemPermissionNone = 0,
  ABI50_0_0EXFileSystemPermissionRead = 1 << 1,
  ABI50_0_0EXFileSystemPermissionWrite = 1 << 2,
};

// TODO: Maybe get rid of this interface in favor of ABI50_0_0EXFileSystemManager and private utilities classes
@protocol ABI50_0_0EXFileSystemInterface

@property (nonatomic, readonly) NSString *documentDirectory;
@property (nonatomic, readonly) NSString *cachesDirectory;

// TODO: Move permissionsForURI to ABI50_0_0EXFileSystemManagerInterface
- (ABI50_0_0EXFileSystemPermissionFlags)permissionsForURI:(NSURL *)uri;
- (nonnull NSString *)generatePathInDirectory:(NSString *)directory withExtension:(NSString *)extension;
- (BOOL)ensureDirExistsWithPath:(NSString *)path;

@end
