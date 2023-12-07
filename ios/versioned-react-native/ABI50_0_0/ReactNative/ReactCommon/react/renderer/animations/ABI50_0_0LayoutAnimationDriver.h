/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/animations/ABI50_0_0LayoutAnimationKeyFrameManager.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>
#include <ABI50_0_0React/renderer/mounting/ABI50_0_0ShadowViewMutation.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class LayoutAnimationDriver : public LayoutAnimationKeyFrameManager {
 public:
  LayoutAnimationDriver(
      RuntimeExecutor runtimeExecutor,
      ContextContainer::Shared& contextContainer,
      LayoutAnimationStatusDelegate* delegate)
      : LayoutAnimationKeyFrameManager(
            runtimeExecutor,
            contextContainer,
            delegate) {}

 protected:
  virtual void animationMutationsForFrame(
      SurfaceId surfaceId,
      ShadowViewMutation::List& mutationsList,
      uint64_t now) const override;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
