// Copyright 2018-present 650 Industries. All rights reserved.

#import <CoreLocation/CLLocationManagerDelegate.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXTaskConsumerInterface.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0EXLocationTaskConsumer : NSObject <ABI50_0_0EXTaskConsumerInterface, CLLocationManagerDelegate>

@property (nonatomic, strong) id<ABI50_0_0EXTaskInterface> task;

@end

NS_ASSUME_NONNULL_END
