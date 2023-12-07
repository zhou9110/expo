/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <limits>

#include <ABI50_0_0React/renderer/components/text/ABI50_0_0BaseTextShadowNode.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0TextProps.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewEventEmitter.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ConcreteShadowNode.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

extern const char TextComponentName[];

using TextEventEmitter = TouchEventEmitter;

class TextShadowNode : public ConcreteShadowNode<
                           TextComponentName,
                           ShadowNode,
                           TextProps,
                           TextEventEmitter>,
                       public BaseTextShadowNode {
 public:
  static ShadowNodeTraits BaseTraits() {
    auto traits = ConcreteShadowNode::BaseTraits();

#ifdef ANDROID
    traits.set(ShadowNodeTraits::Trait::FormsView);
#endif
    traits.set(IdentifierTrait());

    return traits;
  }

  static ShadowNodeTraits::Trait IdentifierTrait() {
    return ShadowNodeTraits::Trait::Text;
  }

  using ConcreteShadowNode::ConcreteShadowNode;

#ifdef ANDROID
  using BaseShadowNode = ConcreteShadowNode<
      TextComponentName,
      ShadowNode,
      TextProps,
      TextEventEmitter>;

  TextShadowNode(
      const ShadowNodeFragment& fragment,
      const ShadowNodeFamily::Shared& family,
      ShadowNodeTraits traits)
      : BaseShadowNode(fragment, family, traits), BaseTextShadowNode() {
    orderIndex_ = std::numeric_limits<decltype(orderIndex_)>::max();
  }
#endif
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
