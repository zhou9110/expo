/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0RCTLegacyUIManagerConstantsProvider.h"

#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponentData.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTTurboModule.h>
#import <ABI50_0_0React/runtime/nativeviewconfig/ABI50_0_0LegacyUIManagerConstantsProviderBinding.h>

namespace ABI50_0_0facebook::ABI50_0_0React {
namespace {

jsi::Value getConstants(ABI50_0_0facebook::jsi::Runtime &runtime)
{
  static NSMutableDictionary<NSString *, NSObject *> *result = [NSMutableDictionary new];
  auto directEvents = [NSMutableDictionary new];
  auto bubblingEvents = [NSMutableDictionary new];
  for (Class moduleClass in ABI50_0_0RCTGetModuleClasses()) {
    if ([moduleClass isSubclassOfClass:ABI50_0_0RCTViewManager.class]) {
      auto name = ABI50_0_0RCTViewManagerModuleNameForClass(moduleClass);
      auto viewConfig = [ABI50_0_0RCTComponentData viewConfigForViewMangerClass:moduleClass];
      auto moduleConstants =
          ABI50_0_0RCTModuleConstantsForDestructuredComponent(directEvents, bubblingEvents, moduleClass, name, viewConfig);
      result[name] = moduleConstants;
    }
  }
  return TurboModuleConvertUtils::convertObjCObjectToJSIValue(runtime, result);
};

} // namespace

void installLegacyUIManagerConstantsProviderBinding(jsi::Runtime &runtime)
{
  auto constantsProvider = [&runtime]() -> jsi::Value { return getConstants(runtime); };
  LegacyUIManagerConstantsProviderBinding::install(runtime, std::move(constantsProvider));
}
} // namespace ABI50_0_0facebook::ABI50_0_0React
