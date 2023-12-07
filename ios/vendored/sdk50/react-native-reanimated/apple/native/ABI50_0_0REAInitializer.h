/*
  Note: Files ABI50_0_0REAInitializer.h and ABI50_0_0REAInitializer.m are deprecated and will
  be removed in future releases. They are currently kept for backward
  compatibility and will be retained for a few upcoming releases.
*/

#ifndef ABI50_0_0RCT_NEW_ARCH_ENABLED

#import <Foundation/Foundation.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>

#if ABI50_0_0REACT_NATIVE_MINOR_VERSION <= 71
#import <ABI50_0_0React/ABI50_0_0RCTJSIExecutorRuntimeInstaller.h>
using namespace ABI50_0_0facebook::ABI50_0_0React;
#endif // ABI50_0_0REACT_NATIVE_MINOR_VERSION <= 71

NS_ASSUME_NONNULL_BEGIN

namespace ABI50_0_0reanimated {

[[deprecated(
    "ABI50_0_0REAInitializer method is no longer required, you can just remove invocation.")]] void
ABI50_0_0REAInitializer(ABI50_0_0RCTBridge *bridge);

#if ABI50_0_0REACT_NATIVE_MINOR_VERSION <= 71
[[deprecated(
    "ABI50_0_0REAJSIExecutorRuntimeInstaller method is no longer required, you can just remove invocation.")]] JSIExecutor::
    RuntimeInstaller
    ABI50_0_0REAJSIExecutorRuntimeInstaller(
        ABI50_0_0RCTBridge *bridge,
        JSIExecutor::RuntimeInstaller runtimeInstallerToWrap);
#endif // ABI50_0_0REACT_NATIVE_MINOR_VERSION <= 71

} // namespace reanimated

NS_ASSUME_NONNULL_END

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
