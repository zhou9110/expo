/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <XCTest/XCTest.h>

#import <ABI50_0_0RCTTestUtils/ABI50_0_0RCTMemoryUtils.h>
#import <ABI50_0_0RCTTestUtils/ShimABI50_0_0RCTInstance.h>
#import <ABI50_0_0React/ABI50_0_0RCTLog.h>
#import <ABI50_0_0React/ABI50_0_0RCTMockDef.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTHermesInstance.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTHost.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTInstance.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTTurboModuleManager.h>

#import <OCMock/OCMock.h>

ABI50_0_0RCT_MOCK_REF(ABI50_0_0RCTHost, _ABI50_0_0RCTLogNativeInternal);

ABI50_0_0RCTLogLevel gLogLevel;
int gLogCalledTimes = 0;
NSString *gLogMessage = nil;
static void ABI50_0_0RCTLogNativeInternalMock(ABI50_0_0RCTLogLevel level, const char *fileName, int lineNumber, NSString *format, ...)
{
  gLogLevel = level;
  gLogCalledTimes++;

  va_list args;
  va_start(args, format);
  gLogMessage = [[NSString alloc] initWithFormat:format arguments:args];
  va_end(args);
}

@interface ABI50_0_0RCTHostTests : XCTestCase
@end

@implementation ABI50_0_0RCTHostTests {
  ABI50_0_0RCTHost *_subject;
  id<ABI50_0_0RCTHostDelegate> _mockHostDelegate;
}

static ShimABI50_0_0RCTInstance *shimmedABI50_0_0RCTInstance;

- (void)setUp
{
  [super setUp];

  ABI50_0_0RCTAutoReleasePoolPush();

  shimmedABI50_0_0RCTInstance = [ShimABI50_0_0RCTInstance new];

  _mockHostDelegate = OCMProtocolMock(@protocol(ABI50_0_0RCTHostDelegate));
  _subject = [[ABI50_0_0RCTHost alloc] initWithBundleURL:OCMClassMock([NSURL class])
                                   hostDelegate:_mockHostDelegate
                     turboModuleManagerDelegate:OCMProtocolMock(@protocol(ABI50_0_0RCTTurboModuleManagerDelegate))
                               jsEngineProvider:^std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::JSEngineInstance>() {
                                 return std::make_shared<ABI50_0_0facebook::ABI50_0_0React::ABI50_0_0RCTHermesInstance>();
                               }];
}

- (void)tearDown
{
  ABI50_0_0RCTAutoReleasePoolPop();

  _subject = nil;
  XCTAssertEqual(ABI50_0_0RCTGetRetainCount(_subject), 0);

  _mockHostDelegate = nil;
  XCTAssertEqual(ABI50_0_0RCTGetRetainCount(_mockHostDelegate), 0);

  [shimmedABI50_0_0RCTInstance reset];
  gLogCalledTimes = 0;
  gLogMessage = nil;

  [super tearDown];
}

- (void)testStart
{
  ABI50_0_0RCT_MOCK_SET(ABI50_0_0RCTHost, _ABI50_0_0RCTLogNativeInternal, ABI50_0_0RCTLogNativeInternalMock);

  XCTAssertEqual(shimmedABI50_0_0RCTInstance.initCount, 0);
  [_subject start];
  OCMVerify(OCMTimes(1), [_mockHostDelegate hostDidStart:_subject]);
  XCTAssertEqual(shimmedABI50_0_0RCTInstance.initCount, 1);
  XCTAssertEqual(gLogCalledTimes, 0);

  XCTAssertEqual(shimmedABI50_0_0RCTInstance.invalidateCount, 0);
  [_subject start];
  XCTAssertEqual(shimmedABI50_0_0RCTInstance.initCount, 2);
  XCTAssertEqual(shimmedABI50_0_0RCTInstance.invalidateCount, 1);
  OCMVerify(OCMTimes(2), [_mockHostDelegate hostDidStart:_subject]);
  XCTAssertEqual(gLogLevel, ABI50_0_0RCTLogLevelWarning);
  XCTAssertEqual(gLogCalledTimes, 1);
  XCTAssertEqualObjects(
      gLogMessage,
      @"ABI50_0_0RCTHost should not be creating a new instance if one already exists. This implies there is a bug with how/when this method is being called.");

  ABI50_0_0RCT_MOCK_RESET(ABI50_0_0RCTHost, _ABI50_0_0RCTLogNativeInternal);
}

- (void)testCallFunctionOnJSModule
{
  [_subject start];

  NSArray *args = @[ @"hi", @(5), @(NO) ];
  [_subject callFunctionOnJSModule:@"jsModule" method:@"method" args:args];

  XCTAssertEqualObjects(shimmedABI50_0_0RCTInstance.jsModuleName, @"jsModule");
  XCTAssertEqualObjects(shimmedABI50_0_0RCTInstance.method, @"method");
  XCTAssertEqualObjects(shimmedABI50_0_0RCTInstance.args, args);
}

- (void)testDidReceiveErrorStack
{
  id<ABI50_0_0RCTInstanceDelegate> instanceDelegate = (id<ABI50_0_0RCTInstanceDelegate>)_subject;

  NSMutableArray<NSDictionary<NSString *, id> *> *stack = [NSMutableArray array];

  NSMutableDictionary<NSString *, id> *stackFrame0 = [NSMutableDictionary dictionary];
  stackFrame0[@"linenumber"] = @(3);
  stackFrame0[@"column"] = @(4);
  stackFrame0[@"methodname"] = @"method1";
  stackFrame0[@"file"] = @"file1.js";
  [stack addObject:stackFrame0];

  NSMutableDictionary<NSString *, id> *stackFrame1 = [NSMutableDictionary dictionary];
  stackFrame0[@"linenumber"] = @(63);
  stackFrame0[@"column"] = @(44);
  stackFrame0[@"methodname"] = @"method2";
  stackFrame0[@"file"] = @"file2.js";
  [stack addObject:stackFrame1];

  [instanceDelegate instance:[OCMArg any] didReceiveJSErrorStack:stack message:@"message" exceptionId:5 isFatal:YES];

  OCMVerify(
      OCMTimes(1),
      [_mockHostDelegate host:_subject didReceiveJSErrorStack:stack message:@"message" exceptionId:5 isFatal:YES]);
}

- (void)testDidInitializeRuntime
{
  id<ABI50_0_0RCTHostRuntimeDelegate> mockRuntimeDelegate = OCMProtocolMock(@protocol(ABI50_0_0RCTHostRuntimeDelegate));
  _subject.runtimeDelegate = mockRuntimeDelegate;

  auto hermesRuntime = ABI50_0_0facebook::ABI50_0_0hermes::makeHermesRuntime();
  ABI50_0_0facebook::jsi::Runtime *rt = hermesRuntime.get();

  id<ABI50_0_0RCTInstanceDelegate> instanceDelegate = (id<ABI50_0_0RCTInstanceDelegate>)_subject;
  [instanceDelegate instance:[OCMArg any] didInitializeRuntime:*rt];

  OCMVerify(OCMTimes(1), [mockRuntimeDelegate host:_subject didInitializeRuntime:*rt]);
}

@end
