// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXEventEmitter.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXExportedModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXInternalModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryConsumer.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXTaskManagerInterface.h>

@interface ABI50_0_0EXTaskManager : ABI50_0_0EXExportedModule <ABI50_0_0EXInternalModule, ABI50_0_0EXEventEmitter, ABI50_0_0EXModuleRegistryConsumer, ABI50_0_0EXTaskManagerInterface>

- (instancetype)initWithScopeKey:(NSString *)scopeKey NS_DESIGNATED_INITIALIZER;

@end
