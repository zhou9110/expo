// Copyright 2023-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0ExpoModulesCore.h>

@protocol ABI50_0_0EXFileSystemHandler

+ (void)getInfoForFile:(NSURL *)fileUri
           withOptions:(NSDictionary *)optionxs
              resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
              rejecter:(ABI50_0_0EXPromiseRejectBlock)reject;

+ (void)copyFrom:(NSURL *)from
              to:(NSURL *)to
        resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
        rejecter:(ABI50_0_0EXPromiseRejectBlock)reject;

@end
