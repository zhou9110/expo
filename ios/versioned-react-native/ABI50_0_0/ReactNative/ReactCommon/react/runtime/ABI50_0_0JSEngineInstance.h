/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0ReactCommon/ABI50_0_0RuntimeExecutor.h>
#include <ABI50_0_0cxxreact/ABI50_0_0MessageQueueThread.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/**
 * Interface for a class that creates and owns an instance of a JS VM
 */
class JSEngineInstance {
 public:
  virtual std::unique_ptr<jsi::Runtime> createJSRuntime(
      std::shared_ptr<MessageQueueThread> msgQueueThread) noexcept = 0;

  virtual ~JSEngineInstance() = default;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
