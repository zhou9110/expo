/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/text/ABI50_0_0RawTextProps.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ConcreteShadowNode.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

extern const char RawTextComponentName[];

/*
 * `ShadowNode` for <RawText> component, represents a purely regular string
 * object in ABI50_0_0React. In a code fragment `<Text>Hello!</Text>`, "Hello!" part
 * is represented as `<RawText text="Hello!"/>`.
 * <RawText> component must not have any children.
 */
class RawTextShadowNode : public ConcreteShadowNode<
                              RawTextComponentName,
                              ShadowNode,
                              RawTextProps> {
 public:
  using ConcreteShadowNode::ConcreteShadowNode;
  static ShadowNodeTraits BaseTraits() {
    auto traits = ConcreteShadowNode::BaseTraits();
    traits.set(IdentifierTrait());
    return traits;
  }
  static ShadowNodeTraits::Trait IdentifierTrait() {
    return ShadowNodeTraits::Trait::RawText;
  }
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
