/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0State.h"

#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNodeFragment.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0State.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0StateData.h>

#include <utility>

namespace ABI50_0_0facebook::ABI50_0_0React {

State::State(StateData::Shared data, const State& previousState)
    : family_(previousState.family_),
      data_(std::move(data)),
      revision_(previousState.revision_ + 1){};

State::State(StateData::Shared data, const ShadowNodeFamily::Shared& family)
    : family_(family),
      data_(std::move(data)),
      revision_{State::initialRevisionValue} {};

State::Shared State::getMostRecentState() const {
  auto family = family_.lock();
  if (!family) {
    return {};
  }

  return family->getMostRecentState();
}

State::Shared State::getMostRecentStateIfObsolete() const {
  auto family = family_.lock();
  if (!family) {
    return {};
  }

  return family->getMostRecentStateIfObsolete(*this);
}

size_t State::getRevision() const {
  return revision_;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
