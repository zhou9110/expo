/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0yoga/algorithm/ABI50_0_0FlexDirection.h>
#include <ABI50_0_0yoga/algorithm/ABI50_0_0ResolveValue.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0FlexDirection.h>
#include <ABI50_0_0yoga/node/ABI50_0_0Node.h>
#include <ABI50_0_0yoga/numeric/ABI50_0_0Comparison.h>
#include <ABI50_0_0yoga/numeric/ABI50_0_0FloatOptional.h>

namespace ABI50_0_0facebook::yoga {

inline float paddingAndBorderForAxis(
    const yoga::Node* const node,
    const FlexDirection axis,
    const float widthSize) {
  return (node->getLeadingPaddingAndBorder(axis, widthSize) +
          node->getTrailingPaddingAndBorder(axis, widthSize))
      .unwrap();
}

inline FloatOptional boundAxisWithinMinAndMax(
    const yoga::Node* const node,
    const FlexDirection axis,
    const FloatOptional value,
    const float axisSize) {
  FloatOptional min;
  FloatOptional max;

  if (isColumn(axis)) {
    min = yoga::resolveValue(
        node->getStyle().minDimension(ABI50_0_0YGDimensionHeight), axisSize);
    max = yoga::resolveValue(
        node->getStyle().maxDimension(ABI50_0_0YGDimensionHeight), axisSize);
  } else if (isRow(axis)) {
    min = yoga::resolveValue(
        node->getStyle().minDimension(ABI50_0_0YGDimensionWidth), axisSize);
    max = yoga::resolveValue(
        node->getStyle().maxDimension(ABI50_0_0YGDimensionWidth), axisSize);
  }

  if (max >= FloatOptional{0} && value > max) {
    return max;
  }

  if (min >= FloatOptional{0} && value < min) {
    return min;
  }

  return value;
}

// Like boundAxisWithinMinAndMax but also ensures that the value doesn't
// go below the padding and border amount.
inline float boundAxis(
    const yoga::Node* const node,
    const FlexDirection axis,
    const float value,
    const float axisSize,
    const float widthSize) {
  return yoga::maxOrDefined(
      boundAxisWithinMinAndMax(node, axis, FloatOptional{value}, axisSize)
          .unwrap(),
      paddingAndBorderForAxis(node, axis, widthSize));
}

} // namespace ABI50_0_0facebook::yoga
