/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0ParagraphAttributes.h>
#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0TextAttributes.h>
#include <ABI50_0_0React/renderer/components/iostextinput/ABI50_0_0conversions.h>
#include <ABI50_0_0React/renderer/components/iostextinput/ABI50_0_0primitives.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0BaseTextProps.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewProps.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0Props.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0propsConversions.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Color.h>
#include <ABI50_0_0React/renderer/imagemanager/ABI50_0_0primitives.h>
#include <vector>

namespace ABI50_0_0facebook::ABI50_0_0React {

class TextInputProps final : public ViewProps, public BaseTextProps {
 public:
  TextInputProps() = default;
  TextInputProps(
      const PropsParserContext& context,
      const TextInputProps& sourceProps,
      const RawProps& rawProps);

  void setProp(
      const PropsParserContext& context,
      RawPropsPropNameHash hash,
      const char* propName,
      const RawValue& value);

#pragma mark - Props

  const TextInputTraits traits{};
  const ParagraphAttributes paragraphAttributes{};

  std::string const defaultValue{};

  std::string const placeholder{};
  const SharedColor placeholderTextColor{};

  int maxLength{};

  /*
   * Tint colors
   */
  const SharedColor cursorColor{};
  const SharedColor selectionColor{};
  // TODO: Rename to `tintColor` and make universal.
  const SharedColor underlineColorAndroid{};

  /*
   * "Private" (only used by TextInput.js) props
   */
  std::string const text{};
  const int mostRecentEventCount{0};

  bool autoFocus{false};
  std::optional<Selection> selection{};

  std::string const inputAccessoryViewID{};

  bool onKeyPressSync{false};
  bool onChangeSync{false};

  /*
   * Accessors
   */
  TextAttributes getEffectiveTextAttributes(Float fontSizeMultiplier) const;
  ParagraphAttributes getEffectiveParagraphAttributes() const;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
