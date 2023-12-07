#pragma once

// JS_RUNTIME_HERMES is only set on Android so we have to check __has_include
// on iOS.
#if __APPLE__ &&    \
    (__has_include( \
        <ABI50_0_0reacthermes/ABI50_0_0HermesExecutorFactory.h>) || __has_include(<hermes/hermes.h>))
#define JS_RUNTIME_HERMES 1
#endif

#include <ABI50_0_0cxxreact/ABI50_0_0MessageQueueThread.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include <memory>
#include <string>

namespace ABI50_0_0reanimated {

using namespace ABI50_0_0facebook;
using namespace ABI50_0_0React;

class ReanimatedRuntime {
 public:
  static std::shared_ptr<jsi::Runtime> make(
      jsi::Runtime &rnRuntime,
      const std::shared_ptr<MessageQueueThread> &jsQueue,
      const std::string &name);
};

} // namespace reanimated
