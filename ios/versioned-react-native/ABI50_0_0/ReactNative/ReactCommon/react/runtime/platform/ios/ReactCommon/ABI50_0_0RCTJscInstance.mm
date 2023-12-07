/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTJscInstance.h"
#include <ABI50_0_0jsc/ABI50_0_0JSCRuntime.h>

namespace ABI50_0_0facebook {
namespace ABI50_0_0React {

ABI50_0_0RCTJscInstance::ABI50_0_0RCTJscInstance() {}

std::unique_ptr<jsi::Runtime> ABI50_0_0RCTJscInstance::createJSRuntime(
    std::shared_ptr<MessageQueueThread> msgQueueThread) noexcept
{
  return jsc::makeJSCRuntime();
}

} // namespace ABI50_0_0React
} // namespace ABI50_0_0facebook
