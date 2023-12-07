/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ConcreteViewShadowNode.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewProps.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ConcreteComponentDescriptor.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Descriptor for <UnstableABI50_0_0ReactLegacyComponent> component.
 *
 * This component is part of the Fabric Interop Layer and is subject to future
 * changes (hence the "Unstable" prefix).
 */
template <const char* concreteComponentName>
class UnstableLegacyViewManagerInteropComponentDescriptor
    : public ConcreteComponentDescriptor<
          ConcreteViewShadowNode<concreteComponentName, ViewProps>> {
 public:
  UnstableLegacyViewManagerInteropComponentDescriptor<concreteComponentName>(
      const ComponentDescriptorParameters& parameters)
      : ConcreteComponentDescriptor<
            ConcreteViewShadowNode<concreteComponentName, ViewProps>>(
            parameters) {}

 private:
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
