/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0TextAttributes.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0Props.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Color.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * `Props`-like class which is used as a base class for all Props classes
 * that can have text attributes (such as Text and Paragraph).
 */
class BaseTextProps {
 public:
  BaseTextProps() = default;
  BaseTextProps(
      const PropsParserContext& context,
      const BaseTextProps& sourceProps,
      const RawProps& rawProps);

  void setProp(
      const PropsParserContext& context,
      RawPropsPropNameHash hash,
      const char* propName,
      const RawValue& value);

#pragma mark - Props

  TextAttributes textAttributes{};

#pragma mark - DebugStringConvertible (partially)

#if ABI50_0_0RN_DEBUG_STRING_CONVERTIBLE
  SharedDebugStringConvertibleList getDebugProps() const;
#endif
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
