// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXExportedModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXEventEmitter.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryConsumer.h>
#import <ABI50_0_0EXNotifications/ABI50_0_0EXPushTokenListener.h>

@interface ABI50_0_0EXPushTokenModule : ABI50_0_0EXExportedModule <ABI50_0_0EXEventEmitter, ABI50_0_0EXModuleRegistryConsumer, ABI50_0_0EXPushTokenListener>
@end
