/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0ParagraphState.h"

#include <ABI50_0_0React/renderer/components/text/ABI50_0_0conversions.h>
#include <ABI50_0_0React/renderer/debug/ABI50_0_0debugStringConvertibleUtils.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

#ifdef ANDROID
folly::dynamic ParagraphState::getDynamic() const {
  return toDynamic(*this);
}

MapBuffer ParagraphState::getMapBuffer() const {
  return toMapBuffer(*this);
}
#endif

} // namespace ABI50_0_0facebook::ABI50_0_0React
