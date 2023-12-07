// Copyright 2015-present 650 Industries. All rights reserved.
#import <ABI50_0_0ExpoFileSystem/ABI50_0_0EXFilePermissionModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXFileSystemInterface.h>

@interface ABI50_0_0EXFilePermissionModule ()

@property (nonatomic, weak) ABI50_0_0EXModuleRegistry *moduleRegistry;

@end

@implementation ABI50_0_0EXFilePermissionModule

ABI50_0_0EX_REGISTER_MODULE();

+ (const NSArray<Protocol *> *)exportedInterfaces
{
  return @[@protocol(ABI50_0_0EXFilePermissionModuleInterface)];
}

- (ABI50_0_0EXFileSystemPermissionFlags)getPathPermissions:(NSString *)path
{
  ABI50_0_0EXFileSystemPermissionFlags permissionsForInternalDirectories = [self getInternalPathPermissions:path];
  if (permissionsForInternalDirectories != ABI50_0_0EXFileSystemPermissionNone) {
    return permissionsForInternalDirectories;
  } else {
    return [self getExternalPathPermissions:path];
  }
}

- (ABI50_0_0EXFileSystemPermissionFlags)getInternalPathPermissions:(NSString *)path
{
  id<ABI50_0_0EXFileSystemInterface> fileSystem = [_moduleRegistry getModuleImplementingProtocol:@protocol(ABI50_0_0EXFileSystemInterface)];
  NSArray<NSString *> *scopedDirs = @[fileSystem.cachesDirectory, fileSystem.documentDirectory];
  NSString *standardizedPath = [path stringByStandardizingPath];
  for (NSString *scopedDirectory in scopedDirs) {
    if ([standardizedPath hasPrefix:[scopedDirectory stringByAppendingString:@"/"]] ||
        [standardizedPath isEqualToString:scopedDirectory]) {
      return ABI50_0_0EXFileSystemPermissionRead | ABI50_0_0EXFileSystemPermissionWrite;
    }
  }

  return ABI50_0_0EXFileSystemPermissionNone;
}

- (ABI50_0_0EXFileSystemPermissionFlags)getExternalPathPermissions:(NSString *)path
{
  ABI50_0_0EXFileSystemPermissionFlags filePermissions = ABI50_0_0EXFileSystemPermissionNone;
  if ([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
    filePermissions |= ABI50_0_0EXFileSystemPermissionRead;
  }

  if ([[NSFileManager defaultManager] isWritableFileAtPath:path]) {
    filePermissions |= ABI50_0_0EXFileSystemPermissionWrite;
  }

  return filePermissions;
}

- (void)setModuleRegistry:(ABI50_0_0EXModuleRegistry *)moduleRegistry {
  _moduleRegistry = moduleRegistry;
}

@end
