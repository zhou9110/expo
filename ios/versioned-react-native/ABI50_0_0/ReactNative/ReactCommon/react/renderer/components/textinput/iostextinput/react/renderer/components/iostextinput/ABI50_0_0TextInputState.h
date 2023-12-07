/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0AttributedStringBox.h>
#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0ParagraphAttributes.h>
#include <ABI50_0_0React/renderer/textlayoutmanager/ABI50_0_0TextLayoutManager.h>

#ifdef ANDROID
#include <folly/dynamic.h>
#include <ABI50_0_0React/renderer/mapbuffer/ABI50_0_0MapBuffer.h>
#include <ABI50_0_0React/renderer/mapbuffer/ABI50_0_0MapBufferBuilder.h>
#endif

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * State for <TextInput> component.
 */
class TextInputState final {
 public:
  TextInputState() = default;

  /*
   * All content of <TextInput> component.
   */
  AttributedStringBox attributedStringBox;

  /*
   * All content of <TextInput> component represented as an `AttributedString`.
   * This stores the previous computed *from the ABI50_0_0React tree*. This usually
   * doesn't change as the TextInput contents are being updated. If it does
   * change, we need to wipe out current contents of the TextInput and replace
   * with the new value from the tree.
   */
  AttributedString ABI50_0_0ReactTreeAttributedString{};

  /*
   * Represents all visual attributes of a paragraph of text represented as
   * a ParagraphAttributes.
   */
  ParagraphAttributes paragraphAttributes;

  /*
   * `TextLayoutManager` provides a connection to platform-specific
   * text rendering infrastructure which is capable to render the
   * `AttributedString`.
   */
  std::shared_ptr<const TextLayoutManager> layoutManager;

  size_t mostRecentEventCount{0};

#ifdef ANDROID
  TextInputState(
      const TextInputState& previousState,
      const folly::dynamic& data);

  folly::dynamic getDynamic() const;

  MapBuffer getMapBuffer() const;
#endif
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
