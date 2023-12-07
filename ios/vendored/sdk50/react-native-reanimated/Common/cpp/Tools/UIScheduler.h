#pragma once

#include <ABI50_0_0ReactCommon/ABI50_0_0CallInvoker.h>

#include <atomic>
#include <memory>

#include "ThreadSafeQueue.h"

namespace ABI50_0_0reanimated {

class UIScheduler {
 public:
  virtual void scheduleOnUI(std::function<void()> job);
  virtual void triggerUI();
  virtual ~UIScheduler() = default;

 protected:
  std::atomic<bool> scheduledOnUI_{false};
  ThreadSafeQueue<std::function<void()>> uiJobs_;
};

} // namespace reanimated
