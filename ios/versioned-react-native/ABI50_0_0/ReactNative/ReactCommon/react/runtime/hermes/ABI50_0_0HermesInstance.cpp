/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0HermesInstance.h"

#include <JSITracing.h>
#include <ABI50_0_0jsi/ABI50_0_0jsilib.h>

#ifdef HERMES_ENABLE_DEBUGGER
#include <hermes/inspector-modern/chrome/ABI50_0_0Registration.h>
#include <hermes/inspector/ABI50_0_0RuntimeAdapter.h>
#include <ABI50_0_0jsi/ABI50_0_0decorator.h>
#endif

using namespace ABI50_0_0facebook::ABI50_0_0hermes;
using namespace ABI50_0_0facebook::jsi;

namespace ABI50_0_0facebook::ABI50_0_0React {

#ifdef HERMES_ENABLE_DEBUGGER

// Wrapper that strongly retains the HermesRuntime for on device debugging.
//
// HermesInstanceRuntimeAdapter needs to strongly retain the HermesRuntime. Why:
//   - ABI50_0_0facebook::ABI50_0_0hermes::inspector_modern::chrome::Connection::Impl owns the
//   Adapter
//   - ABI50_0_0facebook::ABI50_0_0hermes::inspector_modern::chrome::Connection::Impl also owns
//   jsi:: objects
//   - jsi:: objects need to be deleted before the Runtime.
//
// If Adapter doesn't share ownership over jsi::Runtime, the runtime can be
// deleted before Connection::Impl cleans up all its jsi:: Objects. This will
// lead to a runtime crash.
class HermesInstanceRuntimeAdapter : public inspector_modern::RuntimeAdapter {
 public:
  HermesInstanceRuntimeAdapter(
      std::shared_ptr<HermesRuntime> hermesRuntime,
      std::shared_ptr<MessageQueueThread> msgQueueThread)
      : hermesRuntime_(std::move(hermesRuntime)),
        messageQueueThread_(std::move(msgQueueThread)) {}
  virtual ~HermesInstanceRuntimeAdapter() = default;

  HermesRuntime& getRuntime() override {
    return *hermesRuntime_;
  }

  void tickleJs() override {
    std::weak_ptr<HermesRuntime> weakRuntime(hermesRuntime_);
    messageQueueThread_->runOnQueue([weakRuntime]() {
      auto runtime = weakRuntime.lock();
      if (!runtime) {
        return;
      }
      jsi::Function func =
          runtime->global().getPropertyAsFunction(*runtime, "__tickleJs");
      func.call(*runtime);
    });
  }

 private:
  std::shared_ptr<HermesRuntime> hermesRuntime_;
  std::shared_ptr<MessageQueueThread> messageQueueThread_;
};

class DecoratedRuntime : public jsi::RuntimeDecorator<jsi::Runtime> {
 public:
  DecoratedRuntime(
      std::unique_ptr<HermesRuntime> runtime,
      std::shared_ptr<MessageQueueThread> msgQueueThread)
      : RuntimeDecorator<jsi::Runtime>(*runtime), runtime_(std::move(runtime)) {
    auto adapter = std::make_unique<HermesInstanceRuntimeAdapter>(
        runtime_, msgQueueThread);

    debugToken_ = inspector_modern::chrome::enableDebugging(
        std::move(adapter), "Hermes Bridgeless ABI50_0_0React Native");
  }

  ~DecoratedRuntime() {
    inspector_modern::chrome::disableDebugging(debugToken_);
  }

 private:
  std::shared_ptr<HermesRuntime> runtime_;
  inspector_modern::chrome::DebugSessionToken debugToken_;
};

#endif

std::unique_ptr<jsi::Runtime> HermesInstance::createJSRuntime(
    std::shared_ptr<const ABI50_0_0ReactNativeConfig> ABI50_0_0ReactNativeConfig,
    std::shared_ptr<::ABI50_0_0hermes::vm::CrashManager> cm,
    std::shared_ptr<MessageQueueThread> msgQueueThread) noexcept {
  assert(msgQueueThread != nullptr);
  int64_t vmExperimentFlags = ABI50_0_0ReactNativeConfig
      ? ABI50_0_0ReactNativeConfig->getInt64("ios_hermes:vm_experiment_flags")
      : 0;

  int64_t heapSizeConfig = ABI50_0_0ReactNativeConfig
      ? ABI50_0_0ReactNativeConfig->getInt64("ios_hermes:rn_heap_size_mb")
      : 0;
  // Default to 3GB if MobileConfigs is not available
  auto heapSizeMB = heapSizeConfig > 0
      ? static_cast<::ABI50_0_0hermes::vm::gcheapsize_t>(heapSizeConfig)
      : 3072;
  ::ABI50_0_0hermes::vm::RuntimeConfig::Builder runtimeConfigBuilder =
      ::ABI50_0_0hermes::vm::RuntimeConfig::Builder()
          .withGCConfig(::ABI50_0_0hermes::vm::GCConfig::Builder()
                            .withMaxHeapSize(heapSizeMB << 20)
                            .withName("ABI50_0_0RNBridgeless")
                            // For the next two arguments: avoid GC before TTI
                            // by initializing the runtime to allocate directly
                            // in the old generation, but revert to normal
                            // operation when we reach the (first) TTI point.
                            .withAllocInYoung(false)
                            .withRevertToABI50_0_0YGAtTTI(true)
                            .build())
          .withES6Proxy(false)
          .withEnableSampleProfiling(true)
          .withVMExperimentFlags(vmExperimentFlags);

  if (cm) {
    runtimeConfigBuilder.withCrashMgr(cm);
  }

  std::unique_ptr<HermesRuntime> hermesRuntime =
      ABI50_0_0hermes::makeHermesRuntime(runtimeConfigBuilder.build());

  jsi::addNativeTracingHooks(*hermesRuntime);

#ifdef HERMES_ENABLE_DEBUGGER
  std::unique_ptr<DecoratedRuntime> decoratedRuntime =
      std::make_unique<DecoratedRuntime>(
          std::move(hermesRuntime), msgQueueThread);
  return decoratedRuntime;
#endif

  return hermesRuntime;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
