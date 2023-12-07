#pragma once

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include <memory>

#include "NativeReanimatedModule.h"

using namespace ABI50_0_0facebook;

namespace ABI50_0_0reanimated {

class ABI50_0_0RNRuntimeDecorator {
 public:
  static void decorate(
      jsi::Runtime &rnRuntime,
      const std::shared_ptr<NativeReanimatedModule> &nativeReanimatedModule,
      const bool isReducedMotion);
};

} // namespace reanimated
