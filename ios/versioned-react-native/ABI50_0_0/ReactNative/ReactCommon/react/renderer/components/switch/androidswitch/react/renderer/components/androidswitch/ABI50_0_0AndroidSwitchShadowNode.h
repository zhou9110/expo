/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include "ABI50_0_0AndroidSwitchMeasurementsManager.h"

#include <ABI50_0_0React/renderer/components/rncore/ABI50_0_0EventEmitters.h>
#include <ABI50_0_0React/renderer/components/rncore/ABI50_0_0Props.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ConcreteViewShadowNode.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

extern const char AndroidSwitchComponentName[];

/*
 * `ShadowNode` for <AndroidSwitch> component.
 */
class AndroidSwitchShadowNode final : public ConcreteViewShadowNode<
                                          AndroidSwitchComponentName,
                                          AndroidSwitchProps,
                                          AndroidSwitchEventEmitter> {
 public:
  using ConcreteViewShadowNode::ConcreteViewShadowNode;

  // Associates a shared `AndroidSwitchMeasurementsManager` with the node.
  void setAndroidSwitchMeasurementsManager(
      const std::shared_ptr<AndroidSwitchMeasurementsManager>&
          measurementsManager);

#pragma mark - LayoutableShadowNode

  Size measureContent(
      const LayoutContext& layoutContext,
      const LayoutConstraints& layoutConstraints) const override;

 private:
  std::shared_ptr<AndroidSwitchMeasurementsManager> measurementsManager_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
