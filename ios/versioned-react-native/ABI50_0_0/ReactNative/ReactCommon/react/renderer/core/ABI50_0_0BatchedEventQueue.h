/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/core/ABI50_0_0EventQueue.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0EventQueueProcessor.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Event Queue that dispatches event in batches synchronizing them with
 * an Event Beat.
 */
class BatchedEventQueue final : public EventQueue {
 public:
  BatchedEventQueue(
      EventQueueProcessor eventProcessor,
      std::unique_ptr<EventBeat> eventBeat);

  void onEnqueue() const override;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
