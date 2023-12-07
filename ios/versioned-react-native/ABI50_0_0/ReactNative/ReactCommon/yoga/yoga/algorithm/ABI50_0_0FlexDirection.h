/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0yoga/ABI50_0_0Yoga.h>

#include <ABI50_0_0yoga/debug/ABI50_0_0AssertFatal.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0FlexDirection.h>

namespace ABI50_0_0facebook::yoga {

inline bool isRow(const FlexDirection flexDirection) {
  return flexDirection == FlexDirection::Row ||
      flexDirection == FlexDirection::RowReverse;
}

inline bool isColumn(const FlexDirection flexDirection) {
  return flexDirection == FlexDirection::Column ||
      flexDirection == FlexDirection::ColumnReverse;
}

inline FlexDirection resolveDirection(
    const FlexDirection flexDirection,
    const Direction direction) {
  if (direction == Direction::RTL) {
    if (flexDirection == FlexDirection::Row) {
      return FlexDirection::RowReverse;
    } else if (flexDirection == FlexDirection::RowReverse) {
      return FlexDirection::Row;
    }
  }

  return flexDirection;
}

inline FlexDirection resolveCrossDirection(
    const FlexDirection flexDirection,
    const Direction direction) {
  return isColumn(flexDirection)
      ? resolveDirection(FlexDirection::Row, direction)
      : FlexDirection::Column;
}

inline ABI50_0_0YGEdge leadingEdge(const FlexDirection flexDirection) {
  switch (flexDirection) {
    case FlexDirection::Column:
      return ABI50_0_0YGEdgeTop;
    case FlexDirection::ColumnReverse:
      return ABI50_0_0YGEdgeBottom;
    case FlexDirection::Row:
      return ABI50_0_0YGEdgeLeft;
    case FlexDirection::RowReverse:
      return ABI50_0_0YGEdgeRight;
  }

  fatalWithMessage("Invalid FlexDirection");
}

inline ABI50_0_0YGEdge trailingEdge(const FlexDirection flexDirection) {
  switch (flexDirection) {
    case FlexDirection::Column:
      return ABI50_0_0YGEdgeBottom;
    case FlexDirection::ColumnReverse:
      return ABI50_0_0YGEdgeTop;
    case FlexDirection::Row:
      return ABI50_0_0YGEdgeRight;
    case FlexDirection::RowReverse:
      return ABI50_0_0YGEdgeLeft;
  }

  fatalWithMessage("Invalid FlexDirection");
}

inline ABI50_0_0YGDimension dimension(const FlexDirection flexDirection) {
  switch (flexDirection) {
    case FlexDirection::Column:
      return ABI50_0_0YGDimensionHeight;
    case FlexDirection::ColumnReverse:
      return ABI50_0_0YGDimensionHeight;
    case FlexDirection::Row:
      return ABI50_0_0YGDimensionWidth;
    case FlexDirection::RowReverse:
      return ABI50_0_0YGDimensionWidth;
  }

  fatalWithMessage("Invalid FlexDirection");
}

} // namespace ABI50_0_0facebook::yoga
