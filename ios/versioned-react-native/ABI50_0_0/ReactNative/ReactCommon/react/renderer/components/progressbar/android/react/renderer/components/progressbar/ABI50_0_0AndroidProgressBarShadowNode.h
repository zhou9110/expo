/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/progressbar/ABI50_0_0AndroidProgressBarMeasurementsManager.h>
#include <ABI50_0_0React/renderer/components/rncore/ABI50_0_0EventEmitters.h>
#include <ABI50_0_0React/renderer/components/rncore/ABI50_0_0Props.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ConcreteViewShadowNode.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

extern const char AndroidProgressBarComponentName[];

/*
 * `ShadowNode` for <AndroidProgressBar> component.
 */
class AndroidProgressBarShadowNode final : public ConcreteViewShadowNode<
                                               AndroidProgressBarComponentName,
                                               AndroidProgressBarProps,
                                               AndroidProgressBarEventEmitter> {
 public:
  using ConcreteViewShadowNode::ConcreteViewShadowNode;

  // Associates a shared `AndroidProgressBarMeasurementsManager` with the node.
  void setAndroidProgressBarMeasurementsManager(
      const std::shared_ptr<AndroidProgressBarMeasurementsManager>&
          measurementsManager);

#pragma mark - LayoutableShadowNode

  Size measureContent(
      const LayoutContext& layoutContext,
      const LayoutConstraints& layoutConstraints) const override;

 private:
  std::shared_ptr<AndroidProgressBarMeasurementsManager> measurementsManager_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
