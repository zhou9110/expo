// Copyright 2016-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXExportedModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryConsumer.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXEventEmitter.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXFileSystemInterface.h>

@interface ABI50_0_0EXFileSystem : ABI50_0_0EXExportedModule <ABI50_0_0EXEventEmitter, ABI50_0_0EXModuleRegistryConsumer, ABI50_0_0EXFileSystemInterface>

@property (nonatomic, readonly) NSString *documentDirectory;
@property (nonatomic, readonly) NSString *cachesDirectory;

- (instancetype)initWithDocumentDirectory:(NSString *)documentDirectory cachesDirectory:(NSString *)cachesDirectory;

- (ABI50_0_0EXFileSystemPermissionFlags)permissionsForURI:(NSURL *)uri;

- (nullable NSURL *)percentEncodedURLFromURIString:(nonnull NSString *)uri;

- (BOOL)ensureDirExistsWithPath:(NSString *)path;

- (NSString *)generatePathInDirectory:(NSString *)directory withExtension:(NSString *)extension;

@end
