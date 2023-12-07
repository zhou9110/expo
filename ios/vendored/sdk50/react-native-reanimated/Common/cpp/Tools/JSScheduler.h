#pragma once

#include <ABI50_0_0ReactCommon/ABI50_0_0CallInvoker.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include <memory>

using namespace ABI50_0_0facebook;

namespace ABI50_0_0reanimated {

class JSScheduler {
 public:
  explicit JSScheduler(
      jsi::Runtime &rnRuntime,
      const std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker> &jsCallInvoker)
      : rnRuntime_(rnRuntime), jsCallInvoker_(jsCallInvoker) {}
  void scheduleOnJS(std::function<void(jsi::Runtime &rt)> job);

 protected:
  jsi::Runtime &rnRuntime_;
  const std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker> jsCallInvoker_;
};

} // namespace reanimated
