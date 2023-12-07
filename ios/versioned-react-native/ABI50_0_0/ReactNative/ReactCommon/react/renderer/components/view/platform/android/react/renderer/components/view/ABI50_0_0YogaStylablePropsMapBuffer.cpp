/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0ViewPropsMapBuffer.h"

#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewProps.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0viewPropConversions.h>
#include <ABI50_0_0React/renderer/mapbuffer/ABI50_0_0MapBufferBuilder.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

MapBuffer convertBorderWidths(const yoga::Style::Edges& border) {
  MapBufferBuilder builder(7);
  putOptionalFloat(
      builder, EDGE_TOP, optionalFloatFromYogaValue(border[ABI50_0_0YGEdgeTop]));
  putOptionalFloat(
      builder, EDGE_RIGHT, optionalFloatFromYogaValue(border[ABI50_0_0YGEdgeRight]));
  putOptionalFloat(
      builder, EDGE_BOTTOM, optionalFloatFromYogaValue(border[ABI50_0_0YGEdgeBottom]));
  putOptionalFloat(
      builder, EDGE_LEFT, optionalFloatFromYogaValue(border[ABI50_0_0YGEdgeLeft]));
  putOptionalFloat(
      builder, EDGE_START, optionalFloatFromYogaValue(border[ABI50_0_0YGEdgeStart]));
  putOptionalFloat(
      builder, EDGE_END, optionalFloatFromYogaValue(border[ABI50_0_0YGEdgeEnd]));
  putOptionalFloat(
      builder, EDGE_ALL, optionalFloatFromYogaValue(border[ABI50_0_0YGEdgeAll]));
  return builder.build();
}

// TODO: Currently unsupported: nextFocusForward/Left/Up/Right/Down
void YogaStylableProps::propsDiffMapBuffer(
    const Props* oldPropsPtr,
    MapBufferBuilder& builder) const {
  // Call with default props if necessary
  if (oldPropsPtr == nullptr) {
    YogaStylableProps defaultProps{};
    propsDiffMapBuffer(&defaultProps, builder);
    return;
  }

  // Delegate to base classes
  Props::propsDiffMapBuffer(oldPropsPtr, builder);

  const YogaStylableProps& oldProps =
      *(static_cast<const YogaStylableProps*>(oldPropsPtr));
  const YogaStylableProps& newProps = *this;

  if (oldProps.yogaStyle != newProps.yogaStyle) {
    const auto& oldStyle = oldProps.yogaStyle;
    const auto& newStyle = newProps.yogaStyle;

    if (!(oldStyle.border() == newStyle.border())) {
      builder.putMapBuffer(
          ABI50_0_0YG_BORDER_WIDTH, convertBorderWidths(newStyle.border()));
    }

    if (oldStyle.overflow() != newStyle.overflow()) {
      int value;
      switch (newStyle.overflow()) {
        case yoga::Overflow::Visible:
          value = 0;
          break;
        case yoga::Overflow::Hidden:
          value = 1;
          break;
        case yoga::Overflow::Scroll:
          value = 2;
          break;
      }
      builder.putInt(ABI50_0_0YG_OVERFLOW, value);
    }
  }
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
