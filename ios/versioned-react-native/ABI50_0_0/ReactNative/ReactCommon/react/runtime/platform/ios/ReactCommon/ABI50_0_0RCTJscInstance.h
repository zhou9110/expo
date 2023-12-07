/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0cxxreact/ABI50_0_0MessageQueueThread.h>
#import <ABI50_0_0jsi/ABI50_0_0jsi.h>
#import <ABI50_0_0React/runtime/ABI50_0_0JSEngineInstance.h>

namespace ABI50_0_0facebook {
namespace ABI50_0_0React {

class ABI50_0_0RCTJscInstance : public JSEngineInstance {
 public:
  ABI50_0_0RCTJscInstance();

  std::unique_ptr<jsi::Runtime> createJSRuntime(
      std::shared_ptr<MessageQueueThread> msgQueueThread) noexcept override;

  ~ABI50_0_0RCTJscInstance(){};
};
} // namespace ABI50_0_0React
} // namespace ABI50_0_0facebook
