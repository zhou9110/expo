// Copyright 2018-present 650 Industries. All rights reserved.

#import <AVKit/AVKit.h>

@protocol ABI50_0_0EXCameraInterface

#if !TARGET_OS_TV
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *session;
#endif

@end
