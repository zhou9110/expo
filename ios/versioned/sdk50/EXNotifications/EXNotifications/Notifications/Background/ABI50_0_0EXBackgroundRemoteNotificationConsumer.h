// Copyright 2021-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXTaskConsumerInterface.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0EXBackgroundRemoteNotificationConsumer : NSObject <ABI50_0_0EXTaskConsumerInterface>

@property (nonatomic, strong) id<ABI50_0_0EXTaskInterface> task;

@end

NS_ASSUME_NONNULL_END
