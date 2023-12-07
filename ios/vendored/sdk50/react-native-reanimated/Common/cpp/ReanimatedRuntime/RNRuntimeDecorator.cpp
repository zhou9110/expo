#include "ABI50_0_0RNRuntimeDecorator.h"
#include "ReanimatedVersion.h"

namespace ABI50_0_0reanimated {

void ABI50_0_0RNRuntimeDecorator::decorate(
    jsi::Runtime &rnRuntime,
    const std::shared_ptr<NativeReanimatedModule> &nativeReanimatedModule,
    const bool isReducedMotion) {
  rnRuntime.global().setProperty(rnRuntime, "_WORKLET", false);

  jsi::Runtime &uiRuntime = nativeReanimatedModule->getUIRuntime();
  auto workletRuntimeValue =
      rnRuntime.global()
          .getPropertyAsObject(rnRuntime, "ArrayBuffer")
          .asFunction(rnRuntime)
          .callAsConstructor(rnRuntime, {static_cast<double>(sizeof(void *))});
  uintptr_t *workletRuntimeData = reinterpret_cast<uintptr_t *>(
      workletRuntimeValue.getObject(rnRuntime).getArrayBuffer(rnRuntime).data(
          rnRuntime));
  workletRuntimeData[0] = reinterpret_cast<uintptr_t>(&uiRuntime);
  rnRuntime.global().setProperty(
      rnRuntime, "_WORKLET_RUNTIME", workletRuntimeValue);

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  constexpr auto isFabric = true;
#else
  constexpr auto isFabric = false;
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
  rnRuntime.global().setProperty(rnRuntime, "_IS_FABRIC", isFabric);

#ifndef NDEBUG
  checkJSVersion(rnRuntime, nativeReanimatedModule->getJSLogger());
#endif // NDEBUG

  rnRuntime.global().setProperty(
      rnRuntime, "_REANIMATED_IS_REDUCED_MOTION", isReducedMotion);

  rnRuntime.global().setProperty(
      rnRuntime,
      jsi::PropNameID::forAscii(rnRuntime, "__reanimatedModuleProxy"),
      jsi::Object::createFromHostObject(rnRuntime, nativeReanimatedModule));
}

} // namespace reanimated
