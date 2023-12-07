/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0BaseTextShadowNode.h"

#include <ABI50_0_0React/renderer/components/text/ABI50_0_0RawTextProps.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0RawTextShadowNode.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0TextProps.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0TextShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0TraitCast.h>
#include <ABI50_0_0React/renderer/mounting/ABI50_0_0ShadowView.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

inline ShadowView shadowViewFromShadowNode(const ShadowNode& shadowNode) {
  auto shadowView = ShadowView{shadowNode};
  // Clearing `props` and `state` (which we don't use) allows avoiding retain
  // cycles.
  shadowView.props = nullptr;
  shadowView.state = nullptr;
  return shadowView;
}

void BaseTextShadowNode::buildAttributedString(
    const TextAttributes& baseTextAttributes,
    const ShadowNode& parentNode,
    AttributedString& outAttributedString,
    Attachments& outAttachments) {
  for (const auto& childNode : parentNode.getChildren()) {
    // RawShadowNode
    auto rawTextShadowNode =
        traitCast<const RawTextShadowNode*>(childNode.get());
    if (rawTextShadowNode != nullptr) {
      auto fragment = AttributedString::Fragment{};
      fragment.string = rawTextShadowNode->getConcreteProps().text;
      fragment.textAttributes = baseTextAttributes;

      // Storing a retaining pointer to `ParagraphShadowNode` inside
      // `attributedString` causes a retain cycle (besides that fact that we
      // don't need it at all). Storing a `ShadowView` instance instead of
      // `ShadowNode` should properly fix this problem.
      fragment.parentShadowView = shadowViewFromShadowNode(parentNode);
      outAttributedString.appendFragment(fragment);
      continue;
    }

    // TextShadowNode
    auto textShadowNode = traitCast<const TextShadowNode*>(childNode.get());
    if (textShadowNode != nullptr) {
      auto localTextAttributes = baseTextAttributes;
      localTextAttributes.apply(
          textShadowNode->getConcreteProps().textAttributes);
      buildAttributedString(
          localTextAttributes,
          *textShadowNode,
          outAttributedString,
          outAttachments);
      continue;
    }

    // Any *other* kind of ShadowNode
    auto fragment = AttributedString::Fragment{};
    fragment.string = AttributedString::Fragment::AttachmentCharacter();
    fragment.parentShadowView = shadowViewFromShadowNode(*childNode);
    fragment.textAttributes = baseTextAttributes;
    outAttributedString.appendFragment(fragment);
    outAttachments.push_back(Attachment{
        childNode.get(), outAttributedString.getFragments().size() - 1});
  }
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
