/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ConcreteComponentDescriptor.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class ViewComponentDescriptor
    : public ConcreteComponentDescriptor<ViewShadowNode> {
 public:
  ViewComponentDescriptor(const ComponentDescriptorParameters& parameters)
      : ConcreteComponentDescriptor<ViewShadowNode>(parameters) {}
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
