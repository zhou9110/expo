#include "ReanimatedRuntime.h"

#include <ABI50_0_0cxxreact/ABI50_0_0MessageQueueThread.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include <memory>
#include <utility>

#if JS_RUNTIME_HERMES
#include "ReanimatedHermesRuntime.h"
#elif JS_RUNTIME_V8
#include <v8runtime/V8RuntimeFactory.h>
#else
#if ABI50_0_0REACT_NATIVE_MINOR_VERSION >= 71
#include <jsc/JSCRuntime.h>
#else
#include <jsi/JSCRuntime.h>
#endif // ABI50_0_0REACT_NATIVE_MINOR_VERSION
#endif // JS_RUNTIME

namespace ABI50_0_0reanimated {

using namespace ABI50_0_0facebook;
using namespace ABI50_0_0React;

std::shared_ptr<jsi::Runtime> ReanimatedRuntime::make(
    jsi::Runtime &rnRuntime,
    const std::shared_ptr<MessageQueueThread> &jsQueue,
    const std::string &name) {
  (void)rnRuntime; // used only for V8
#if JS_RUNTIME_HERMES
  // We don't call `jsQueue->quitSynchronous()` here, since it will be done
  // later in ReanimatedHermesRuntime

  auto runtime = ABI50_0_0facebook::ABI50_0_0hermes::makeHermesRuntime();
  return std::make_shared<ReanimatedHermesRuntime>(
      std::move(runtime), jsQueue, name);
#elif JS_RUNTIME_V8
  // This is required by iOS, because there is an assertion in the destructor
  // that the thread was indeed `quit` before.
  jsQueue->quitSynchronous();

  auto config = std::make_unique<rnv8::V8RuntimeConfig>();
  config->enableInspector = false;
  config->appName = name;
  return rnv8::createSharedV8Runtime(&rnRuntime, std::move(config));
#else
  // This is required by iOS, because there is an assertion in the destructor
  // that the thread was indeed `quit` before
  jsQueue->quitSynchronous();

  return ABI50_0_0facebook::jsc::makeJSCRuntime();
#endif
}

} // namespace reanimated
