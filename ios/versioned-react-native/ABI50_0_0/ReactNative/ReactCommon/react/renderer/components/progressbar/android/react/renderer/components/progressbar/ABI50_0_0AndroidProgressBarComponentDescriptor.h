/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/core/ABI50_0_0ConcreteComponentDescriptor.h>
#include "ABI50_0_0AndroidProgressBarMeasurementsManager.h"
#include "ABI50_0_0AndroidProgressBarShadowNode.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Descriptor for <AndroidProgressBar> component.
 */
class AndroidProgressBarComponentDescriptor final
    : public ConcreteComponentDescriptor<AndroidProgressBarShadowNode> {
 public:
  AndroidProgressBarComponentDescriptor(
      const ComponentDescriptorParameters& parameters)
      : ConcreteComponentDescriptor(parameters),
        measurementsManager_(
            std::make_shared<AndroidProgressBarMeasurementsManager>(
                contextContainer_)) {}

  void adopt(ShadowNode& shadowNode) const override {
    ConcreteComponentDescriptor::adopt(shadowNode);

    auto& androidProgressBarShadowNode =
        static_cast<AndroidProgressBarShadowNode&>(shadowNode);

    // `AndroidProgressBarShadowNode` uses
    // `AndroidProgressBarMeasurementsManager` to provide measurements to Yoga.
    androidProgressBarShadowNode.setAndroidProgressBarMeasurementsManager(
        measurementsManager_);

    // All `AndroidProgressBarShadowNode`s must have leaf Yoga nodes with
    // properly setup measure function.
    androidProgressBarShadowNode.enableMeasurement();
  }

 private:
  const std::shared_ptr<AndroidProgressBarMeasurementsManager>
      measurementsManager_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
