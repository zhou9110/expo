/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <gtest/gtest.h>

#include <ABI50_0_0React/renderer/components/scrollview/ABI50_0_0ScrollViewComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0ParagraphComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0RawTextComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0TextComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewComponentDescriptor.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0TraitCast.h>

#include <ABI50_0_0React/renderer/element/ABI50_0_0Element.h>
#include <ABI50_0_0React/renderer/element/ABI50_0_0testUtils.h>

using namespace ABI50_0_0facebook::ABI50_0_0React;

TEST(traitCastTest, testOne) {
  auto builder = simpleComponentBuilder();

  auto viewShadowNode = std::shared_ptr<ViewShadowNode>{};
  auto scrollViewShadowNode = std::shared_ptr<ScrollViewShadowNode>{};
  auto paragraphShadowNode = std::shared_ptr<ParagraphShadowNode>{};
  auto textShadowNode = std::shared_ptr<TextShadowNode>{};
  auto rawTextShadowNode = std::shared_ptr<RawTextShadowNode>{};

  // clang-format off
  auto element =
      Element<ScrollViewShadowNode>()
        .reference(scrollViewShadowNode)
        .children({
          Element<ParagraphShadowNode>()
            .reference(paragraphShadowNode)
            .children({
              Element<TextShadowNode>()
                .reference(textShadowNode),
              Element<RawTextShadowNode>()
                .reference(rawTextShadowNode)
            }),
          Element<ViewShadowNode>()
            .reference(viewShadowNode),
        });
  // clang-format on

  auto rootShadowNode = builder.build(element);

  std::shared_ptr<ShadowNode> shadowNodeForRawTextShadowNode{rawTextShadowNode};
  std::shared_ptr<ShadowNode> shadowNodeForTextShadowNode{textShadowNode};

  // Casting `nullptr` returns `nullptrs`.
  ShadowNode* nullShadowNode = nullptr;
  ABI50_0_0EXPECT_FALSE(traitCast<const LayoutableShadowNode*>(nullShadowNode));
  ABI50_0_0EXPECT_FALSE(traitCast<const YogaLayoutableShadowNode*>(nullShadowNode));
  ABI50_0_0EXPECT_FALSE(traitCast<const LayoutableShadowNode*>(nullShadowNode));
  ABI50_0_0EXPECT_FALSE(traitCast<LayoutableShadowNode*>(nullShadowNode));
  ABI50_0_0EXPECT_FALSE(traitCast<LayoutableShadowNode>(
      std::shared_ptr<ShadowNode>(nullShadowNode)));

  // `ViewShadowNode` is `LayoutableShadowNode` and `YogaLayoutableShadowNode`.
  ABI50_0_0EXPECT_TRUE(traitCast<const LayoutableShadowNode*>(viewShadowNode.get()));
  ABI50_0_0EXPECT_TRUE(traitCast<const YogaLayoutableShadowNode*>(viewShadowNode.get()));
  ABI50_0_0EXPECT_NO_FATAL_FAILURE(
      traitCast<const LayoutableShadowNode&>(*viewShadowNode));
  ABI50_0_0EXPECT_NO_FATAL_FAILURE(
      traitCast<const YogaLayoutableShadowNode&>(*viewShadowNode));
  ABI50_0_0EXPECT_NO_FATAL_FAILURE(
      traitCast<YogaLayoutableShadowNode&>(*viewShadowNode));
  ABI50_0_0EXPECT_TRUE(traitCast<LayoutableShadowNode*>(viewShadowNode.get()));
  ABI50_0_0EXPECT_TRUE(traitCast<LayoutableShadowNode>(viewShadowNode));

  // `ScrollViewShadowNode` is `LayoutableShadowNode` and
  // `YogaLayoutableShadowNode`.
  ABI50_0_0EXPECT_TRUE(
      traitCast<const LayoutableShadowNode*>(scrollViewShadowNode.get()));
  ABI50_0_0EXPECT_TRUE(
      traitCast<const YogaLayoutableShadowNode*>(scrollViewShadowNode.get()));
  ABI50_0_0EXPECT_NO_FATAL_FAILURE(
      traitCast<const LayoutableShadowNode&>(*scrollViewShadowNode));
  ABI50_0_0EXPECT_NO_FATAL_FAILURE(
      traitCast<const YogaLayoutableShadowNode&>(*scrollViewShadowNode));

  // `ParagraphShadowNode` is `LayoutableShadowNode` and
  // `YogaLayoutableShadowNode`.
  ABI50_0_0EXPECT_TRUE(
      traitCast<const LayoutableShadowNode*>(paragraphShadowNode.get()));
  ABI50_0_0EXPECT_TRUE(
      traitCast<const YogaLayoutableShadowNode*>(paragraphShadowNode.get()));
  ABI50_0_0EXPECT_NO_FATAL_FAILURE(
      traitCast<const LayoutableShadowNode&>(*paragraphShadowNode));
  ABI50_0_0EXPECT_NO_FATAL_FAILURE(
      traitCast<const YogaLayoutableShadowNode&>(*paragraphShadowNode));

  // `TextShadowNode` is *not* `LayoutableShadowNode` nor
  // `YogaLayoutableShadowNode`.
  ABI50_0_0EXPECT_FALSE(traitCast<const LayoutableShadowNode*>(textShadowNode.get()));
  ABI50_0_0EXPECT_FALSE(
      traitCast<const YogaLayoutableShadowNode*>(textShadowNode.get()));
  ABI50_0_0EXPECT_DEATH_IF_SUPPORTED(
      traitCast<const LayoutableShadowNode&>(*textShadowNode), "");
  ABI50_0_0EXPECT_DEATH_IF_SUPPORTED(
      traitCast<const YogaLayoutableShadowNode&>(*textShadowNode), "");

  // `RawTextShadowNode` is *not* `LayoutableShadowNode` nor
  // `YogaLayoutableShadowNode`.
  ABI50_0_0EXPECT_FALSE(traitCast<const LayoutableShadowNode*>(rawTextShadowNode.get()));
  ABI50_0_0EXPECT_FALSE(
      traitCast<const YogaLayoutableShadowNode*>(rawTextShadowNode.get()));
  ABI50_0_0EXPECT_DEATH_IF_SUPPORTED(
      traitCast<const LayoutableShadowNode&>(*rawTextShadowNode), "");
  ABI50_0_0EXPECT_DEATH_IF_SUPPORTED(
      traitCast<const YogaLayoutableShadowNode&>(*rawTextShadowNode), "");

  // trait cast to `RawTextShadowNode` works on `RawTextShadowNode`
  // and not on TextShadowNode or ViewShadowNode
  ABI50_0_0EXPECT_TRUE(traitCast<const RawTextShadowNode*>(
      shadowNodeForRawTextShadowNode.get()));
  ABI50_0_0EXPECT_NO_FATAL_FAILURE(
      traitCast<const RawTextShadowNode&>(*shadowNodeForRawTextShadowNode));
  ABI50_0_0EXPECT_FALSE(
      traitCast<const RawTextShadowNode*>(shadowNodeForTextShadowNode.get()));
  ABI50_0_0EXPECT_DEATH_IF_SUPPORTED(
      traitCast<const RawTextShadowNode&>(*shadowNodeForTextShadowNode), "");
  ABI50_0_0EXPECT_FALSE(traitCast<const RawTextShadowNode*>(viewShadowNode.get()));
  ABI50_0_0EXPECT_DEATH_IF_SUPPORTED(
      traitCast<const RawTextShadowNode&>(*viewShadowNode), "");

  // trait cast to `TextShadowNode` works on `TextShadowNode`
  // and not on RawTextShadowNode or ViewShadowNode
  ABI50_0_0EXPECT_TRUE(
      traitCast<const TextShadowNode*>(shadowNodeForTextShadowNode.get()));
  ABI50_0_0EXPECT_NO_FATAL_FAILURE(
      traitCast<const TextShadowNode&>(*shadowNodeForTextShadowNode));
  ABI50_0_0EXPECT_FALSE(
      traitCast<const TextShadowNode*>(shadowNodeForRawTextShadowNode.get()));
  ABI50_0_0EXPECT_DEATH_IF_SUPPORTED(
      traitCast<const TextShadowNode&>(*shadowNodeForRawTextShadowNode), "");
  ABI50_0_0EXPECT_FALSE(traitCast<const TextShadowNode*>(viewShadowNode.get()));
  ABI50_0_0EXPECT_DEATH_IF_SUPPORTED(
      traitCast<const TextShadowNode&>(*viewShadowNode), "");
}
