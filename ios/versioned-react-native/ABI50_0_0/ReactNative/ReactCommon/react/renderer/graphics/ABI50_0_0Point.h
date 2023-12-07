/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <tuple>

#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Float.h>
#include <ABI50_0_0React/utils/ABI50_0_0hash_combine.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Contains a point in a two-dimensional coordinate system.
 */
struct Point {
  Float x{0};
  Float y{0};

  Point& operator+=(const Point& point) noexcept {
    x += point.x;
    y += point.y;
    return *this;
  }

  Point& operator-=(const Point& point) noexcept {
    x -= point.x;
    y -= point.y;
    return *this;
  }

  Point& operator*=(const Point& point) noexcept {
    x *= point.x;
    y *= point.y;
    return *this;
  }

  friend Point operator+(Point lhs, const Point& rhs) noexcept {
    return lhs += rhs;
  }

  friend Point operator-(Point lhs, const Point& rhs) noexcept {
    return lhs -= rhs;
  }
};

inline bool operator==(const Point& rhs, const Point& lhs) noexcept {
  return std::tie(lhs.x, lhs.y) == std::tie(rhs.x, rhs.y);
}

inline bool operator!=(const Point& rhs, const Point& lhs) noexcept {
  return !(lhs == rhs);
}

} // namespace ABI50_0_0facebook::ABI50_0_0React

namespace std {

template <>
struct hash<ABI50_0_0facebook::ABI50_0_0React::Point> {
  size_t operator()(const ABI50_0_0facebook::ABI50_0_0React::Point& point) const noexcept {
    return ABI50_0_0facebook::ABI50_0_0React::hash_combine(point.x, point.y);
  }
};

} // namespace std
