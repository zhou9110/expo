#ifndef ABI50_0_0RCT_NEW_ARCH_ENABLED

#import <ABI50_0_0RNReanimated/ABI50_0_0REAInitializer.h>

namespace ABI50_0_0reanimated {

void ABI50_0_0REAInitializer(ABI50_0_0RCTBridge *bridge)
{
  // do nothing, just for backward compatibility
}

#if ABI50_0_0REACT_NATIVE_MINOR_VERSION <= 71

JSIExecutor::RuntimeInstaller ABI50_0_0REAJSIExecutorRuntimeInstaller(
    ABI50_0_0RCTBridge *bridge,
    JSIExecutor::RuntimeInstaller runtimeInstallerToWrap)
{
  const auto runtimeInstaller = [runtimeInstallerToWrap](ABI50_0_0facebook::jsi::Runtime &runtime) {
    if (runtimeInstallerToWrap) {
      runtimeInstallerToWrap(runtime);
    }
  };
  return runtimeInstaller;
}

#endif // ABI50_0_0REACT_NATIVE_MINOR_VERSION <= 71

} // namespace reanimated

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
