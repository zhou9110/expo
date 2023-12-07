// Copyright 2015-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXFontProcessorInterface.h>
#import <ABI50_0_0EXFont/ABI50_0_0EXFontManager.h>

@interface ABI50_0_0EXFontLoaderProcessor : NSObject <ABI50_0_0EXFontProcessorInterface>

- (instancetype)initWithFontFamilyPrefix:(NSString *)prefix
                                 manager:(ABI50_0_0EXFontManager *)manager;

- (instancetype)initWithManager:(ABI50_0_0EXFontManager *)manager;

@end
