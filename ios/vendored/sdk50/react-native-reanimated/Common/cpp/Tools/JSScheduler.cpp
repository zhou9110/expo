#include "JSScheduler.h"

#include <utility>

namespace ABI50_0_0reanimated {

void JSScheduler::scheduleOnJS(std::function<void(jsi::Runtime &rt)> job) {
  jsCallInvoker_->invokeAsync(
      [job = std::move(job), &rt = rnRuntime_] { job(rt); });
}

} // namespace reanimated
