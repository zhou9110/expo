/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <ABI50_0_0ReactCommon/ABI50_0_0CallInvoker.h>
#include <ABI50_0_0ReactCommon/ABI50_0_0RuntimeExecutor.h>
#include <functional>

namespace ABI50_0_0facebook::ABI50_0_0React {

/**
 * A native-to-JS call invoker that uses the RuntimeExecutor. It guarantees that
 * any calls from any thread are queued on the right JS thread.
 */
class BridgelessJSCallInvoker : public CallInvoker {
 public:
  explicit BridgelessJSCallInvoker(RuntimeExecutor runtimeExecutor);
  void invokeAsync(std::function<void()>&& func) override;
  void invokeSync(std::function<void()>&& func) override;

 private:
  RuntimeExecutor runtimeExecutor_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
