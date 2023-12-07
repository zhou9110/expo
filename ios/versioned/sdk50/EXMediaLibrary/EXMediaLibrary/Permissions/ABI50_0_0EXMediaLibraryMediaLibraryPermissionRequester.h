// Copyright 2017-present 650 Industries. All rights reserved.

#import <Photos/Photos.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXPermissionsInterface.h>

@interface ABI50_0_0EXMediaLibraryMediaLibraryPermissionRequester : NSObject<ABI50_0_0EXPermissionsRequester>

#if __IPHONE_14_0
- (PHAccessLevel)accessLevel API_AVAILABLE(ios(14));
#endif

@end
