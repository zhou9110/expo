#include "ReanimatedHermesRuntime.h"

// Only include this file in Hermes-enabled builds as some platforms (like tvOS)
// don't support hermes and it causes the compilation to fail.
#if JS_RUNTIME_HERMES

#include <ABI50_0_0cxxreact/ABI50_0_0MessageQueueThread.h>
#include <ABI50_0_0jsi/ABI50_0_0decorator.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include <memory>
#include <string>
#include <utility>

#if __has_include(<ABI50_0_0reacthermes/ABI50_0_0HermesExecutorFactory.h>)
#include <ABI50_0_0reacthermes/ABI50_0_0HermesExecutorFactory.h>
#else // __has_include(<hermes/hermes.h>) || ANDROID
#include <hermes/hermes.h>
#endif

namespace ABI50_0_0reanimated {

using namespace ABI50_0_0facebook;
using namespace ABI50_0_0React;
#if HERMES_ENABLE_DEBUGGER
#if ABI50_0_0REACT_NATIVE_MINOR_VERSION >= 73
using namespace ABI50_0_0facebook::ABI50_0_0hermes::inspector_modern;
#else
using namespace ABI50_0_0facebook::ABI50_0_0hermes::inspector;
#endif
#endif // HERMES_ENABLE_DEBUGGER

#if HERMES_ENABLE_DEBUGGER

class HermesExecutorRuntimeAdapter : public RuntimeAdapter {
 public:
  explicit HermesExecutorRuntimeAdapter(
      ABI50_0_0facebook::ABI50_0_0hermes::HermesRuntime &hermesRuntime,
      const std::shared_ptr<MessageQueueThread> &thread)
      : hermesRuntime_(hermesRuntime), thread_(std::move(thread)) {}

  virtual ~HermesExecutorRuntimeAdapter() {
    // This is required by iOS, because there is an assertion in the destructor
    // that the thread was indeed `quit` before
    thread_->quitSynchronous();
  }

#if ABI50_0_0REACT_NATIVE_MINOR_VERSION >= 71
  ABI50_0_0facebook::ABI50_0_0hermes::HermesRuntime &getRuntime() override {
    return hermesRuntime_;
  }
#else
  ABI50_0_0facebook::jsi::Runtime &getRuntime() override {
    return hermesRuntime_;
  }

  ABI50_0_0facebook::ABI50_0_0hermes::debugger::Debugger &getDebugger() override {
    return hermesRuntime_.getDebugger();
  }
#endif // ABI50_0_0REACT_NATIVE_MINOR_VERSION

  // This is not empty in the original implementation, but we decided to tickle
  // the runtime by running a small piece of code on every frame as using this
  // required us to hold a refernce to the runtime inside this adapter which
  // caused issues while reloading the app.
  void tickleJs() override {}

 public:
  ABI50_0_0facebook::ABI50_0_0hermes::HermesRuntime &hermesRuntime_;
  std::shared_ptr<MessageQueueThread> thread_;
};

#endif // HERMES_ENABLE_DEBUGGER

ReanimatedHermesRuntime::ReanimatedHermesRuntime(
    std::unique_ptr<ABI50_0_0facebook::ABI50_0_0hermes::HermesRuntime> runtime,
    const std::shared_ptr<MessageQueueThread> &jsQueue,
    const std::string &name)
    : jsi::WithRuntimeDecorator<ReanimatedReentrancyCheck>(
          *runtime,
          reentrancyCheck_),
      runtime_(std::move(runtime)) {
#if HERMES_ENABLE_DEBUGGER
  auto adapter =
      std::make_unique<HermesExecutorRuntimeAdapter>(*runtime_, jsQueue);
#if ABI50_0_0REACT_NATIVE_MINOR_VERSION >= 71
  debugToken_ = chrome::enableDebugging(std::move(adapter), name);
#else
  chrome::enableDebugging(std::move(adapter), name);
#endif // ABI50_0_0REACT_NATIVE_MINOR_VERSION
#else
  // This is required by iOS, because there is an assertion in the destructor
  // that the thread was indeed `quit` before
  jsQueue->quitSynchronous();
#endif // HERMES_ENABLE_DEBUGGER

#ifndef NDEBUG
  ABI50_0_0facebook::ABI50_0_0hermes::HermesRuntime *wrappedRuntime = runtime_.get();
  jsi::Value evalWithSourceMap = jsi::Function::createFromHostFunction(
      *runtime_,
      jsi::PropNameID::forAscii(*runtime_, "evalWithSourceMap"),
      3,
      [wrappedRuntime](
          jsi::Runtime &rt,
          const jsi::Value &thisValue,
          const jsi::Value *args,
          size_t count) -> jsi::Value {
        auto code = std::make_shared<const jsi::StringBuffer>(
            args[0].asString(rt).utf8(rt));
        std::string sourceURL;
        if (count > 1 && args[1].isString()) {
          sourceURL = args[1].asString(rt).utf8(rt);
        }
        std::shared_ptr<const jsi::Buffer> sourceMap;
        if (count > 2 && args[2].isString()) {
          sourceMap = std::make_shared<const jsi::StringBuffer>(
              args[2].asString(rt).utf8(rt));
        }
        return wrappedRuntime->evaluateJavaScriptWithSourceMap(
            code, sourceMap, sourceURL);
      });
  runtime_->global().setProperty(
      *runtime_, "evalWithSourceMap", evalWithSourceMap);
#endif // NDEBUG
}

ReanimatedHermesRuntime::~ReanimatedHermesRuntime() {
#if HERMES_ENABLE_DEBUGGER
  // We have to disable debugging before the runtime is destroyed.
#if ABI50_0_0REACT_NATIVE_MINOR_VERSION >= 71
  chrome::disableDebugging(debugToken_);
#else
  chrome::disableDebugging(*runtime_);
#endif // ABI50_0_0REACT_NATIVE_MINOR_VERSION
#endif // HERMES_ENABLE_DEBUGGER
}

} // namespace reanimated

#endif // JS_RUNTIME_HERMES
