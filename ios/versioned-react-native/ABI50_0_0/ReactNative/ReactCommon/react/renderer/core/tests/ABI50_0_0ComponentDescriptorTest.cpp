/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <gtest/gtest.h>

#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>

#include "ABI50_0_0TestComponent.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

TEST(ComponentDescriptorTest, createShadowNode) {
  auto eventDispatcher = std::shared_ptr<const EventDispatcher>();
  SharedComponentDescriptor descriptor =
      std::make_shared<TestComponentDescriptor>(
          ComponentDescriptorParameters{eventDispatcher, nullptr, nullptr});

  ABI50_0_0EXPECT_EQ(descriptor->getComponentHandle(), TestShadowNode::Handle());
  ABI50_0_0EXPECT_STREQ(descriptor->getComponentName(), TestShadowNode::Name());
  ABI50_0_0EXPECT_STREQ(descriptor->getComponentName(), "Test");

  ContextContainer contextContainer{};
  PropsParserContext parserContext{-1, contextContainer};

  const auto& raw = RawProps(folly::dynamic::object("nativeID", "abc"));
  Props::Shared props = descriptor->cloneProps(parserContext, nullptr, raw);

  auto family = descriptor->createFamily(ShadowNodeFamilyFragment{
      /* .tag = */ 9,
      /* .surfaceId = */ 1,
      /* .instanceHandle = */ nullptr,
  });

  ShadowNode::Shared node = descriptor->createShadowNode(
      ShadowNodeFragment{
          /* .props = */ props,
      },
      family);

  ABI50_0_0EXPECT_EQ(node->getComponentHandle(), TestShadowNode::Handle());
  ABI50_0_0EXPECT_STREQ(node->getComponentName(), TestShadowNode::Name());
  ABI50_0_0EXPECT_STREQ(node->getComponentName(), "Test");
  ABI50_0_0EXPECT_EQ(node->getTag(), 9);
  ABI50_0_0EXPECT_EQ(node->getSurfaceId(), 1);
  ABI50_0_0EXPECT_STREQ(node->getProps()->nativeId.c_str(), "abc");
}

TEST(ComponentDescriptorTest, cloneShadowNode) {
  auto eventDispatcher = std::shared_ptr<const EventDispatcher>();
  SharedComponentDescriptor descriptor =
      std::make_shared<TestComponentDescriptor>(
          ComponentDescriptorParameters{eventDispatcher, nullptr, nullptr});

  ContextContainer contextContainer{};
  PropsParserContext parserContext{-1, contextContainer};

  const auto& raw = RawProps(folly::dynamic::object("nativeID", "abc"));
  Props::Shared props = descriptor->cloneProps(parserContext, nullptr, raw);
  auto family = descriptor->createFamily(ShadowNodeFamilyFragment{
      /* .tag = */ 9,
      /* .surfaceId = */ 1,
      /* .instanceHandle = */ nullptr,
  });
  ShadowNode::Shared node = descriptor->createShadowNode(
      ShadowNodeFragment{
          /* .props = */ props,
      },
      family);
  ShadowNode::Shared cloned = descriptor->cloneShadowNode(*node, {});

  ABI50_0_0EXPECT_STREQ(cloned->getComponentName(), "Test");
  ABI50_0_0EXPECT_EQ(cloned->getTag(), 9);
  ABI50_0_0EXPECT_EQ(cloned->getSurfaceId(), 1);
  ABI50_0_0EXPECT_STREQ(cloned->getProps()->nativeId.c_str(), "abc");

  auto clonedButSameProps =
      descriptor->cloneProps(parserContext, props, RawProps());
  ABI50_0_0EXPECT_NE(clonedButSameProps, props);
}

TEST(ComponentDescriptorTest, appendChild) {
  auto eventDispatcher = std::shared_ptr<const EventDispatcher>();
  SharedComponentDescriptor descriptor =
      std::make_shared<TestComponentDescriptor>(
          ComponentDescriptorParameters{eventDispatcher, nullptr, nullptr});

  ContextContainer contextContainer{};
  PropsParserContext parserContext{-1, contextContainer};

  const auto& raw = RawProps(folly::dynamic::object("nativeID", "abc"));
  Props::Shared props = descriptor->cloneProps(parserContext, nullptr, raw);
  auto family1 = descriptor->createFamily(ShadowNodeFamilyFragment{
      /* .tag = */ 1,
      /* .surfaceId = */ 1,
      /* .instanceHandle = */ nullptr,
  });
  ShadowNode::Shared node1 = descriptor->createShadowNode(
      ShadowNodeFragment{
          /* .props = */ props,
      },
      family1);
  auto family2 = descriptor->createFamily(ShadowNodeFamilyFragment{
      /* .tag = */ 2,
      /* .surfaceId = */ 1,
      /* .instanceHandle = */ nullptr,
  });
  ShadowNode::Shared node2 = descriptor->createShadowNode(
      ShadowNodeFragment{
          /* .props = */ props,
      },
      family2);
  auto family3 = descriptor->createFamily(ShadowNodeFamilyFragment{
      /* .tag = */ 3,
      /* .surfaceId = */ 1,
      /* .instanceHandle = */ nullptr,
  });
  ShadowNode::Shared node3 = descriptor->createShadowNode(
      ShadowNodeFragment{
          /* .props = */ props,
      },
      family3);

  descriptor->appendChild(node1, node2);
  descriptor->appendChild(node1, node3);

  auto node1Children = node1->getChildren();
  ABI50_0_0EXPECT_EQ(node1Children.size(), 2);
  ABI50_0_0EXPECT_EQ(node1Children.at(0), node2);
  ABI50_0_0EXPECT_EQ(node1Children.at(1), node3);
}
