/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Float.h>

namespace {
enum class IntersectionObserverStateType {
  Initial,
  NotIntersecting,
  Intersecting,
};
}

namespace ABI50_0_0facebook::ABI50_0_0React {

class IntersectionObserverState {
 public:
  static IntersectionObserverState Initial();
  static IntersectionObserverState NotIntersecting();
  static IntersectionObserverState Intersecting(Float threshold);

  bool isIntersecting() const;

  bool operator==(const IntersectionObserverState& other) const;
  bool operator!=(const IntersectionObserverState& other) const;

 private:
  explicit IntersectionObserverState(IntersectionObserverStateType state);
  IntersectionObserverState(
      IntersectionObserverStateType state,
      Float threshold);

  IntersectionObserverStateType state_;

  // This value is only relevant if the state is
  // IntersectionObserverStateType::Intersecting.
  Float threshold_{};
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
