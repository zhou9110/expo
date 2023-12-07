/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0AndroidProgressBarShadowNode.h"

#include <ABI50_0_0React/renderer/components/progressbar/ABI50_0_0AndroidProgressBarShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutContext.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

extern const char AndroidProgressBarComponentName[] = "AndroidProgressBar";

void AndroidProgressBarShadowNode::setAndroidProgressBarMeasurementsManager(
    const std::shared_ptr<AndroidProgressBarMeasurementsManager>&
        measurementsManager) {
  ensureUnsealed();
  measurementsManager_ = measurementsManager;
}

#pragma mark - LayoutableShadowNode

Size AndroidProgressBarShadowNode::measureContent(
    const LayoutContext& /*layoutContext*/,
    const LayoutConstraints& layoutConstraints) const {
  return measurementsManager_->measure(
      getSurfaceId(), getConcreteProps(), layoutConstraints);
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
