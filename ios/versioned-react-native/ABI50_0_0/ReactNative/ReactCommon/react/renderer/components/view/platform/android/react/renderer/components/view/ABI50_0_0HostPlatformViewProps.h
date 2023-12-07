/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/view/ABI50_0_0BaseViewProps.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0NativeDrawable.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0primitives.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutMetrics.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0Props.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Color.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Transform.h>

#include <optional>

namespace ABI50_0_0facebook::ABI50_0_0React {

class HostPlatformViewProps : public BaseViewProps {
 public:
  HostPlatformViewProps() = default;
  HostPlatformViewProps(
      const PropsParserContext& context,
      const HostPlatformViewProps& sourceProps,
      const RawProps& rawProps);

  void setProp(
      const PropsParserContext& context,
      RawPropsPropNameHash hash,
      const char* propName,
      const RawValue& value);

  void propsDiffMapBuffer(const Props* oldProps, MapBufferBuilder& builder)
      const override;

#pragma mark - Props

  Float elevation{};

  std::optional<NativeDrawable> nativeBackground{};
  std::optional<NativeDrawable> nativeForeground{};

  bool focusable{false};
  bool hasTVPreferredFocus{false};
  bool needsOffscreenAlphaCompositing{false};
  bool renderToHardwareTextureAndroid{false};

#pragma mark - Convenience Methods

  bool getProbablyMoreHorizontalThanVertical_DEPRECATED() const;

#if ABI50_0_0RN_DEBUG_STRING_CONVERTIBLE
  SharedDebugStringConvertibleList getDebugProps() const override;
#endif
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
