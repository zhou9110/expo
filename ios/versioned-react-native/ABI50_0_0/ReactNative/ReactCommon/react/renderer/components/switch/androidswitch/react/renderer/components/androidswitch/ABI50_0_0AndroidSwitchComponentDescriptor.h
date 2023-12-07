/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include "ABI50_0_0AndroidSwitchMeasurementsManager.h"
#include "ABI50_0_0AndroidSwitchShadowNode.h"

#include <ABI50_0_0React/renderer/core/ABI50_0_0ConcreteComponentDescriptor.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Descriptor for <AndroidSwitch> component.
 */
class AndroidSwitchComponentDescriptor final
    : public ConcreteComponentDescriptor<AndroidSwitchShadowNode> {
 public:
  AndroidSwitchComponentDescriptor(
      const ComponentDescriptorParameters& parameters)
      : ConcreteComponentDescriptor(parameters),
        measurementsManager_(std::make_shared<AndroidSwitchMeasurementsManager>(
            contextContainer_)) {}

  void adopt(ShadowNode& shadowNode) const override {
    ConcreteComponentDescriptor::adopt(shadowNode);

    auto& androidSwitchShadowNode =
        static_cast<AndroidSwitchShadowNode&>(shadowNode);

    // `AndroidSwitchShadowNode` uses `AndroidSwitchMeasurementsManager` to
    // provide measurements to Yoga.
    androidSwitchShadowNode.setAndroidSwitchMeasurementsManager(
        measurementsManager_);

    // All `AndroidSwitchShadowNode`s must have leaf Yoga nodes with properly
    // setup measure function.
    androidSwitchShadowNode.enableMeasurement();
  }

 private:
  const std::shared_ptr<AndroidSwitchMeasurementsManager> measurementsManager_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
