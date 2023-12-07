// Copyright © 2018 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistry.h>

NS_ASSUME_NONNULL_BEGIN

@class ABI50_0_0EXSingletonModule;

NS_SWIFT_NAME(ModuleRegistryProvider)
@interface ABI50_0_0EXModuleRegistryProvider : NSObject

@property (nonatomic, weak) id<ABI50_0_0EXModuleRegistryDelegate> moduleRegistryDelegate;

+ (NSSet<Class> *)getModulesClasses;
+ (NSSet *)singletonModules;
+ (nullable ABI50_0_0EXSingletonModule *)getSingletonModuleForClass:(Class)singletonClass;

- (instancetype)init __deprecated_msg("Expo modules are now being automatically registered. You can remove this method call.");
- (instancetype)initWithSingletonModules:(NSSet *)modules;
- (ABI50_0_0EXModuleRegistry *)moduleRegistry;

@end

NS_ASSUME_NONNULL_END
