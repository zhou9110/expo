// Copyright © 2018 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>

// Register a class implementing this protocol in ABI50_0_0EXModuleClasses
// of ABI50_0_0EXModuleRegistryProvider (macros defined in ABI50_0_0EXDefines.h should help you)
// to make the module available under any of `exportedInterfaces`
// via ABI50_0_0EXModuleRegistry.

@protocol ABI50_0_0EXInternalModule <NSObject>

- (instancetype)init;
+ (const NSArray<Protocol *> *)exportedInterfaces;

@end
