/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>

#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0AttributedStringBox.h>
#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0ParagraphAttributes.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutConstraints.h>
#include <ABI50_0_0React/renderer/textlayoutmanager/ABI50_0_0TextMeasureCache.h>
#include <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class TextLayoutManager;

/*
 * Cross platform facade for iOS-specific ABI50_0_0RCTTTextLayoutManager.
 */
class TextLayoutManager {
 public:
  TextLayoutManager(const ContextContainer::Shared& contextContainer);

  /*
   * Measures `attributedString` using native text rendering infrastructure.
   */
  TextMeasurement measure(
      AttributedStringBox attributedStringBox,
      ParagraphAttributes paragraphAttributes,
      LayoutConstraints layoutConstraints,
      std::shared_ptr<void> hostTextStorage) const;

  /*
   * Measures lines of `attributedString` using native text rendering
   * infrastructure.
   */
  LinesMeasurements measureLines(
      AttributedString attributedString,
      ParagraphAttributes paragraphAttributes,
      Size size) const;

  std::shared_ptr<void> getHostTextStorage(
      AttributedString attributedString,
      ParagraphAttributes paragraphAttributes,
      LayoutConstraints layoutConstraints) const;

  /*
   * Returns an opaque pointer to platform-specific TextLayoutManager.
   * Is used on a native views layer to delegate text rendering to the manager.
   */
  std::shared_ptr<void> getNativeTextLayoutManager() const;

 private:
  std::shared_ptr<void> self_;
  TextMeasureCache measureCache_{};
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
