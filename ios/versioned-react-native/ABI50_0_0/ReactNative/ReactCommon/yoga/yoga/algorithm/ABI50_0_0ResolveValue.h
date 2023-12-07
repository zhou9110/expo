/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0yoga/ABI50_0_0Yoga.h>

#include <ABI50_0_0yoga/numeric/ABI50_0_0FloatOptional.h>
#include <ABI50_0_0yoga/style/ABI50_0_0CompactValue.h>

namespace ABI50_0_0facebook::yoga {

inline FloatOptional resolveValue(const ABI50_0_0YGValue value, const float ownerSize) {
  switch (value.unit) {
    case ABI50_0_0YGUnitPoint:
      return FloatOptional{value.value};
    case ABI50_0_0YGUnitPercent:
      return FloatOptional{value.value * ownerSize * 0.01f};
    default:
      return FloatOptional{};
  }
}

inline FloatOptional resolveValue(CompactValue value, float ownerSize) {
  return resolveValue((ABI50_0_0YGValue)value, ownerSize);
}

} // namespace ABI50_0_0facebook::yoga
