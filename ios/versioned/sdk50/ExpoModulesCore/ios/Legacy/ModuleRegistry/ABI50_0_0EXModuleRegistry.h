// Copyright © 2018 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXInternalModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXExportedModule.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0EXModuleRegistry : NSObject

- (instancetype)initWithInternalModules:(NSSet<id<ABI50_0_0EXInternalModule>> *)internalModules
                        exportedModules:(NSSet<ABI50_0_0EXExportedModule *> *)exportedModules
                       singletonModules:(NSSet *)singletonModules;

- (void)registerInternalModule:(id<ABI50_0_0EXInternalModule>)internalModule;
- (void)registerExportedModule:(ABI50_0_0EXExportedModule *)exportedModule;

- (void)setDelegate:(id<ABI50_0_0EXModuleRegistryDelegate>)delegate;

// Call this method once all the modules are set up and registered in the registry.
- (void)initialize;

- (ABI50_0_0EXExportedModule *)getExportedModuleForName:(NSString *)name;
- (ABI50_0_0EXExportedModule *)getExportedModuleOfClass:(Class)moduleClass;
- (id)getModuleImplementingProtocol:(Protocol *)protocol;
- (id)getSingletonModuleForName:(NSString *)singletonModuleName;

- (NSArray<id<ABI50_0_0EXInternalModule>> *)getAllInternalModules;
- (NSArray<ABI50_0_0EXExportedModule *> *)getAllExportedModules;
- (NSArray *)getAllSingletonModules;

@end

NS_ASSUME_NONNULL_END
