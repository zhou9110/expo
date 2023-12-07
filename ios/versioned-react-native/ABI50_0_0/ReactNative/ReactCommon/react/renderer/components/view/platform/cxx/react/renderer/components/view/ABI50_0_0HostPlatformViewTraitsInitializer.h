/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewProps.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNodeTraits.h>

namespace ABI50_0_0facebook::ABI50_0_0React::HostPlatformViewTraitsInitializer {

inline bool formsStackingContext(const ViewProps& props) {
  return false;
}

inline bool formsView(const ViewProps& props) {
  return false;
}

inline ShadowNodeTraits::Trait extraTraits() {
  return ShadowNodeTraits::Trait::None;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React::HostPlatformViewTraitsInitializer
