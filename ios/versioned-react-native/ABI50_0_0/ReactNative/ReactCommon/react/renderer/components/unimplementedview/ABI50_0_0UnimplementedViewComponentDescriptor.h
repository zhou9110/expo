/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/unimplementedview/ABI50_0_0UnimplementedViewShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ConcreteComponentDescriptor.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Descriptor for <UnimplementedView> component.
 */
class UnimplementedViewComponentDescriptor final
    : public ConcreteComponentDescriptor<UnimplementedViewShadowNode> {
 public:
  using ConcreteComponentDescriptor::ConcreteComponentDescriptor;

  /*
   * Returns `name` and `handle` based on a `flavor`, not on static data from
   * `UnimplementedViewShadowNode`.
   */
  ComponentHandle getComponentHandle() const override;
  ComponentName getComponentName() const override;

  /*
   * In addition to base implementation, stores a component name inside cloned
   * `Props` object.
   */
  Props::Shared cloneProps(
      const PropsParserContext& context,
      const Props::Shared& props,
      const RawProps& rawProps) const override;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
