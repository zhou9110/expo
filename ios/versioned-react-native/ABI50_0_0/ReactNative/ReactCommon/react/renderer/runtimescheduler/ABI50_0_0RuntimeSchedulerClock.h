/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <chrono>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Represents a monotonic clock suitable for measuring intervals.
 */
using RuntimeSchedulerClock = std::chrono::steady_clock;

using RuntimeSchedulerTimePoint = RuntimeSchedulerClock::time_point;
using RuntimeSchedulerDuration = RuntimeSchedulerClock::duration;

} // namespace ABI50_0_0facebook::ABI50_0_0React
