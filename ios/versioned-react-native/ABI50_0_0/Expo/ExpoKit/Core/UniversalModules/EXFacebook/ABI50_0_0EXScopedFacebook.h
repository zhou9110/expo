// Copyright 2015-present 650 Industries. All rights reserved.

#if __has_include(<ABI50_0_0EXFacebook/ABI50_0_0EXFacebook.h>)
#import <Foundation/Foundation.h>
#import <ABI50_0_0EXFacebook/ABI50_0_0EXFacebook.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXAppLifecycleListener.h>

@class ABI50_0_0EXManifestsManifest;

@interface ABI50_0_0EXScopedFacebook : ABI50_0_0EXFacebook <ABI50_0_0EXAppLifecycleListener>

- (instancetype)initWithScopeKey:(NSString *)scopeKey manifest:(ABI50_0_0EXManifestsManifest *)manifest;

@end
#endif
