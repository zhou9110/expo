/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <folly/dynamic.h>
#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0conversions.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0ParagraphState.h>
#ifdef ANDROID
#include <ABI50_0_0React/renderer/mapbuffer/ABI50_0_0MapBuffer.h>
#include <ABI50_0_0React/renderer/mapbuffer/ABI50_0_0MapBufferBuilder.h>
#endif

namespace ABI50_0_0facebook::ABI50_0_0React {

#ifdef ANDROID
inline folly::dynamic toDynamic(const ParagraphState& paragraphState) {
  folly::dynamic newState = folly::dynamic::object();
  newState["attributedString"] = toDynamic(paragraphState.attributedString);
  newState["paragraphAttributes"] =
      toDynamic(paragraphState.paragraphAttributes);
  newState["hash"] = newState["attributedString"]["hash"];
  return newState;
}

inline MapBuffer toMapBuffer(const ParagraphState& paragraphState) {
  auto builder = MapBufferBuilder();
  auto attStringMapBuffer = toMapBuffer(paragraphState.attributedString);
  builder.putMapBuffer(TX_STATE_KEY_ATTRIBUTED_STRING, attStringMapBuffer);
  auto paMapBuffer = toMapBuffer(paragraphState.paragraphAttributes);
  builder.putMapBuffer(TX_STATE_KEY_PARAGRAPH_ATTRIBUTES, paMapBuffer);
  builder.putInt(TX_STATE_KEY_HASH, attStringMapBuffer.getInt(AS_KEY_HASH));
  return builder.build();
}
#endif

} // namespace ABI50_0_0facebook::ABI50_0_0React
