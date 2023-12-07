/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/runtimescheduler/ABI50_0_0RuntimeSchedulerClock.h>
#include <chrono>

namespace ABI50_0_0facebook::ABI50_0_0React {

class StubClock {
 public:
  RuntimeSchedulerTimePoint getNow() const {
    return timePoint_;
  }

  void setTimePoint(RuntimeSchedulerTimePoint timePoint) {
    timePoint_ = timePoint;
  }

  void setTimePoint(RuntimeSchedulerDuration duration) {
    timePoint_ = RuntimeSchedulerTimePoint(duration);
  }

  RuntimeSchedulerTimePoint getTimePoint() {
    return timePoint_;
  }

  void advanceTimeBy(RuntimeSchedulerDuration duration) {
    timePoint_ += duration;
  }

 private:
  RuntimeSchedulerTimePoint timePoint_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
