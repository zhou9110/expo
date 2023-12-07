// Copyright 2015-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoFileSystem/ABI50_0_0EXSessionTaskDelegate.h>

@interface ABI50_0_0EXSessionDownloadTaskDelegate : ABI50_0_0EXSessionTaskDelegate

- (nonnull instancetype)initWithResolve:(ABI50_0_0EXPromiseResolveBlock)resolve
                                 reject:(ABI50_0_0EXPromiseRejectBlock)reject
                               localUrl:(NSURL *)localUrl
                     shouldCalculateMd5:(BOOL)shouldCalculateMd5;

@end

