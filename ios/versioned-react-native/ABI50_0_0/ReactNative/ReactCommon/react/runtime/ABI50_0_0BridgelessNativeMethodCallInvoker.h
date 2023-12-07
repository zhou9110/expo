/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <ABI50_0_0ReactCommon/ABI50_0_0CallInvoker.h>
#include <ABI50_0_0cxxreact/ABI50_0_0MessageQueueThread.h>
#include <functional>
#include <memory>

namespace ABI50_0_0facebook::ABI50_0_0React {

class BridgelessNativeMethodCallInvoker : public NativeMethodCallInvoker {
 public:
  explicit BridgelessNativeMethodCallInvoker(
      std::shared_ptr<MessageQueueThread> messageQueueThread);
  void invokeAsync(const std::string& methodName, std::function<void()>&& func)
      override;
  void invokeSync(const std::string& methodName, std::function<void()>&& func)
      override;

 private:
  std::shared_ptr<MessageQueueThread> messageQueueThread_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
