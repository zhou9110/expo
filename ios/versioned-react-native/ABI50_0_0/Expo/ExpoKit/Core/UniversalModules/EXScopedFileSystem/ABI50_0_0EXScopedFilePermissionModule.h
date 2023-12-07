// Copyright 2015-present 650 Industries. All rights reserved.

#if __has_include(<ABI50_0_0ExpoFileSystem/ABI50_0_0EXFilePermissionModule.h>)
#import <ABI50_0_0ExpoFileSystem/ABI50_0_0EXFilePermissionModule.h>
#import "ABI50_0_0EXConstantsBinding.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0EXScopedFilePermissionModule : ABI50_0_0EXFilePermissionModule

- (instancetype)initWithConstantsBinding:(ABI50_0_0EXConstantsBinding *)constantsBinding;

@end

NS_ASSUME_NONNULL_END
#endif
