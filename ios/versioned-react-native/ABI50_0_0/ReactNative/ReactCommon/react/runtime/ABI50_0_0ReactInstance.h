/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0ReactCommon/ABI50_0_0RuntimeExecutor.h>
#include <ABI50_0_0cxxreact/ABI50_0_0MessageQueueThread.h>
#include <ABI50_0_0jserrorhandler/ABI50_0_0JsErrorHandler.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <ABI50_0_0jsireact/ABI50_0_0JSIExecutor.h>
#include <ABI50_0_0React/renderer/runtimescheduler/ABI50_0_0RuntimeScheduler.h>
#include <ABI50_0_0React/runtime/ABI50_0_0BufferedRuntimeExecutor.h>
#include <ABI50_0_0React/runtime/ABI50_0_0TimerManager.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

struct CallableModule {
  explicit CallableModule(jsi::Function factory)
      : factory(std::move(factory)) {}
  jsi::Function factory;
};

class ABI50_0_0ReactInstance final {
 public:
  using BindingsInstallFunc = std::function<void(jsi::Runtime& runtime)>;

  ABI50_0_0ReactInstance(
      std::unique_ptr<jsi::Runtime> runtime,
      std::shared_ptr<MessageQueueThread> jsMessageQueueThread,
      std::shared_ptr<TimerManager> timerManager,
      JsErrorHandler::JsErrorHandlingFunc JsErrorHandlingFunc);

  RuntimeExecutor getUnbufferedRuntimeExecutor() noexcept;

  RuntimeExecutor getBufferedRuntimeExecutor() noexcept;

  std::shared_ptr<RuntimeScheduler> getRuntimeScheduler() noexcept;

  struct JSRuntimeFlags {
    bool isProfiling = false;
    const std::string runtimeDiagnosticFlags = "";
  };

  void initializeRuntime(
      JSRuntimeFlags options,
      BindingsInstallFunc bindingsInstallFunc) noexcept;

  void loadScript(
      std::unique_ptr<const JSBigString> script,
      const std::string& sourceURL);

  void registerSegment(uint32_t segmentId, const std::string& segmentPath);

  void callFunctionOnModule(
      const std::string& moduleName,
      const std::string& methodName,
      const folly::dynamic& args);

  void handleMemoryPressureJs(int pressureLevel);

 private:
  std::shared_ptr<jsi::Runtime> runtime_;
  std::shared_ptr<MessageQueueThread> jsMessageQueueThread_;
  std::shared_ptr<BufferedRuntimeExecutor> bufferedRuntimeExecutor_;
  std::shared_ptr<TimerManager> timerManager_;
  std::unordered_map<std::string, std::shared_ptr<CallableModule>> modules_;
  std::shared_ptr<RuntimeScheduler> runtimeScheduler_;
  JsErrorHandler jsErrorHandler_;

  // Whether there are errors caught during bundle loading
  std::shared_ptr<bool> hasFatalJsError_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
