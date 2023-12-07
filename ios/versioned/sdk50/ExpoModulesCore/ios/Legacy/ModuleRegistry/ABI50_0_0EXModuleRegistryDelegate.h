// Copyright © 2018 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXInternalModule.h>

@protocol ABI50_0_0EXModuleRegistryDelegate <NSObject>

- (id<ABI50_0_0EXInternalModule>)pickInternalModuleImplementingInterface:(Protocol *)interface fromAmongModules:(NSArray<id<ABI50_0_0EXInternalModule>> *)internalModules;

@end
