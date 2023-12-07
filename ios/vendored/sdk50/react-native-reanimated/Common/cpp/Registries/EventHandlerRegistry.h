#pragma once

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include <map>
#include <memory>
#include <mutex>
#include <set>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

#include "WorkletRuntime.h"

using namespace ABI50_0_0facebook;

namespace ABI50_0_0reanimated {

class WorkletEventHandler;

class EventHandlerRegistry {
  std::map<
      std::pair<int, std::string>,
      std::unordered_map<uint64_t, std::shared_ptr<WorkletEventHandler>>>
      eventMappingsWithTag;
  std::map<
      std::string,
      std::unordered_map<uint64_t, std::shared_ptr<WorkletEventHandler>>>
      eventMappingsWithoutTag;
  std::map<uint64_t, std::shared_ptr<WorkletEventHandler>> eventHandlers;
  std::mutex instanceMutex;

 public:
  void registerEventHandler(std::shared_ptr<WorkletEventHandler> eventHandler);
  void unregisterEventHandler(uint64_t id);

  void processEvent(
      const std::shared_ptr<WorkletRuntime> &uiWorkletRuntime,
      const double eventTimestamp,
      const std::string &eventName,
      const int emitterABI50_0_0ReactTag,
      const jsi::Value &eventPayload);

  bool isAnyHandlerWaitingForEvent(
      const std::string &eventName,
      const int emitterABI50_0_0ReactTag);
};

} // namespace reanimated
