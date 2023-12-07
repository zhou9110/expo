// Copyright 2015-present 650 Industries. All rights reserved.

#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>

FOUNDATION_EXPORT NSNotificationName ABI50_0_0EXTestSuiteCompletedNotification;

typedef enum ABI50_0_0EXTestEnvironment {
  ABI50_0_0EXTestEnvironmentNone = 0,
  ABI50_0_0EXTestEnvironmentLocal = 1,
  ABI50_0_0EXTestEnvironmentCI = 2,
} ABI50_0_0EXTestEnvironment;

@interface ABI50_0_0EXTest : NSObject <ABI50_0_0RCTBridgeModule>

- (instancetype)initWithEnvironment:(ABI50_0_0EXTestEnvironment)environment NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

+ (ABI50_0_0EXTestEnvironment)testEnvironmentFromString:(NSString *)testEnvironmentString;

@end
