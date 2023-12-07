/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0PropsParserContext.h"

#include <react/config/ABI50_0_0ReactNativeConfig.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

bool PropsParserContext::treatAutoAsABI50_0_0YGValueUndefined() const {
  if (treatAutoAsABI50_0_0YGValueUndefined_ == std::nullopt) {
    auto config =
        contextContainer.find<std::shared_ptr<const ABI50_0_0ReactNativeConfig>>(
            "ABI50_0_0ReactNativeConfig");
    treatAutoAsABI50_0_0YGValueUndefined_ = config && *config != nullptr
        ? (*config)->getBool("ABI50_0_0React_fabric:treat_auto_as_undefined")
        : false;
  }

  return *treatAutoAsABI50_0_0YGValueUndefined_;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
