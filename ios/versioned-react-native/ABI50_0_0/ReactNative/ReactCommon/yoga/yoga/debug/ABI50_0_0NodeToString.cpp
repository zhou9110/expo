/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#ifdef DEBUG

#include <stdarg.h>

#include <ABI50_0_0yoga/ABI50_0_0YGEnums.h>

#include <ABI50_0_0yoga/debug/ABI50_0_0Log.h>
#include <ABI50_0_0yoga/debug/ABI50_0_0NodeToString.h>
#include <ABI50_0_0yoga/numeric/ABI50_0_0Comparison.h>

namespace ABI50_0_0facebook::yoga {

static void indent(std::string& base, uint32_t level) {
  for (uint32_t i = 0; i < level; ++i) {
    base.append("  ");
  }
}

static bool areFourValuesEqual(const Style::Edges& four) {
  return yoga::inexactEquals(four[0], four[1]) &&
      yoga::inexactEquals(four[0], four[2]) &&
      yoga::inexactEquals(four[0], four[3]);
}

static void appendFormattedString(std::string& str, const char* fmt, ...) {
  va_list args;
  va_start(args, fmt);
  va_list argsCopy;
  va_copy(argsCopy, args);
  std::vector<char> buf(1 + static_cast<size_t>(vsnprintf(NULL, 0, fmt, args)));
  va_end(args);
  vsnprintf(buf.data(), buf.size(), fmt, argsCopy);
  va_end(argsCopy);
  std::string result = std::string(buf.begin(), buf.end() - 1);
  str.append(result);
}

static void appendFloatOptionalIfDefined(
    std::string& base,
    const std::string key,
    const FloatOptional num) {
  if (!num.isUndefined()) {
    appendFormattedString(base, "%s: %g; ", key.c_str(), num.unwrap());
  }
}

static void appendNumberIfNotUndefined(
    std::string& base,
    const std::string key,
    const ABI50_0_0YGValue number) {
  if (number.unit != ABI50_0_0YGUnitUndefined) {
    if (number.unit == ABI50_0_0YGUnitAuto) {
      base.append(key + ": auto; ");
    } else {
      std::string unit = number.unit == ABI50_0_0YGUnitPoint ? "px" : "%%";
      appendFormattedString(
          base, "%s: %g%s; ", key.c_str(), number.value, unit.c_str());
    }
  }
}

static void appendNumberIfNotAuto(
    std::string& base,
    const std::string& key,
    const ABI50_0_0YGValue number) {
  if (number.unit != ABI50_0_0YGUnitAuto) {
    appendNumberIfNotUndefined(base, key, number);
  }
}

static void appendNumberIfNotZero(
    std::string& base,
    const std::string& str,
    const ABI50_0_0YGValue number) {
  if (number.unit == ABI50_0_0YGUnitAuto) {
    base.append(str + ": auto; ");
  } else if (!yoga::inexactEquals(number.value, 0)) {
    appendNumberIfNotUndefined(base, str, number);
  }
}

static void appendEdges(
    std::string& base,
    const std::string& key,
    const Style::Edges& edges) {
  if (areFourValuesEqual(edges)) {
    auto edgeValue = yoga::Node::computeEdgeValueForColumn(
        edges, ABI50_0_0YGEdgeLeft, CompactValue::ofZero());
    appendNumberIfNotZero(base, key, edgeValue);
  } else {
    for (int edge = ABI50_0_0YGEdgeLeft; edge != ABI50_0_0YGEdgeAll; ++edge) {
      std::string str = key + "-" + ABI50_0_0YGEdgeToString(static_cast<ABI50_0_0YGEdge>(edge));
      appendNumberIfNotZero(base, str, edges[static_cast<size_t>(edge)]);
    }
  }
}

static void appendEdgeIfNotUndefined(
    std::string& base,
    const std::string& str,
    const Style::Edges& edges,
    const ABI50_0_0YGEdge edge) {
  // TODO: this doesn't take RTL / ABI50_0_0YGEdgeStart / ABI50_0_0YGEdgeEnd into account
  auto value = (edge == ABI50_0_0YGEdgeLeft || edge == ABI50_0_0YGEdgeRight)
      ? yoga::Node::computeEdgeValueForRow(
            edges, edge, edge, CompactValue::ofUndefined())
      : yoga::Node::computeEdgeValueForColumn(
            edges, edge, CompactValue::ofUndefined());
  appendNumberIfNotUndefined(base, str, value);
}

void nodeToString(
    std::string& str,
    const yoga::Node* node,
    PrintOptions options,
    uint32_t level) {
  indent(str, level);
  appendFormattedString(str, "<div ");

  if ((options & PrintOptions::Layout) == PrintOptions::Layout) {
    appendFormattedString(str, "layout=\"");
    appendFormattedString(
        str, "width: %g; ", node->getLayout().dimension(ABI50_0_0YGDimensionWidth));
    appendFormattedString(
        str, "height: %g; ", node->getLayout().dimension(ABI50_0_0YGDimensionHeight));
    appendFormattedString(
        str, "top: %g; ", node->getLayout().position[ABI50_0_0YGEdgeTop]);
    appendFormattedString(
        str, "left: %g;", node->getLayout().position[ABI50_0_0YGEdgeLeft]);
    appendFormattedString(str, "\" ");
  }

  if ((options & PrintOptions::Style) == PrintOptions::Style) {
    appendFormattedString(str, "style=\"");
    const auto& style = node->getStyle();
    if (style.flexDirection() != yoga::Node{}.getStyle().flexDirection()) {
      appendFormattedString(
          str, "flex-direction: %s; ", toString(style.flexDirection()));
    }
    if (style.justifyContent() != yoga::Node{}.getStyle().justifyContent()) {
      appendFormattedString(
          str, "justify-content: %s; ", toString(style.justifyContent()));
    }
    if (style.alignItems() != yoga::Node{}.getStyle().alignItems()) {
      appendFormattedString(
          str, "align-items: %s; ", toString(style.alignItems()));
    }
    if (style.alignContent() != yoga::Node{}.getStyle().alignContent()) {
      appendFormattedString(
          str, "align-content: %s; ", toString(style.alignContent()));
    }
    if (style.alignSelf() != yoga::Node{}.getStyle().alignSelf()) {
      appendFormattedString(
          str, "align-self: %s; ", toString(style.alignSelf()));
    }
    appendFloatOptionalIfDefined(str, "flex-grow", style.flexGrow());
    appendFloatOptionalIfDefined(str, "flex-shrink", style.flexShrink());
    appendNumberIfNotAuto(str, "flex-basis", style.flexBasis());
    appendFloatOptionalIfDefined(str, "flex", style.flex());

    if (style.flexWrap() != yoga::Node{}.getStyle().flexWrap()) {
      appendFormattedString(str, "flex-wrap: %s; ", toString(style.flexWrap()));
    }

    if (style.overflow() != yoga::Node{}.getStyle().overflow()) {
      appendFormattedString(str, "overflow: %s; ", toString(style.overflow()));
    }

    if (style.display() != yoga::Node{}.getStyle().display()) {
      appendFormattedString(str, "display: %s; ", toString(style.display()));
    }
    appendEdges(str, "margin", style.margin());
    appendEdges(str, "padding", style.padding());
    appendEdges(str, "border", style.border());

    if (yoga::Node::computeColumnGap(
            style.gap(), CompactValue::ofUndefined()) !=
        yoga::Node::computeColumnGap(
            yoga::Node{}.getStyle().gap(), CompactValue::ofUndefined())) {
      appendNumberIfNotUndefined(
          str, "column-gap", style.gap()[ABI50_0_0YGGutterColumn]);
    }
    if (yoga::Node::computeRowGap(style.gap(), CompactValue::ofUndefined()) !=
        yoga::Node::computeRowGap(
            yoga::Node{}.getStyle().gap(), CompactValue::ofUndefined())) {
      appendNumberIfNotUndefined(str, "row-gap", style.gap()[ABI50_0_0YGGutterRow]);
    }

    appendNumberIfNotAuto(str, "width", style.dimension(ABI50_0_0YGDimensionWidth));
    appendNumberIfNotAuto(str, "height", style.dimension(ABI50_0_0YGDimensionHeight));
    appendNumberIfNotAuto(
        str, "max-width", style.maxDimension(ABI50_0_0YGDimensionWidth));
    appendNumberIfNotAuto(
        str, "max-height", style.maxDimension(ABI50_0_0YGDimensionHeight));
    appendNumberIfNotAuto(
        str, "min-width", style.minDimension(ABI50_0_0YGDimensionWidth));
    appendNumberIfNotAuto(
        str, "min-height", style.minDimension(ABI50_0_0YGDimensionHeight));

    if (style.positionType() != yoga::Node{}.getStyle().positionType()) {
      appendFormattedString(
          str, "position: %s; ", toString(style.positionType()));
    }

    appendEdgeIfNotUndefined(str, "left", style.position(), ABI50_0_0YGEdgeLeft);
    appendEdgeIfNotUndefined(str, "right", style.position(), ABI50_0_0YGEdgeRight);
    appendEdgeIfNotUndefined(str, "top", style.position(), ABI50_0_0YGEdgeTop);
    appendEdgeIfNotUndefined(str, "bottom", style.position(), ABI50_0_0YGEdgeBottom);
    appendFormattedString(str, "\" ");

    if (node->hasMeasureFunc()) {
      appendFormattedString(str, "has-custom-measure=\"true\"");
    }
  }
  appendFormattedString(str, ">");

  const size_t childCount = node->getChildCount();
  if ((options & PrintOptions::Children) == PrintOptions::Children &&
      childCount > 0) {
    for (size_t i = 0; i < childCount; i++) {
      appendFormattedString(str, "\n");
      nodeToString(str, node->getChild(i), options, level + 1);
    }
    appendFormattedString(str, "\n");
    indent(str, level);
  }
  appendFormattedString(str, "</div>");
}

void print(const yoga::Node* node, PrintOptions options) {
  std::string str;
  yoga::nodeToString(str, node, options, 0);
  yoga::log(node, LogLevel::Debug, str.c_str());
}

} // namespace ABI50_0_0facebook::yoga
#endif
