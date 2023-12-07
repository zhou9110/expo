/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/scrollview/ABI50_0_0ScrollViewEventEmitter.h>
#include <ABI50_0_0React/renderer/components/scrollview/ABI50_0_0ScrollViewProps.h>
#include <ABI50_0_0React/renderer/components/scrollview/ABI50_0_0ScrollViewState.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ConcreteViewShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutContext.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNodeFamily.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

extern const char ScrollViewComponentName[];

/*
 * `ShadowNode` for <ScrollView> component.
 */
class ScrollViewShadowNode final : public ConcreteViewShadowNode<
                                       ScrollViewComponentName,
                                       ScrollViewProps,
                                       ScrollViewEventEmitter,
                                       ScrollViewState> {
 public:
  using ConcreteViewShadowNode::ConcreteViewShadowNode;

  static ScrollViewState initialStateData(
      const Props::Shared& props,
      const ShadowNodeFamily::Shared& family,
      const ComponentDescriptor& componentDescriptor);

#pragma mark - LayoutableShadowNode

  void layout(LayoutContext layoutContext) override;
  Point getContentOriginOffset() const override;

 private:
  void updateStateIfNeeded();
  void updateScrollContentOffsetIfNeeded();
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
