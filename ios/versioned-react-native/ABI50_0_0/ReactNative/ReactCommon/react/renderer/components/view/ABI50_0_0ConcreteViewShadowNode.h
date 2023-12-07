/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewEventEmitter.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewProps.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0YogaLayoutableShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ConcreteShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutableShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNodeFragment.h>
#include <ABI50_0_0React/renderer/debug/ABI50_0_0DebugStringConvertibleItem.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Template for all <View>-like classes (classes which have all same props
 * as <View> and similar basic behaviour).
 * For example: <Paragraph>, <Image>, but not <Text>, <RawText>.
 */
template <
    const char* concreteComponentName,
    typename ViewPropsT = ViewProps,
    typename ViewEventEmitterT = ViewEventEmitter,
    typename... Ts>
class ConcreteViewShadowNode : public ConcreteShadowNode<
                                   concreteComponentName,
                                   YogaLayoutableShadowNode,
                                   ViewPropsT,
                                   ViewEventEmitterT,
                                   Ts...> {
  static_assert(
      std::is_base_of<ViewProps, ViewPropsT>::value,
      "ViewPropsT must be a descendant of ViewProps");
  static_assert(
      std::is_base_of<YogaStylableProps, ViewPropsT>::value,
      "ViewPropsT must be a descendant of YogaStylableProps");
  static_assert(
      std::is_base_of<AccessibilityProps, ViewPropsT>::value,
      "ViewPropsT must be a descendant of AccessibilityProps");

 public:
  using BaseShadowNode = ConcreteShadowNode<
      concreteComponentName,
      YogaLayoutableShadowNode,
      ViewPropsT,
      ViewEventEmitterT,
      Ts...>;

  ConcreteViewShadowNode(
      const ShadowNodeFragment& fragment,
      const ShadowNodeFamily::Shared& family,
      ShadowNodeTraits traits)
      : BaseShadowNode(fragment, family, traits) {
    initialize();
  }

  ConcreteViewShadowNode(
      const ShadowNode& sourceShadowNode,
      const ShadowNodeFragment& fragment)
      : BaseShadowNode(sourceShadowNode, fragment) {
    initialize();
  }

  using ConcreteViewProps = ViewPropsT;

  using BaseShadowNode::BaseShadowNode;

  static ShadowNodeTraits BaseTraits() {
    auto traits = BaseShadowNode::BaseTraits();
    traits.set(ShadowNodeTraits::Trait::ViewKind);
    traits.set(ShadowNodeTraits::Trait::FormsStackingContext);
    traits.set(ShadowNodeTraits::Trait::FormsView);
    return traits;
  }

  Transform getTransform() const override {
    auto layoutMetrics = BaseShadowNode::getLayoutMetrics();
    return BaseShadowNode::getConcreteProps().resolveTransform(layoutMetrics);
  }

 private:
  void initialize() noexcept {
    auto& props = BaseShadowNode::getConcreteProps();

    if (props.yogaStyle.display() == yoga::Display::None) {
      BaseShadowNode::traits_.set(ShadowNodeTraits::Trait::Hidden);
    } else {
      BaseShadowNode::traits_.unset(ShadowNodeTraits::Trait::Hidden);
    }

    // `zIndex` is only defined for non-`static` positioned views.
    if (props.yogaStyle.positionType() != yoga::PositionType::Static) {
      BaseShadowNode::orderIndex_ = props.zIndex.value_or(0);
    } else {
      BaseShadowNode::orderIndex_ = 0;
    }
  }
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
