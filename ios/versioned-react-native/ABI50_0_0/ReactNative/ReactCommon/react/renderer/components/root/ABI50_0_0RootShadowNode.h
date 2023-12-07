/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>

#include <ABI50_0_0React/renderer/components/root/ABI50_0_0RootProps.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ConcreteViewShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutContext.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class RootShadowNode;

extern const char RootComponentName[];

/*
 * `ShadowNode` for the root component.
 * Besides all functionality of the `View` component, `RootShadowNode` contains
 * props which represent external layout constraints and context of the
 * shadow tree.
 */
class RootShadowNode final
    : public ConcreteViewShadowNode<RootComponentName, RootProps> {
 public:
  using ConcreteViewShadowNode::ConcreteViewShadowNode;

  using Shared = std::shared_ptr<const RootShadowNode>;
  using Unshared = std::shared_ptr<RootShadowNode>;

  static ShadowNodeTraits BaseTraits() {
    auto traits = ConcreteViewShadowNode::BaseTraits();
    traits.set(ShadowNodeTraits::Trait::RootNodeKind);
    return traits;
  }

  /*
   * Layouts the shadow tree if needed.
   * Returns `false` if the three is already laid out.
   */
  bool layoutIfNeeded(
      std::vector<const LayoutableShadowNode*>* affectedNodes = {});

  /*
   * Clones the node with given `layoutConstraints` and `layoutContext`.
   */
  RootShadowNode::Unshared clone(
      const PropsParserContext& propsParserContext,
      const LayoutConstraints& layoutConstraints,
      const LayoutContext& layoutContext) const;

  Transform getTransform() const override;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
