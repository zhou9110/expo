/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/inputaccessory/ABI50_0_0InputAccessoryState.h>
#include <ABI50_0_0React/renderer/components/rncore/ABI50_0_0EventEmitters.h>
#include <ABI50_0_0React/renderer/components/rncore/ABI50_0_0Props.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ConcreteViewShadowNode.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

extern const char InputAccessoryComponentName[];

/*
 * `ShadowNode` for <InputAccessory> component.
 */
class InputAccessoryShadowNode final : public ConcreteViewShadowNode<
                                           InputAccessoryComponentName,
                                           InputAccessoryProps,
                                           InputAccessoryEventEmitter,
                                           InputAccessoryState> {
 public:
  using ConcreteViewShadowNode::ConcreteViewShadowNode;

  static ShadowNodeTraits BaseTraits() {
    auto traits = ConcreteViewShadowNode::BaseTraits();
    traits.set(ShadowNodeTraits::Trait::RootNodeKind);
    return traits;
  }
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
