/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/view/ABI50_0_0AccessibilityProps.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0YogaStylableProps.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0primitives.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutMetrics.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0Props.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Color.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Transform.h>

#include <optional>

namespace ABI50_0_0facebook::ABI50_0_0React {

class BaseViewProps : public YogaStylableProps, public AccessibilityProps {
 public:
  BaseViewProps() = default;
  BaseViewProps(
      const PropsParserContext& context,
      const BaseViewProps& sourceProps,
      const RawProps& rawProps);

  void setProp(
      const PropsParserContext& context,
      RawPropsPropNameHash hash,
      const char* propName,
      const RawValue& value);

#pragma mark - Props

  // Color
  Float opacity{1.0};
  SharedColor backgroundColor{};

  // Borders
  CascadedBorderRadii borderRadii{};
  CascadedBorderColors borderColors{};
  CascadedBorderCurves borderCurves{}; // iOS only?
  CascadedBorderStyles borderStyles{};

  // Shadow
  SharedColor shadowColor{};
  Size shadowOffset{0, -3};
  Float shadowOpacity{};
  Float shadowRadius{3};

  // Transform
  Transform transform{};
  TransformOrigin transformOrigin{};
  BackfaceVisibility backfaceVisibility{};
  bool shouldRasterize{};
  std::optional<int> zIndex{};

  // Events
  PointerEventsMode pointerEvents{};
  EdgeInsets hitSlop{};
  bool onLayout{};

  ViewEvents events{};

  bool collapsable{true};

  bool removeClippedSubviews{false};

  LayoutConformance experimental_layoutConformance{};

#pragma mark - Convenience Methods

  BorderMetrics resolveBorderMetrics(const LayoutMetrics& layoutMetrics) const;
  Transform resolveTransform(const LayoutMetrics& layoutMetrics) const;
  bool getClipsContentToBounds() const;

#if ABI50_0_0RN_DEBUG_STRING_CONVERTIBLE
  SharedDebugStringConvertibleList getDebugProps() const override;
#endif
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
