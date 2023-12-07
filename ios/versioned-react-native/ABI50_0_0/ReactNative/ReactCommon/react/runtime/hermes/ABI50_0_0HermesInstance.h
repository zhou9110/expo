/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0cxxreact/ABI50_0_0MessageQueueThread.h>
#include <hermes/ABI50_0_0hermes.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <ABI50_0_0React/config/ABI50_0_0ReactNativeConfig.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class HermesInstance {
 public:
  static std::unique_ptr<jsi::Runtime> createJSRuntime(
      std::shared_ptr<const ABI50_0_0ReactNativeConfig> ABI50_0_0ReactNativeConfig,
      std::shared_ptr<::ABI50_0_0hermes::vm::CrashManager> cm,
      std::shared_ptr<MessageQueueThread> msgQueueThread) noexcept;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
