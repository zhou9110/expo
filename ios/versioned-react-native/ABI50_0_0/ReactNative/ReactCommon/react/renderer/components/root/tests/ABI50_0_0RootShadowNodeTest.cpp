/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <ABI50_0_0React/renderer/components/root/ABI50_0_0RootComponentDescriptor.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>
#include <ABI50_0_0React/renderer/element/ABI50_0_0ComponentBuilder.h>

#include <gtest/gtest.h>
#include <ABI50_0_0React/renderer/element/ABI50_0_0Element.h>
#include <ABI50_0_0React/renderer/element/ABI50_0_0testUtils.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

TEST(RootShadowNodeTest, cloneWithLayoutConstraints) {
  ContextContainer contextContainer{};
  PropsParserContext parserContext{-1, contextContainer};

  auto builder = simpleComponentBuilder();
  std::shared_ptr<RootShadowNode> rootShadowNode;
  LayoutConstraints defaultLayoutConstraints = {};

  auto element =
      Element<RootShadowNode>().reference(rootShadowNode).tag(1).props([&] {
        auto sharedProps = std::make_shared<RootProps>();
        sharedProps->layoutConstraints = defaultLayoutConstraints;
        return sharedProps;
      });

  builder.build(element);

  ABI50_0_0EXPECT_FALSE(rootShadowNode->getIsLayoutClean());
  ABI50_0_0EXPECT_TRUE(rootShadowNode->layoutIfNeeded());
  ABI50_0_0EXPECT_TRUE(rootShadowNode->getIsLayoutClean());

  auto clonedWithDifferentLayoutConstraints = rootShadowNode->clone(
      parserContext, LayoutConstraints{{0, 0}, {10, 10}}, {});

  ABI50_0_0EXPECT_FALSE(clonedWithDifferentLayoutConstraints->getIsLayoutClean());
  ABI50_0_0EXPECT_TRUE(clonedWithDifferentLayoutConstraints->layoutIfNeeded());
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
