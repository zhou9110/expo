// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistryHolderReactModule.h>

@interface ABI50_0_0EXModuleRegistryHolderReactModule ()

@property (nonatomic, nullable, weak) ABI50_0_0EXModuleRegistry *exModuleRegistry;

@end

@implementation ABI50_0_0EXModuleRegistryHolderReactModule

- (nonnull instancetype)initWithModuleRegistry:(nonnull ABI50_0_0EXModuleRegistry *)moduleRegistry
{
  if (self = [super init]) {
    _exModuleRegistry = moduleRegistry;
  }
  return self;
}

- (nullable ABI50_0_0EXModuleRegistry *)exModuleRegistry
{
  return _exModuleRegistry;
}

+ (nullable NSString *)moduleName {
  return nil;
}

@end
