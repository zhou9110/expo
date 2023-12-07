/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/graphics/ABI50_0_0ColorComponents.h>
#include <cmath>

namespace ABI50_0_0facebook::ABI50_0_0React {

using Color = int32_t;

namespace HostPlatformColor {
static const ABI50_0_0facebook::ABI50_0_0React::Color UndefinedColor =
    std::numeric_limits<ABI50_0_0facebook::ABI50_0_0React::Color>::max();
}

inline Color hostPlatformColorFromComponents(ColorComponents components) {
  float ratio = 255;
  return ((int)round(components.alpha * ratio) & 0xff) << 24 |
      ((int)round(components.red * ratio) & 0xff) << 16 |
      ((int)round(components.green * ratio) & 0xff) << 8 |
      ((int)round(components.blue * ratio) & 0xff);
}

inline ColorComponents colorComponentsFromHostPlatformColor(Color color) {
  float ratio = 255;
  return ColorComponents{
      (float)((color >> 16) & 0xff) / ratio,
      (float)((color >> 8) & 0xff) / ratio,
      (float)((color >> 0) & 0xff) / ratio,
      (float)((color >> 24) & 0xff) / ratio};
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
