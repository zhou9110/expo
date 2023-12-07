/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <tuple>

#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Float.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Point.h>
#include <ABI50_0_0React/utils/ABI50_0_0hash_combine.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Contains width and height values.
 */
struct Size {
  Float width{0};
  Float height{0};

  Size& operator+=(const Point& point) noexcept {
    width += point.x;
    height += point.y;
    return *this;
  }

  Size& operator*=(const Point& point) noexcept {
    width *= point.x;
    height *= point.y;
    return *this;
  }
};

inline bool operator==(const Size& rhs, const Size& lhs) noexcept {
  return std::tie(lhs.width, lhs.height) == std::tie(rhs.width, rhs.height);
}

inline bool operator!=(const Size& rhs, const Size& lhs) noexcept {
  return !(lhs == rhs);
}

} // namespace ABI50_0_0facebook::ABI50_0_0React

namespace std {

template <>
struct hash<ABI50_0_0facebook::ABI50_0_0React::Size> {
  size_t operator()(const ABI50_0_0facebook::ABI50_0_0React::Size& size) const {
    return ABI50_0_0facebook::ABI50_0_0React::hash_combine(size.width, size.height);
  }
};

} // namespace std
