// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXExportedModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0EXServerRegistrationModule : ABI50_0_0EXExportedModule

- (NSString *)getInstallationId;

- (void)getRegistrationInfoAsyncWithResolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject;
- (void)setRegistrationInfoAsync:(NSString *)registrationInfo
                        resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                        rejecter:(ABI50_0_0EXPromiseRejectBlock)reject;

@end

NS_ASSUME_NONNULL_END
