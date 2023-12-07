/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0ParagraphShadowNode.h"

#include <cmath>

#include <ABI50_0_0React/debug/ABI50_0_0React_native_assert.h>
#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0AttributedStringBox.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewShadowNode.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0conversions.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0TraitCast.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0rounding.h>
#include <ABI50_0_0React/renderer/telemetry/ABI50_0_0TransactionTelemetry.h>
#include <ABI50_0_0React/utils/ABI50_0_0CoreFeatures.h>

#include "ABI50_0_0ParagraphState.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

using Content = ParagraphShadowNode::Content;

const char ParagraphComponentName[] = "Paragraph";

ParagraphShadowNode::ParagraphShadowNode(
    const ShadowNode& sourceShadowNode,
    const ShadowNodeFragment& fragment)
    : ConcreteViewShadowNode(sourceShadowNode, fragment) {
  if (CoreFeatures::enableCleanParagraphYogaNode) {
    if (!fragment.children && !fragment.props) {
      // This ParagraphShadowNode was cloned but did not change
      // in a way that affects its layout. Let's mark it clean
      // to stop Yoga from traversing it.
      cleanLayout();
    }
  }
}

const Content& ParagraphShadowNode::getContent(
    const LayoutContext& layoutContext) const {
  if (content_.has_value()) {
    return content_.value();
  }

  ensureUnsealed();

  auto textAttributes = TextAttributes::defaultTextAttributes();
  textAttributes.fontSizeMultiplier = layoutContext.fontSizeMultiplier;
  textAttributes.apply(getConcreteProps().textAttributes);
  textAttributes.layoutDirection =
      ABI50_0_0YGNodeLayoutGetDirection(&yogaNode_) == ABI50_0_0YGDirectionRTL
      ? LayoutDirection::RightToLeft
      : LayoutDirection::LeftToRight;
  auto attributedString = AttributedString{};
  auto attachments = Attachments{};
  buildAttributedString(textAttributes, *this, attributedString, attachments);

  content_ = Content{
      attributedString, getConcreteProps().paragraphAttributes, attachments};

  return content_.value();
}

Content ParagraphShadowNode::getContentWithMeasuredAttachments(
    const LayoutContext& layoutContext,
    const LayoutConstraints& layoutConstraints) const {
  auto content = getContent(layoutContext);

  if (content.attachments.empty()) {
    // Base case: No attachments, nothing to do.
    return content;
  }

  auto localLayoutConstraints = layoutConstraints;
  // Having enforced minimum size for text fragments doesn't make much sense.
  localLayoutConstraints.minimumSize = Size{0, 0};

  auto& fragments = content.attributedString.getFragments();

  for (const auto& attachment : content.attachments) {
    auto laytableShadowNode =
        traitCast<const LayoutableShadowNode*>(attachment.shadowNode);

    if (laytableShadowNode == nullptr) {
      continue;
    }

    auto size =
        laytableShadowNode->measure(layoutContext, localLayoutConstraints);

    // Rounding to *next* value on the pixel grid.
    size.width += 0.01f;
    size.height += 0.01f;
    size = roundToPixel<&ceil>(size, layoutContext.pointScaleFactor);

    auto fragmentLayoutMetrics = LayoutMetrics{};
    fragmentLayoutMetrics.pointScaleFactor = layoutContext.pointScaleFactor;
    fragmentLayoutMetrics.frame.size = size;
    fragments[attachment.fragmentIndex].parentShadowView.layoutMetrics =
        fragmentLayoutMetrics;
  }

  return content;
}

void ParagraphShadowNode::setTextLayoutManager(
    std::shared_ptr<const TextLayoutManager> textLayoutManager) {
  ensureUnsealed();
  getStateData().paragraphLayoutManager.setTextLayoutManager(
      std::move(textLayoutManager));
}

void ParagraphShadowNode::updateStateIfNeeded(const Content& content) {
  ensureUnsealed();

  auto& state = getStateData();

  ABI50_0_0React_native_assert(state.paragraphLayoutManager.getTextLayoutManager());

  if (state.attributedString == content.attributedString) {
    return;
  }

  setStateData(ParagraphState{
      content.attributedString,
      content.paragraphAttributes,
      state.paragraphLayoutManager});
}

#pragma mark - LayoutableShadowNode

Size ParagraphShadowNode::measureContent(
    const LayoutContext& layoutContext,
    const LayoutConstraints& layoutConstraints) const {
  auto content =
      getContentWithMeasuredAttachments(layoutContext, layoutConstraints);

  auto attributedString = content.attributedString;
  if (attributedString.isEmpty()) {
    // Note: `zero-width space` is insufficient in some cases (e.g. when we need
    // to measure the "height" of the font).
    // TODO T67606511: We will redefine the measurement of empty strings as part
    // of T67606511
    auto string = BaseTextShadowNode::getEmptyPlaceholder();
    auto textAttributes = TextAttributes::defaultTextAttributes();
    textAttributes.fontSizeMultiplier = layoutContext.fontSizeMultiplier;
    textAttributes.apply(getConcreteProps().textAttributes);
    attributedString.appendFragment({string, textAttributes, {}});
  }

  return getStateData()
      .paragraphLayoutManager
      .measure(attributedString, content.paragraphAttributes, layoutConstraints)
      .size;
}

void ParagraphShadowNode::layout(LayoutContext layoutContext) {
  ensureUnsealed();

  auto layoutMetrics = getLayoutMetrics();
  auto availableSize = layoutMetrics.getContentFrame().size;

  auto layoutConstraints = LayoutConstraints{
      availableSize, availableSize, layoutMetrics.layoutDirection};
  auto content =
      getContentWithMeasuredAttachments(layoutContext, layoutConstraints);

  updateStateIfNeeded(content);

  auto measurement = getStateData().paragraphLayoutManager.measure(
      content.attributedString, content.paragraphAttributes, layoutConstraints);

  if (getConcreteProps().onTextLayout) {
    auto linesMeasurements = getStateData().paragraphLayoutManager.measureLines(
        content.attributedString,
        content.paragraphAttributes,
        measurement.size);
    getConcreteEventEmitter().onTextLayout(linesMeasurements);
  }

  if (content.attachments.empty()) {
    // No attachments to layout.
    return;
  }

  //  Iterating on attachments, we clone shadow nodes and moving
  //  `paragraphShadowNode` that represents clones of `this` object.
  auto paragraphShadowNode = static_cast<ParagraphShadowNode*>(this);
  // `paragraphOwningShadowNode` is owning pointer to`paragraphShadowNode`
  // (besides the initial case when `paragraphShadowNode == this`), we need this
  // only to keep it in memory for a while.
  auto paragraphOwningShadowNode = ShadowNode::Unshared{};

  ABI50_0_0React_native_assert(
      content.attachments.size() == measurement.attachments.size());

  for (size_t i = 0; i < content.attachments.size(); i++) {
    auto& attachment = content.attachments.at(i);

    if (traitCast<const LayoutableShadowNode*>(attachment.shadowNode) ==
        nullptr) {
      // Not a layoutable `ShadowNode`, no need to lay it out.
      continue;
    }

    auto clonedShadowNode = ShadowNode::Unshared{};

    paragraphOwningShadowNode = paragraphShadowNode->cloneTree(
        attachment.shadowNode->getFamily(),
        [&](const ShadowNode& oldShadowNode) {
          clonedShadowNode = oldShadowNode.clone({});
          return clonedShadowNode;
        });
    paragraphShadowNode =
        static_cast<ParagraphShadowNode*>(paragraphOwningShadowNode.get());

    auto& layoutableShadowNode =
        traitCast<LayoutableShadowNode&>(*clonedShadowNode);

    auto attachmentFrame = measurement.attachments[i].frame;
    auto attachmentSize = roundToPixel<&ceil>(
        attachmentFrame.size, layoutMetrics.pointScaleFactor);
    auto attachmentOrigin = roundToPixel<&round>(
        attachmentFrame.origin, layoutMetrics.pointScaleFactor);
    auto attachmentLayoutContext = layoutContext;
    auto attachmentLayoutConstrains = LayoutConstraints{
        attachmentSize, attachmentSize, layoutConstraints.layoutDirection};

    // Laying out the `ShadowNode` and the subtree starting from it.
    layoutableShadowNode.layoutTree(
        attachmentLayoutContext, attachmentLayoutConstrains);

    // Altering the origin of the `ShadowNode` (which is defined by text layout,
    // not by internal styles and state).
    auto attachmentLayoutMetrics = layoutableShadowNode.getLayoutMetrics();
    attachmentLayoutMetrics.frame.origin = attachmentOrigin;
    layoutableShadowNode.setLayoutMetrics(attachmentLayoutMetrics);
  }

  // If we ended up cloning something, we need to update the list of children to
  // reflect the changes that we made.
  if (paragraphShadowNode != this) {
    this->children_ =
        static_cast<const ParagraphShadowNode*>(paragraphShadowNode)->children_;
  }
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
