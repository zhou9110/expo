// Copyright 2015-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoFileSystem/ABI50_0_0EXSessionDownloadTaskDelegate.h>
#import <ABI50_0_0ExpoFileSystem/ABI50_0_0EXTaskHandlersManager.h>

typedef void (^ABI50_0_0EXDownloadDelegateOnWriteCallback)(NSURLSessionDownloadTask *task, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);

@interface ABI50_0_0EXSessionResumableDownloadTaskDelegate : ABI50_0_0EXSessionDownloadTaskDelegate

- (nonnull instancetype)initWithResolve:(ABI50_0_0EXPromiseResolveBlock)resolve
                                 reject:(ABI50_0_0EXPromiseRejectBlock)reject
                               localUrl:(NSURL *)localUrl
                     shouldCalculateMd5:(BOOL)shouldCalculateMd5
                        onWriteCallback:(ABI50_0_0EXDownloadDelegateOnWriteCallback)onWriteCallback
                       resumableManager:(ABI50_0_0EXTaskHandlersManager *)manager
                                   uuid:(NSString *)uuid;

@end
