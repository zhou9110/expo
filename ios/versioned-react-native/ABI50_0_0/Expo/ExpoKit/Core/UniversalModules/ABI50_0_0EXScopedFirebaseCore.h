// Copyright 2020-present 650 Industries. All rights reserved.

#if __has_include(<ABI50_0_0EXFirebaseCore/ABI50_0_0EXFirebaseCore.h>)
#import <UIKit/UIKit.h>
#import <ABI50_0_0EXFirebaseCore/ABI50_0_0EXFirebaseCore.h>
#import "ABI50_0_0EXConstantsBinding.h"

@class ABI50_0_0EXManifestsManifest;

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0EXScopedFirebaseCore : ABI50_0_0EXFirebaseCore

- (instancetype)initWithScopeKey:(NSString *)scopeKey manifest:(ABI50_0_0EXManifestsManifest *)manifest constantsBinding:(ABI50_0_0EXConstantsBinding *)constantsBinding;

@end

NS_ASSUME_NONNULL_END
#endif
