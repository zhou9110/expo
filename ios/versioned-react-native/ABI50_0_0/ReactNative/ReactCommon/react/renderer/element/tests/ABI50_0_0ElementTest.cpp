/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <memory>

#include <gtest/gtest.h>

#include <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorProviderRegistry.h>
#include <ABI50_0_0React/renderer/components/root/ABI50_0_0RootComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewComponentDescriptor.h>
#include <ABI50_0_0React/renderer/element/ABI50_0_0ComponentBuilder.h>
#include <ABI50_0_0React/renderer/element/ABI50_0_0Element.h>
#include <ABI50_0_0React/renderer/element/ABI50_0_0testUtils.h>

using namespace ABI50_0_0facebook::ABI50_0_0React;

TEST(ElementTest, testNormalCases) {
  auto builder = simpleComponentBuilder();

  auto shadowNodeA = std::shared_ptr<RootShadowNode>{};
  auto shadowNodeAA = std::shared_ptr<ViewShadowNode>{};
  auto shadowNodeAB = std::shared_ptr<ViewShadowNode>{};
  auto shadowNodeABA = std::shared_ptr<ViewShadowNode>{};

  auto propsAA = std::make_shared<ViewShadowNodeProps>();
  propsAA->nativeId = "node AA";

  // clang-format off
  auto element =
      Element<RootShadowNode>()
        .reference(shadowNodeA)
        .tag(1)
        .props([]() {
          auto props = std::make_shared<RootProps>();
          props->nativeId = "node A";
          return props;
        })
        .finalize([](RootShadowNode &shadowNode){
          shadowNode.sealRecursive();
        })
        .children({
          Element<ViewShadowNode>()
            .reference(shadowNodeAA)
            .tag(2)
            .props(propsAA),
          Element<ViewShadowNode>()
            .reference(shadowNodeAB)
            .tag(3)
            .props([]() {
               auto props = std::make_shared<ViewShadowNodeProps>();
               props->nativeId = "node AB";
               return props;
            })
            .children({
              Element<ViewShadowNode>()
                .reference(shadowNodeABA)
                .tag(4)
                .props([]() {
                  auto props = std::make_shared<ViewShadowNodeProps>();
                  props->nativeId = "node ABA";
                  return props;
                })
            })
        });
  // clang-format on

  auto shadowNode = builder.build(element);

  ABI50_0_0EXPECT_EQ(shadowNode, shadowNodeA);

  // Tags
  ABI50_0_0EXPECT_EQ(shadowNodeA->getTag(), 1);
  ABI50_0_0EXPECT_EQ(shadowNodeAA->getTag(), 2);
  ABI50_0_0EXPECT_EQ(shadowNodeAB->getTag(), 3);
  ABI50_0_0EXPECT_EQ(shadowNodeABA->getTag(), 4);

  // Children
  ABI50_0_0EXPECT_EQ(shadowNodeA->getChildren().size(), 2);
  ABI50_0_0EXPECT_EQ(shadowNodeAA->getChildren().size(), 0);
  ABI50_0_0EXPECT_EQ(shadowNodeAB->getChildren().size(), 1);
  ABI50_0_0EXPECT_EQ(shadowNodeABA->getChildren().size(), 0);
  ABI50_0_0EXPECT_EQ(
      shadowNodeA->getChildren(),
      (ShadowNode::ListOfShared{shadowNodeAA, shadowNodeAB}));
  ABI50_0_0EXPECT_EQ(
      shadowNodeAB->getChildren(), (ShadowNode::ListOfShared{shadowNodeABA}));

  // Props
  ABI50_0_0EXPECT_EQ(shadowNodeA->getProps()->nativeId, "node A");
  ABI50_0_0EXPECT_EQ(shadowNodeABA->getProps()->nativeId, "node ABA");
  ABI50_0_0EXPECT_EQ(shadowNodeAA->getProps(), propsAA);

  // Finalize
  ABI50_0_0EXPECT_TRUE(shadowNodeA->getSealed());
  ABI50_0_0EXPECT_TRUE(shadowNodeAA->getSealed());
  ABI50_0_0EXPECT_TRUE(shadowNodeAB->getSealed());
  ABI50_0_0EXPECT_TRUE(shadowNodeABA->getSealed());
}
