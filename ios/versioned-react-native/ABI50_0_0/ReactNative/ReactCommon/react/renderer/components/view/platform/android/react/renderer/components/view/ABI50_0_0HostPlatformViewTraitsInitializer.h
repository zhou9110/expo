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

inline bool formsStackingContext(const ViewProps& viewProps) {
  return viewProps.elevation != 0;
}

inline bool formsView(const ViewProps& viewProps) {
  return viewProps.nativeBackground.has_value() ||
      viewProps.nativeForeground.has_value() || viewProps.focusable ||
      viewProps.hasTVPreferredFocus ||
      viewProps.needsOffscreenAlphaCompositing ||
      viewProps.renderToHardwareTextureAndroid;
}

inline ShadowNodeTraits::Trait extraTraits() {
  return ShadowNodeTraits::Trait::AndroidMapBufferPropsSupported;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React::HostPlatformViewTraitsInitializer
