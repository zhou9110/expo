// Copyright 2015-present 650 Industries. All rights reserved.
#import <Foundation/Foundation.h>

#if __has_include(<ABI50_0_0EXConstants/ABI50_0_0EXConstantsService.h>)
#import <ABI50_0_0EXConstants/ABI50_0_0EXConstantsService.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXInternalModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXConstantsInterface.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0EXConstantsBinding : ABI50_0_0EXConstantsService <ABI50_0_0EXInternalModule, ABI50_0_0EXConstantsInterface>

@property (nonatomic, readonly) NSString *appOwnership;

- (instancetype)initWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END

#endif
