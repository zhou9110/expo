// Copyright 2015-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoFileSystem/ABI50_0_0EXSessionUploadTaskDelegate.h>
#import <ABI50_0_0ExpoFileSystem/ABI50_0_0EXTaskHandlersManager.h>

typedef void (^ABI50_0_0EXUploadDelegateOnSendCallback)(NSURLSessionUploadTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);

@interface ABI50_0_0EXSessionCancelableUploadTaskDelegate : ABI50_0_0EXSessionUploadTaskDelegate

- (nonnull instancetype)initWithResolve:(ABI50_0_0EXPromiseResolveBlock)resolve
                                 reject:(ABI50_0_0EXPromiseRejectBlock)reject
                         onSendCallback:(ABI50_0_0EXUploadDelegateOnSendCallback)onSendCallback
                       resumableManager:(ABI50_0_0EXTaskHandlersManager *)manager
                                   uuid:(NSString *)uuid;

@end
