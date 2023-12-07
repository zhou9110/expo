/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTRootView.h>

#ifdef __cplusplus

#import <memory>

#ifndef ABI50_0_0RCT_USE_HERMES
#if __has_include(<ABI50_0_0Reacthermes/HermesExecutorFactory.h>)
#define ABI50_0_0RCT_USE_HERMES 1
#else
#define ABI50_0_0RCT_USE_HERMES 0
#endif
#endif

#if ABI50_0_0RCT_USE_HERMES
#import <ABI50_0_0Reacthermes/HermesExecutorFactory.h>
#else
#import <ABI50_0_0React/ABI50_0_0JSCExecutorFactory.h>
#endif

#if ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTTurboModuleManager.h>
#endif

// Forward declaration to decrease compilation coupling
namespace ABI50_0_0facebook::ABI50_0_0React {
class RuntimeScheduler;
}

#if ABI50_0_0RCT_NEW_ARCH_ENABLED

ABI50_0_0RCT_EXTERN id<ABI50_0_0RCTTurboModule> ABI50_0_0RCTAppSetupDefaultModuleFromClass(Class moduleClass);

std::unique_ptr<ABI50_0_0facebook::ABI50_0_0React::JSExecutorFactory> ABI50_0_0RCTAppSetupDefaultJsExecutorFactory(
    ABI50_0_0RCTBridge *bridge,
    ABI50_0_0RCTTurboModuleManager *turboModuleManager,
    const std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::RuntimeScheduler> &runtimeScheduler);
#else
std::unique_ptr<ABI50_0_0facebook::ABI50_0_0React::JSExecutorFactory> ABI50_0_0RCTAppSetupJsExecutorFactoryForOldArch(
    ABI50_0_0RCTBridge *bridge,
    const std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::RuntimeScheduler> &runtimeScheduler);
#endif

#endif // __cplusplus

ABI50_0_0RCT_EXTERN_C_BEGIN

void ABI50_0_0RCTAppSetupPrepareApp(UIApplication *application, BOOL turboModuleEnabled);
UIView *ABI50_0_0RCTAppSetupDefaultRootView(
    ABI50_0_0RCTBridge *bridge,
    NSString *moduleName,
    NSDictionary *initialProperties,
    BOOL fabricEnabled);

ABI50_0_0RCT_EXTERN_C_END
