/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTJSThreadManager.h"

#import <ABI50_0_0React/ABI50_0_0RCTAssert.h>
#import <ABI50_0_0React/ABI50_0_0RCTCxxUtils.h>

static NSString *const ABI50_0_0RCTJSThreadName = @"com.facebook.ABI50_0_0React.runtime.JavaScript";

#define ABI50_0_0RCTAssertJSThread() \
  ABI50_0_0RCTAssert(self->_jsThread == [NSThread currentThread], @"This method must be called on JS thread")

@implementation ABI50_0_0RCTJSThreadManager {
  NSThread *_jsThread;
  std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::ABI50_0_0RCTMessageThread> _jsMessageThread;
}

- (instancetype)init
{
  if (self = [super init]) {
    [self startJSThread];
    __weak ABI50_0_0RCTJSThreadManager *weakSelf = self;

    dispatch_block_t captureJSThreadRunLoop = ^(void) {
      __strong ABI50_0_0RCTJSThreadManager *strongSelf = weakSelf;
      strongSelf->_jsMessageThread =
          std::make_shared<ABI50_0_0facebook::ABI50_0_0React::ABI50_0_0RCTMessageThread>([NSRunLoop currentRunLoop], ^(NSError *error) {
            if (error) {
              [weakSelf _handleError:error];
            }
          });
    };

    [self performSelector:@selector(_tryAndHandleError:)
                 onThread:_jsThread
               withObject:captureJSThreadRunLoop
            waitUntilDone:YES];
  }
  return self;
}

- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::ABI50_0_0RCTMessageThread>)jsMessageThread
{
  return _jsMessageThread;
}

- (void)dealloc
{
  // This avoids a race condition, where work can be executed on JS thread after
  // other peices of infra are cleaned up.
  _jsMessageThread->quitSynchronous();
}

#pragma mark - JSThread Management

- (void)startJSThread
{
  _jsThread = [[NSThread alloc] initWithTarget:[self class] selector:@selector(runRunLoop) object:nil];
  _jsThread.name = ABI50_0_0RCTJSThreadName;
  _jsThread.qualityOfService = NSOperationQualityOfServiceUserInteractive;
#if ABI50_0_0RCT_DEBUG
  _jsThread.stackSize *= 2;
#endif
  [_jsThread start];
}

/**
 * Ensure block is run on the JS thread. If we're already on the JS thread, the block will execute synchronously.
 * If we're not on the JS thread, the block is dispatched to that thread.
 */
- (void)dispatchToJSThread:(dispatch_block_t)block
{
  ABI50_0_0RCTAssert(_jsThread, @"This method must not be called before the JS thread is created");

  if ([NSThread currentThread] == _jsThread) {
    [self _tryAndHandleError:block];
  } else {
    __weak __typeof(self) weakSelf = self;
    _jsMessageThread->runOnQueue([weakSelf, block] { [weakSelf _tryAndHandleError:block]; });
  }
}

+ (void)runRunLoop
{
  @autoreleasepool {
    // copy thread name to pthread name
    pthread_setname_np([NSThread currentThread].name.UTF8String);

    // Set up a dummy runloop source to avoid spinning
    CFRunLoopSourceContext noSpinCtx = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    CFRunLoopSourceRef noSpinSource = CFRunLoopSourceCreate(NULL, 0, &noSpinCtx);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), noSpinSource, kCFRunLoopDefaultMode);
    CFRelease(noSpinSource);

    // run the run loop
    while (kCFRunLoopRunStopped !=
           CFRunLoopRunInMode(
               kCFRunLoopDefaultMode, ((NSDate *)[NSDate distantFuture]).timeIntervalSinceReferenceDate, NO)) {
      ABI50_0_0RCTAssert(NO, @"not reached assertion"); // runloop spun. that's bad.
    }
  }
}

#pragma mark - Private

- (void)_handleError:(NSError *)error
{
  ABI50_0_0RCTFatal(error);
}

- (void)_tryAndHandleError:(dispatch_block_t)block
{
  NSError *error = ABI50_0_0facebook::ABI50_0_0React::tryAndReturnError(block);
  if (error) {
    [self _handleError:error];
  }
}

@end
