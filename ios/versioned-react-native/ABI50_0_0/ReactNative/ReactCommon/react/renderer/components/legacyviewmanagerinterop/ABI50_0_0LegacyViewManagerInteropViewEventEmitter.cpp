/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0LegacyViewManagerInteropViewEventEmitter.h"
#include <iostream>

namespace ABI50_0_0facebook::ABI50_0_0React {
void LegacyViewManagerInteropViewEventEmitter::dispatchEvent(
    const std::string& type,
    const folly::dynamic& payload) const {
  EventEmitter::dispatchEvent(type, payload);
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
