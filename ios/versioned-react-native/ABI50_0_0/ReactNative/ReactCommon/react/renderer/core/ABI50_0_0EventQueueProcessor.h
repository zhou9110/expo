/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <vector>

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0EventPipe.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0RawEvent.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0StatePipe.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0StateUpdate.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class EventQueueProcessor {
 public:
  EventQueueProcessor(
      EventPipe eventPipe,
      EventPipeConclusion eventPipeConclusion,
      StatePipe statePipe);

  void flushEvents(jsi::Runtime& runtime, std::vector<RawEvent>&& events) const;
  void flushStateUpdates(std::vector<StateUpdate>&& states) const;

 private:
  const EventPipe eventPipe_;
  const EventPipeConclusion eventPipeConclusion_;
  const StatePipe statePipe_;

  mutable bool hasContinuousEventStarted_{false};
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
