/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTHermesInstance.h"

namespace ABI50_0_0facebook {
namespace ABI50_0_0React {
ABI50_0_0RCTHermesInstance::ABI50_0_0RCTHermesInstance() : ABI50_0_0RCTHermesInstance(nullptr, nullptr) {}

ABI50_0_0RCTHermesInstance::ABI50_0_0RCTHermesInstance(
    std::shared_ptr<const ABI50_0_0ReactNativeConfig> ABI50_0_0ReactNativeConfig,
    CrashManagerProvider crashManagerProvider)
    : _ABI50_0_0ReactNativeConfig(std::move(ABI50_0_0ReactNativeConfig)),
      _crashManagerProvider(std::move(crashManagerProvider)),
      _hermesInstance(std::make_unique<HermesInstance>())
{
}

std::unique_ptr<jsi::Runtime> ABI50_0_0RCTHermesInstance::createJSRuntime(
    std::shared_ptr<MessageQueueThread> msgQueueThread) noexcept
{
  return _hermesInstance->createJSRuntime(
      _ABI50_0_0ReactNativeConfig, _crashManagerProvider ? _crashManagerProvider() : nullptr, msgQueueThread);
}

} // namespace ABI50_0_0React
} // namespace ABI50_0_0facebook
