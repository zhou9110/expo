/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <ABI50_0_0yoga/ABI50_0_0Yoga.h>

#include <ABI50_0_0yoga/algorithm/ABI50_0_0Align.h>
#include <ABI50_0_0yoga/algorithm/ABI50_0_0Baseline.h>
#include <ABI50_0_0yoga/debug/ABI50_0_0AssertFatal.h>
#include <ABI50_0_0yoga/event/ABI50_0_0event.h>

namespace ABI50_0_0facebook::yoga {

float calculateBaseline(const yoga::Node* node) {
  if (node->hasBaselineFunc()) {
    Event::publish<Event::NodeBaselineStart>(node);

    const float baseline = node->baseline(
        node->getLayout().measuredDimension(ABI50_0_0YGDimensionWidth),
        node->getLayout().measuredDimension(ABI50_0_0YGDimensionHeight));

    Event::publish<Event::NodeBaselineEnd>(node);

    yoga::assertFatalWithNode(
        node,
        !std::isnan(baseline),
        "Expect custom baseline function to not return NaN");
    return baseline;
  }

  yoga::Node* baselineChild = nullptr;
  const size_t childCount = node->getChildCount();
  for (size_t i = 0; i < childCount; i++) {
    auto child = node->getChild(i);
    if (child->getLineIndex() > 0) {
      break;
    }
    if (child->getStyle().positionType() == PositionType::Absolute) {
      continue;
    }
    if (resolveChildAlignment(node, child) == Align::Baseline ||
        child->isReferenceBaseline()) {
      baselineChild = child;
      break;
    }

    if (baselineChild == nullptr) {
      baselineChild = child;
    }
  }

  if (baselineChild == nullptr) {
    return node->getLayout().measuredDimension(ABI50_0_0YGDimensionHeight);
  }

  const float baseline = calculateBaseline(baselineChild);
  return baseline + baselineChild->getLayout().position[ABI50_0_0YGEdgeTop];
}

bool isBaselineLayout(const yoga::Node* node) {
  if (isColumn(node->getStyle().flexDirection())) {
    return false;
  }
  if (node->getStyle().alignItems() == Align::Baseline) {
    return true;
  }
  const auto childCount = node->getChildCount();
  for (size_t i = 0; i < childCount; i++) {
    auto child = node->getChild(i);
    if (child->getStyle().positionType() != PositionType::Absolute &&
        child->getStyle().alignSelf() == Align::Baseline) {
      return true;
    }
  }

  return false;
}

} // namespace ABI50_0_0facebook::yoga
