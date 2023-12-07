/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTSampleLegacyModule.h"

@implementation ABI50_0_0RCTSampleLegacyModule {
  ABI50_0_0RCTBridge *_bridge;
}

// Backward-compatible export
ABI50_0_0RCT_EXPORT_MODULE()

// Backward-compatible queue configuration
+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

- (void)setBridge:(ABI50_0_0RCTBridge *)bridge
{
  _bridge = bridge;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

// Backward compatible invalidation
- (void)invalidate
{
  // Actually do nothing here.
  NSLog(@"Invalidating ABI50_0_0RCTSampleTurboModule...");
}

- (NSDictionary *)getConstants
{
  __block NSDictionary *constants;
  ABI50_0_0RCTUnsafeExecuteOnMainQueueSync(^{
    constants = @{
      @"const1" : @YES,
      @"const2" : @(390),
      @"const3" : @"something",
    };
  });

  return constants;
}

// TODO: Remove once fully migrated to TurboModule.
- (NSDictionary *)constantsToExport
{
  return [self getConstants];
}

ABI50_0_0RCT_EXPORT_METHOD(voidFunc)
{
  // Nothing to do
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getBool : (BOOL)arg)
{
  return @(arg);
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getEnum : (double)arg)
{
  return @(arg);
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getNumber : (double)arg)
{
  return @(arg);
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getFloat : (float)arg)
{
  return @(arg);
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getInt : (int)arg)
{
  return @(arg);
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getLongLong : (int64_t)arg)
{
  return @(arg);
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getUnsignedLongLong : (uint64_t)arg)
{
  return @(arg);
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getNSInteger : (NSInteger)arg)
{
  return @(arg);
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getNSUInteger : (NSUInteger)arg)
{
  return @(arg);
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSArray<id<NSObject>> *, getArray : (NSArray *)arg)
{
  return arg;
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSDictionary *, getObject : (NSDictionary *)arg)
{
  return arg;
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSString *, getString : (NSString *)arg)
{
  return arg;
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getNSNumber : (nonnull NSNumber *)arg)
{
  return arg;
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSDictionary *, getUnsafeObject : (NSDictionary *)arg)
{
  return arg;
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getRootTag : (double)arg)
{
  return @(arg);
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSDictionary *, getValue : (double)x y : (NSString *)y z : (NSDictionary *)z)
{
  return @{
    @"x" : @(x),
    @"y" : y ?: [NSNull null],
    @"z" : z ?: [NSNull null],
  };
}

ABI50_0_0RCT_EXPORT_METHOD(getValueWithCallback : (ABI50_0_0RCTResponseSenderBlock)callback)
{
  if (!callback) {
    return;
  }
  callback(@[ @"value from callback!" ]);
}

ABI50_0_0RCT_EXPORT_METHOD(getValueWithPromise
                  : (BOOL)error resolve
                  : (ABI50_0_0RCTPromiseResolveBlock)resolve reject
                  : (ABI50_0_0RCTPromiseRejectBlock)reject)
{
  if (!resolve || !reject) {
    return;
  }

  if (error) {
    reject(
        @"code_1",
        @"intentional promise rejection",
        [NSError errorWithDomain:@"ABI50_0_0RCTSampleTurboModule" code:1 userInfo:nil]);
  } else {
    resolve(@"result!");
  }
}

ABI50_0_0RCT_EXPORT_METHOD(voidFuncThrows)
{
  NSException *myException = [NSException exceptionWithName:@"Excepption"
                                                     reason:@"Intentional exception from ObjC voidFuncThrows"
                                                   userInfo:nil];
  @throw myException;
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSDictionary *, getObjectThrows : (NSDictionary *)arg)
{
  NSException *myException = [NSException exceptionWithName:@"Excepption"
                                                     reason:@"Intentional exception from ObjC getObjectThrows"
                                                   userInfo:nil];
  @throw myException;
}

ABI50_0_0RCT_EXPORT_METHOD(promiseThrows
                  : (BOOL)error resolve
                  : (ABI50_0_0RCTPromiseResolveBlock)resolve reject
                  : (ABI50_0_0RCTPromiseRejectBlock)reject)
{
  NSException *myException = [NSException exceptionWithName:@"Excepption"
                                                     reason:@"Intentional exception from ObjC promiseThrows"
                                                   userInfo:nil];
  @throw myException;
}

ABI50_0_0RCT_EXPORT_METHOD(voidFuncAssert)
{
  ABI50_0_0RCTAssert(false, @"Intentional assert from ObjC voidFuncAssert");
}

ABI50_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSDictionary *, getObjectAssert : (NSDictionary *)arg)
{
  ABI50_0_0RCTAssert(false, @"Intentional assert from ObjC getObjectAssert");
  return arg;
}

ABI50_0_0RCT_EXPORT_METHOD(promiseAssert
                  : (BOOL)error resolve
                  : (ABI50_0_0RCTPromiseResolveBlock)resolve reject
                  : (ABI50_0_0RCTPromiseRejectBlock)reject)
{
  ABI50_0_0RCTAssert(false, @"Intentional assert from ObjC promiseAssert");
}

@end
