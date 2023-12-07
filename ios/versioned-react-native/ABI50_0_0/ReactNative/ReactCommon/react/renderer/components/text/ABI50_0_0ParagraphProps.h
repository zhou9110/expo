/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <limits>
#include <memory>

#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0ParagraphAttributes.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0BaseTextProps.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewProps.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0Props.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Props of <Paragraph> component.
 * Most of the props are directly stored in composed `ParagraphAttributes`
 * object.
 */
class ParagraphProps : public ViewProps, public BaseTextProps {
 public:
  ParagraphProps() = default;
  ParagraphProps(
      const PropsParserContext& context,
      const ParagraphProps& sourceProps,
      const RawProps& rawProps);

  void setProp(
      const PropsParserContext& context,
      RawPropsPropNameHash hash,
      const char* propName,
      const RawValue& value);

#pragma mark - Props

  /*
   * Contains all prop values that affect visual representation of the
   * paragraph.
   */
  ParagraphAttributes paragraphAttributes{};

  /*
   * Defines can the text be selected (and copied) or not.
   */
  bool isSelectable{};

  bool onTextLayout{};

#pragma mark - DebugStringConvertible

#if ABI50_0_0RN_DEBUG_STRING_CONVERTIBLE
  SharedDebugStringConvertibleList getDebugProps() const override;
#endif
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
