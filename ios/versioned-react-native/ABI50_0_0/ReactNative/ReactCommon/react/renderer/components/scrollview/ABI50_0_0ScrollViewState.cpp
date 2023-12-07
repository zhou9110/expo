/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0ScrollViewState.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

ScrollViewState::ScrollViewState(
    Point contentOffset,
    Rect contentBoundingRect,
    int scrollAwayPaddingTop)
    : contentOffset(contentOffset),
      contentBoundingRect(contentBoundingRect),
      scrollAwayPaddingTop(scrollAwayPaddingTop) {}

Size ScrollViewState::getContentSize() const {
  return contentBoundingRect.size;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
