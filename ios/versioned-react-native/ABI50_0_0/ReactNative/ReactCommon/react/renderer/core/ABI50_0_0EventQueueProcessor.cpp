/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <ABI50_0_0cxxreact/ABI50_0_0JSExecutor.h>
#include <ABI50_0_0logger/ABI50_0_0React_native_log.h>
#include <ABI50_0_0React/utils/ABI50_0_0CoreFeatures.h>
#include "ABI50_0_0EventEmitter.h"
#include "ABI50_0_0EventLogger.h"
#include "ABI50_0_0EventQueue.h"
#include "ABI50_0_0ShadowNodeFamily.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

EventQueueProcessor::EventQueueProcessor(
    EventPipe eventPipe,
    EventPipeConclusion eventPipeConclusion,
    StatePipe statePipe)
    : eventPipe_(std::move(eventPipe)),
      eventPipeConclusion_(std::move(eventPipeConclusion)),
      statePipe_(std::move(statePipe)) {}

void EventQueueProcessor::flushEvents(
    jsi::Runtime& runtime,
    std::vector<RawEvent>&& events) const {
  {
    std::scoped_lock lock(EventEmitter::DispatchMutex());

    for (const auto& event : events) {
      if (event.eventTarget) {
        event.eventTarget->retain(runtime);
      }
    }
  }

  for (const auto& event : events) {
    if (event.category == RawEvent::Category::ContinuousEnd) {
      hasContinuousEventStarted_ = false;
    }

    auto ABI50_0_0ReactPriority = hasContinuousEventStarted_
        ? ABI50_0_0ReactEventPriority::Default
        : ABI50_0_0ReactEventPriority::Discrete;

    if (event.category == RawEvent::Category::Continuous) {
      ABI50_0_0ReactPriority = ABI50_0_0ReactEventPriority::Default;
    }

    if (event.category == RawEvent::Category::Discrete) {
      ABI50_0_0ReactPriority = ABI50_0_0ReactEventPriority::Discrete;
    }

    auto eventLogger = getEventLogger();
    if (eventLogger != nullptr) {
      eventLogger->onEventDispatch(event.loggingTag);
    }

    if (event.eventPayload == nullptr) {
      ABI50_0_0React_native_log_error(
          "EventQueueProcessor: Unexpected null event payload");
      continue;
    }

    eventPipe_(
        runtime,
        event.eventTarget.get(),
        event.type,
        ABI50_0_0ReactPriority,
        *event.eventPayload);

    // We run the "Conclusion" per-event when unbatched
    if (!CoreFeatures::enableDefaultAsyncBatchedPriority) {
      eventPipeConclusion_(runtime);
    }

    if (eventLogger != nullptr) {
      eventLogger->onEventEnd(event.loggingTag);
    }

    if (event.category == RawEvent::Category::ContinuousStart) {
      hasContinuousEventStarted_ = true;
    }
  }
  // We only run the "Conclusion" once per event group when batched.
  if (CoreFeatures::enableDefaultAsyncBatchedPriority) {
    eventPipeConclusion_(runtime);
  }

  // No need to lock `EventEmitter::DispatchMutex()` here.
  // The mutex protects from a situation when the `instanceHandle` can be
  // deallocated during accessing, but that's impossible at this point because
  // we have a strong pointer to it.
  for (const auto& event : events) {
    if (event.eventTarget) {
      event.eventTarget->release(runtime);
    }
  }
}

void EventQueueProcessor::flushStateUpdates(
    std::vector<StateUpdate>&& states) const {
  for (const auto& stateUpdate : states) {
    statePipe_(stateUpdate);
  }
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
