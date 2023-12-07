// Copyright © 2018 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXDefines.h>

#define ABI50_0_0UM_DEPRECATED(type_name) __deprecated_msg("use ABI50_0_0EX"#type_name" from ExpoModulesCore instead")

#define ABI50_0_0UM_EXPORTED_METHODS_PREFIX ABI50_0_0EX_EXPORTED_METHODS_PREFIX
#define ABI50_0_0UM_PROPSETTERS_PREFIX ABI50_0_0EX_PROPSETTERS_PREFIX

#define ABI50_0_0UM_DO_CONCAT ABI50_0_0EX_DO_CONCAT
#define ABI50_0_0UM_CONCAT ABI50_0_0EX_CONCAT

#define ABI50_0_0UM_EXPORT_METHOD_AS ABI50_0_0EX_EXPORT_METHOD_AS

#define _UM_EXTERN_METHOD _EX_EXTERN_METHOD

#define ABI50_0_0UM_VIEW_PROPERTY ABI50_0_0EX_VIEW_PROPERTY

#define _UM_DEFINE_CUSTOM_LOAD _EX_DEFINE_CUSTOM_LOAD

#define ABI50_0_0UM_EXPORT_MODULE_WITH_CUSTOM_LOAD ABI50_0_0EX_EXPORT_MODULE_WITH_CUSTOM_LOAD

#define ABI50_0_0UM_EXPORT_MODULE ABI50_0_0EX_EXPORT_MODULE

#define ABI50_0_0UM_REGISTER_MODULE ABI50_0_0EX_REGISTER_MODULE

#define ABI50_0_0UM_REGISTER_SINGLETON_MODULE_WITH_CUSTOM_LOAD ABI50_0_0EX_REGISTER_SINGLETON_MODULE_WITH_CUSTOM_LOAD

#define ABI50_0_0UM_REGISTER_SINGLETON_MODULE ABI50_0_0EX_REGISTER_SINGLETON_MODULE

// Weakify/Strongify need to be defined from scratch because of a reference to `ABI50_0_0UMWeak`
#define ABI50_0_0UM_WEAKIFY(var) \
__weak __typeof(var) ABI50_0_0UMWeak_##var = var;

#define ABI50_0_0UM_STRONGIFY(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong __typeof(var) var = ABI50_0_0UMWeak_##var; \
_Pragma("clang diagnostic pop")

#define ABI50_0_0UM_ENSURE_STRONGIFY(var) \
ABI50_0_0UM_STRONGIFY(var); \
if (var == nil) { return; }

// Converts nil -> [NSNull null]
#define ABI50_0_0UMNullIfNil ABI50_0_0EXNullIfNil

#define ABI50_0_0UMMethodInfo ABI50_0_0EXMethodInfo
#define ABI50_0_0UMModuleInfo ABI50_0_0EXModuleInfo

#define ABI50_0_0UMDirectEventBlock ABI50_0_0EXDirectEventBlock
#define ABI50_0_0UMPromiseResolveBlock ABI50_0_0EXPromiseResolveBlock
#define ABI50_0_0UMPromiseRejectBlock ABI50_0_0EXPromiseRejectBlock

// These should be defined by the concrete platform adapter
#define ABI50_0_0UMLogInfo ABI50_0_0EXLogInfo
#define ABI50_0_0UMLogWarn ABI50_0_0EXLogWarn
#define ABI50_0_0UMLogError ABI50_0_0EXLogError
#define ABI50_0_0UMFatal ABI50_0_0EXFatal
#define ABI50_0_0UMErrorWithMessage ABI50_0_0EXErrorWithMessage
#define ABI50_0_0UMSharedApplication ABI50_0_0EXSharedApplication
