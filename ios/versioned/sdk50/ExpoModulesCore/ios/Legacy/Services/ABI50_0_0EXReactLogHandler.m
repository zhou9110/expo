// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0React/ABI50_0_0RCTLog.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXReactLogHandler.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXDefines.h>

@implementation ABI50_0_0EXReactLogHandler

ABI50_0_0EX_REGISTER_SINGLETON_MODULE(ABI50_0_0ReactLogHandler);

- (void)error:(NSString *)message {
  ABI50_0_0RCTLogError(@"%@", message);
}

- (void)fatal:(NSError *)error {
  ABI50_0_0RCTFatal(error);
}

- (void)info:(NSString *)message {
  ABI50_0_0RCTLogInfo(@"%@", message);
}

- (void)warn:(NSString *)message {
  ABI50_0_0RCTLogWarn(@"%@", message);
}

@end
