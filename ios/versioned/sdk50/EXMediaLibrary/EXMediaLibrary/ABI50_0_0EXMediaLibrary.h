// Copyright 2015-present 650 Industries. All rights reserved.

#import <Photos/Photos.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXExportedModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXEventEmitter.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryConsumer.h>

@interface ABI50_0_0EXMediaLibrary : ABI50_0_0EXExportedModule <ABI50_0_0EXModuleRegistryConsumer, PHPhotoLibraryChangeObserver, ABI50_0_0EXEventEmitter>

@end
