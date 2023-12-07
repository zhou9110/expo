/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <limits>

#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutPrimitives.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Size.h>
#include <ABI50_0_0React/utils/ABI50_0_0hash_combine.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Unified layout constraints for measuring.
 */
struct LayoutConstraints {
  Size minimumSize{0, 0};
  Size maximumSize{
      std::numeric_limits<Float>::infinity(),
      std::numeric_limits<Float>::infinity()};
  LayoutDirection layoutDirection{LayoutDirection::Undefined};

  /*
   * Clamps the provided `Size` between the `minimumSize` and `maximumSize`
   * bounds of this `LayoutConstraints`.
   */
  Size clamp(const Size& size) const;
};

inline bool operator==(
    const LayoutConstraints& lhs,
    const LayoutConstraints& rhs) {
  return std::tie(lhs.minimumSize, lhs.maximumSize, lhs.layoutDirection) ==
      std::tie(rhs.minimumSize, rhs.maximumSize, rhs.layoutDirection);
}

inline bool operator!=(
    const LayoutConstraints& lhs,
    const LayoutConstraints& rhs) {
  return !(lhs == rhs);
}

} // namespace ABI50_0_0facebook::ABI50_0_0React

namespace std {
template <>
struct hash<ABI50_0_0facebook::ABI50_0_0React::LayoutConstraints> {
  size_t operator()(
      const ABI50_0_0facebook::ABI50_0_0React::LayoutConstraints& constraints) const {
    return ABI50_0_0facebook::ABI50_0_0React::hash_combine(
        constraints.minimumSize,
        constraints.maximumSize,
        constraints.layoutDirection);
  }
};
} // namespace std
