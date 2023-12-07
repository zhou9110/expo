/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/legacyviewmanagerinterop/ABI50_0_0LegacyViewManagerInteropShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ConcreteComponentDescriptor.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class LegacyViewManagerInteropComponentDescriptor final
    : public ConcreteComponentDescriptor<LegacyViewManagerInteropShadowNode> {
 public:
  using ConcreteComponentDescriptor::ConcreteComponentDescriptor;

  LegacyViewManagerInteropComponentDescriptor(
      const ComponentDescriptorParameters& parameters);
  /*
   * Returns `name` and `handle` based on a `flavor`, not on static data from
   * `LegacyViewManagerInteropShadowNode`.
   */
  ComponentHandle getComponentHandle() const override;
  ComponentName getComponentName() const override;

 protected:
  void adopt(ShadowNode& shadowNode) const override;

 private:
  const std::shared_ptr<void> _coordinator;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
