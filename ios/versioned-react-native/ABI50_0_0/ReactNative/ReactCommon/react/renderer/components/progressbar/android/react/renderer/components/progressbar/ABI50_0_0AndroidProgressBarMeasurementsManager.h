/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/progressbar/ABI50_0_0conversions.h>
#include <ABI50_0_0React/renderer/components/rncore/ABI50_0_0Props.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ConcreteComponentDescriptor.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutConstraints.h>
#include <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class AndroidProgressBarMeasurementsManager {
 public:
  AndroidProgressBarMeasurementsManager(
      const ContextContainer::Shared& contextContainer)
      : contextContainer_(contextContainer) {}

  Size measure(
      SurfaceId surfaceId,
      const AndroidProgressBarProps& props,
      LayoutConstraints layoutConstraints) const;

 private:
  const ContextContainer::Shared contextContainer_;
  mutable std::mutex mutex_;
  mutable bool hasBeenMeasured_ = false;
  mutable Size cachedMeasurement_{};
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
