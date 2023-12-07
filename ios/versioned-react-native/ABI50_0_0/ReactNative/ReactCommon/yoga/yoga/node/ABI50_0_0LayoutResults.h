/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <array>

#include <ABI50_0_0yoga/bits/ABI50_0_0NumericBitfield.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0Direction.h>
#include <ABI50_0_0yoga/node/ABI50_0_0CachedMeasurement.h>
#include <ABI50_0_0yoga/numeric/ABI50_0_0FloatOptional.h>

namespace ABI50_0_0facebook::yoga {

struct LayoutResults {
  // This value was chosen based on empirical data:
  // 98% of analyzed layouts require less than 8 entries.
  static constexpr int32_t MaxCachedMeasurements = 8;

  std::array<float, 4> position = {};
  std::array<float, 4> margin = {};
  std::array<float, 4> border = {};
  std::array<float, 4> padding = {};

 private:
  Direction direction_ : bitCount<Direction>() = Direction::Inherit;
  bool hadOverflow_ : 1 = false;

  std::array<float, 2> dimensions_ = {{ABI50_0_0YGUndefined, ABI50_0_0YGUndefined}};
  std::array<float, 2> measuredDimensions_ = {{ABI50_0_0YGUndefined, ABI50_0_0YGUndefined}};

 public:
  uint32_t computedFlexBasisGeneration = 0;
  FloatOptional computedFlexBasis = {};

  // Instead of recomputing the entire layout every single time, we cache some
  // information to break early when nothing changed
  uint32_t generationCount = 0;
  Direction lastOwnerDirection = Direction::Inherit;

  uint32_t nextCachedMeasurementsIndex = 0;
  std::array<CachedMeasurement, MaxCachedMeasurements> cachedMeasurements = {};

  CachedMeasurement cachedLayout{};

  Direction direction() const {
    return direction_;
  }

  void setDirection(Direction direction) {
    direction_ = direction;
  }

  bool hadOverflow() const {
    return hadOverflow_;
  }

  void setHadOverflow(bool hadOverflow) {
    hadOverflow_ = hadOverflow;
  }

  float dimension(ABI50_0_0YGDimension axis) const {
    return dimensions_[axis];
  }

  void setDimension(ABI50_0_0YGDimension axis, float dimension) {
    dimensions_[axis] = dimension;
  }

  float measuredDimension(ABI50_0_0YGDimension axis) const {
    return measuredDimensions_[axis];
  }

  void setMeasuredDimension(ABI50_0_0YGDimension axis, float dimension) {
    measuredDimensions_[axis] = dimension;
  }

  bool operator==(LayoutResults layout) const;
  bool operator!=(LayoutResults layout) const {
    return !(*this == layout);
  }
};

} // namespace ABI50_0_0facebook::yoga
