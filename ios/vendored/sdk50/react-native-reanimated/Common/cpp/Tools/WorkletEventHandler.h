#pragma once

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <memory>
#include <string>
#include <utility>

#include "Shareables.h"
#include "WorkletRuntime.h"

using namespace ABI50_0_0facebook;

namespace ABI50_0_0reanimated {

class WorkletEventHandler {
  const uint64_t handlerId_;
  const uint64_t emitterReactTag_;
  const std::string eventName_;
  const std::shared_ptr<ShareableWorklet> handlerFunction_;

 public:
  WorkletEventHandler(
      const uint64_t handlerId,
      const std::string &eventName,
      const uint64_t emitterABI50_0_0ReactTag,
      const std::shared_ptr<ShareableWorklet> &handlerFunction)
      : handlerId_(handlerId),
        emitterReactTag_(emitterABI50_0_0ReactTag),
        eventName_(eventName),
        handlerFunction_(handlerFunction) {}
  void process(
      const std::shared_ptr<WorkletRuntime> &workletRuntime,
      double eventTimestamp,
      const jsi::Value &eventValue) const;
  uint64_t getHandlerId() const;
  const std::string &getEventName() const;
  uint64_t getEmitterReactTag() const;
  bool shouldIgnoreEmitterReactTag() const;
};

} // namespace reanimated
