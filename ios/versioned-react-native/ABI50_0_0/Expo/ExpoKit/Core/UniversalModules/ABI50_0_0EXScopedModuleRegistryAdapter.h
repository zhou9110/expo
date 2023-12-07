// Copyright © 2018 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryAdapter.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistry.h>

@class ABI50_0_0EXManifestsManifest;

@interface ABI50_0_0EXScopedModuleRegistryAdapter : ABI50_0_0EXModuleRegistryAdapter

- (nonnull ABI50_0_0EXModuleRegistry *)moduleRegistryForParams:(NSDictionary *)params
                          forExperienceStableLegacyId:(NSString *)experienceStableLegacyId
                                             scopeKey:(NSString *)scopeKey
                                             manifest:(ABI50_0_0EXManifestsManifest *)manifest
                                   withKernelServices:(NSDictionary *)kernelServices;

@end
