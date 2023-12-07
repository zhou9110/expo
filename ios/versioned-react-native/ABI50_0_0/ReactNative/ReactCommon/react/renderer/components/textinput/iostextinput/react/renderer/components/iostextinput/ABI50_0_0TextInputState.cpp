/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0TextInputState.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

#ifdef ANDROID
TextInputState::TextInputState(
    const TextInputState& /*previousState*/,
    const folly::dynamic& /*data*/){};

/*
 * Empty implementation for Android because it doesn't use this class.
 */
folly::dynamic TextInputState::getDynamic() const {
  return {};
};

/*
 * Empty implementation for Android because it doesn't use this class.
 */
MapBuffer TextInputState::getMapBuffer() const {
  return MapBufferBuilder::EMPTY();
};
#endif

} // namespace ABI50_0_0facebook::ABI50_0_0React
