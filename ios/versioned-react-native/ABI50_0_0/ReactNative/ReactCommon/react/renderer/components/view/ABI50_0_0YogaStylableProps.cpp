/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0YogaStylableProps.h"

#include <ABI50_0_0React/renderer/components/view/ABI50_0_0conversions.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0propsConversions.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0propsConversions.h>
#include <ABI50_0_0React/renderer/debug/ABI50_0_0debugStringConvertibleUtils.h>
#include <ABI50_0_0React/utils/ABI50_0_0CoreFeatures.h>
#include <ABI50_0_0yoga/ABI50_0_0Yoga.h>
#include <unordered_set>

#include "ABI50_0_0conversions.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

namespace {
inline RawProps filterYogaProps(const RawProps& rawProps) {
  const static std::unordered_set<std::string> yogaStylePropNames = {
      {"direction",
       "flexDirection",
       "justifyContent",
       "alignContent",
       "alignItems",
       "alignSelf",
       "position",
       "flexWrap",
       "display",
       "flex",
       "flexGrow",
       "flexShrink",
       "flexBasis",
       "margin",
       "padding",
       "rowGap",
       "columnGap",
       "gap",
       // TODO: T163711275 also filter out width/height when SVG no longer read
       // them from RawProps
       "minWidth",
       "maxWidth",
       "minHeight",
       "maxHeight",
       "aspectRatio",

       // edges
       "left",
       "right",
       "top",
       "bottom",
       "start",
       "end",

       // variants of inset
       "inset",
       "insetStart",
       "insetEnd",
       "insetInline",
       "insetInlineStart",
       "insetInlineEnd",
       "insetBlock",
       "insetBlockEnd",
       "insetBlockStart",
       "insetVertical",
       "insetHorizontal",
       "insetTop",
       "insetBottom",
       "insetLeft",
       "insetRight",

       // variants of margin
       "marginStart",
       "marginEnd",
       "marginInline",
       "marginInlineStart",
       "marginInlineEnd",
       "marginBlock",
       "marginBlockStart",
       "marginBlockEnd",
       "marginVertical",
       "marginHorizontal",
       "marginTop",
       "marginBottom",
       "marginLeft",
       "marginRight",

       // variants of padding
       "paddingStart",
       "paddingEnd",
       "paddingInline",
       "paddingInlineStart",
       "paddingInlineEnd",
       "paddingBlock",
       "paddingBlockStart",
       "paddingBlockEnd",
       "paddingVertical",
       "paddingHorizontal",
       "paddingTop",
       "paddingBottom",
       "paddingLeft",
       "paddingRight"}};

  auto filteredRawProps = (folly::dynamic)rawProps;

  auto it = filteredRawProps.items().begin();
  while (it != filteredRawProps.items().end()) {
    auto key = it->first.asString();
    if (yogaStylePropNames.find(key) != yogaStylePropNames.end()) {
      it = filteredRawProps.erase(it);
    } else {
      ++it;
    }
  }

  return RawProps(std::move(filteredRawProps));
}
} // namespace

YogaStylableProps::YogaStylableProps(
    const PropsParserContext& context,
    const YogaStylableProps& sourceProps,
    const RawProps& rawProps)
    : Props() {
  if (CoreFeatures::excludeYogaFromRawProps) {
    const auto filteredRawProps = filterYogaProps(rawProps);
    initialize(context, sourceProps, filteredRawProps);

    yogaStyle = CoreFeatures::enablePropIteratorSetter
        ? sourceProps.yogaStyle
        : convertRawProp(context, filteredRawProps, sourceProps.yogaStyle);

    if (!CoreFeatures::enablePropIteratorSetter) {
      convertRawPropAliases(context, sourceProps, filteredRawProps);
    }
  } else {
    initialize(context, sourceProps, rawProps);

    yogaStyle = CoreFeatures::enablePropIteratorSetter
        ? sourceProps.yogaStyle
        : convertRawProp(context, rawProps, sourceProps.yogaStyle);

    if (!CoreFeatures::enablePropIteratorSetter) {
      convertRawPropAliases(context, sourceProps, rawProps);
    }
  }
};

template <typename T>
static inline T const getFieldValue(
    const PropsParserContext& context,
    const RawValue& value,
    T const defaultValue) {
  if (value.hasValue()) {
    T res;
    fromRawValue(context, value, res);
    return res;
  }

  return defaultValue;
}

#define REBUILD_FIELD_SWITCH_CASE2(field, fieldName)                       \
  case CONSTEXPR_RAW_PROPS_KEY_HASH(fieldName): {                          \
    yogaStyle.field() = getFieldValue(context, value, ygDefaults.field()); \
    return;                                                                \
  }

// @lint-ignore CLANGTIDY cppcoreguidelines-macro-usage
#define REBUILD_FIELD_SWITCH_CASE_YSP(field) \
  REBUILD_FIELD_SWITCH_CASE2(field, #field)

#define REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(field, index, fieldName) \
  case CONSTEXPR_RAW_PROPS_KEY_HASH(fieldName): {                     \
    yogaStyle.field()[index] =                                        \
        getFieldValue(context, value, ygDefaults.field()[index]);     \
    return;                                                           \
  }

#define REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED_SETTER(                    \
    field, setter, index, fieldName)                                    \
  case CONSTEXPR_RAW_PROPS_KEY_HASH(fieldName): {                       \
    yogaStyle.setter(                                                   \
        index, getFieldValue(context, value, ygDefaults.field(index))); \
    return;                                                             \
  }

#define REBUILD_FIELD_ABI50_0_0YG_DIMENSION(field, setter, widthStr, heightStr) \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED_SETTER(                         \
      field, setter, ABI50_0_0YGDimensionWidth, widthStr);                      \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED_SETTER(                         \
      field, setter, ABI50_0_0YGDimensionHeight, heightStr);

#define REBUILD_FIELD_ABI50_0_0YG_GUTTER(field, rowGapStr, columnGapStr, gapStr)      \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(field, ABI50_0_0YGGutterRow, rowGapStr);       \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(field, ABI50_0_0YGGutterColumn, columnGapStr); \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(field, ABI50_0_0YGGutterAll, gapStr);

#define REBUILD_FIELD_ABI50_0_0YG_EDGES(field, prefix, suffix)                          \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(                                        \
      field, ABI50_0_0YGEdgeLeft, prefix "Left" suffix);                                \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(field, ABI50_0_0YGEdgeTop, prefix "Top" suffix); \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(                                        \
      field, ABI50_0_0YGEdgeRight, prefix "Right" suffix);                              \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(                                        \
      field, ABI50_0_0YGEdgeBottom, prefix "Bottom" suffix);                            \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(                                        \
      field, ABI50_0_0YGEdgeStart, prefix "Start" suffix);                              \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(field, ABI50_0_0YGEdgeEnd, prefix "End" suffix); \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(                                        \
      field, ABI50_0_0YGEdgeHorizontal, prefix "Horizontal" suffix);                    \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(                                        \
      field, ABI50_0_0YGEdgeVertical, prefix "Vertical" suffix);                        \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(field, ABI50_0_0YGEdgeAll, prefix "" suffix);

#define REBUILD_FIELD_ABI50_0_0YG_EDGES_POSITION()                                 \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(position, ABI50_0_0YGEdgeLeft, "left");     \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(position, ABI50_0_0YGEdgeTop, "top");       \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(position, ABI50_0_0YGEdgeRight, "right");   \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(position, ABI50_0_0YGEdgeBottom, "bottom"); \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(position, ABI50_0_0YGEdgeStart, "start");   \
  REBUILD_ABI50_0_0YG_FIELD_SWITCH_CASE_INDEXED(position, ABI50_0_0YGEdgeEnd, "end");

void YogaStylableProps::setProp(
    const PropsParserContext& context,
    RawPropsPropNameHash hash,
    const char* propName,
    const RawValue& value) {
  static const auto ygDefaults = yoga::Style{};
  static const auto defaults = YogaStylableProps{};

  Props::setProp(context, hash, propName, value);

  switch (hash) {
    REBUILD_FIELD_SWITCH_CASE_YSP(direction);
    REBUILD_FIELD_SWITCH_CASE_YSP(flexDirection);
    REBUILD_FIELD_SWITCH_CASE_YSP(justifyContent);
    REBUILD_FIELD_SWITCH_CASE_YSP(alignContent);
    REBUILD_FIELD_SWITCH_CASE_YSP(alignItems);
    REBUILD_FIELD_SWITCH_CASE_YSP(alignSelf);
    REBUILD_FIELD_SWITCH_CASE_YSP(flexWrap);
    REBUILD_FIELD_SWITCH_CASE_YSP(overflow);
    REBUILD_FIELD_SWITCH_CASE_YSP(display);
    REBUILD_FIELD_SWITCH_CASE_YSP(flex);
    REBUILD_FIELD_SWITCH_CASE_YSP(flexGrow);
    REBUILD_FIELD_SWITCH_CASE_YSP(flexShrink);
    REBUILD_FIELD_SWITCH_CASE_YSP(flexBasis);
    REBUILD_FIELD_SWITCH_CASE2(positionType, "position");
    REBUILD_FIELD_ABI50_0_0YG_GUTTER(gap, "rowGap", "columnGap", "gap");
    REBUILD_FIELD_SWITCH_CASE_YSP(aspectRatio);
    REBUILD_FIELD_ABI50_0_0YG_DIMENSION(dimension, setDimension, "width", "height");
    REBUILD_FIELD_ABI50_0_0YG_DIMENSION(
        minDimension, setMinDimension, "minWidth", "minHeight");
    REBUILD_FIELD_ABI50_0_0YG_DIMENSION(
        maxDimension, setMaxDimension, "maxWidth", "maxHeight");
    REBUILD_FIELD_ABI50_0_0YG_EDGES_POSITION();
    REBUILD_FIELD_ABI50_0_0YG_EDGES(margin, "margin", "");
    REBUILD_FIELD_ABI50_0_0YG_EDGES(padding, "padding", "");
    REBUILD_FIELD_ABI50_0_0YG_EDGES(border, "border", "Width");

    // Aliases
    RAW_SET_PROP_SWITCH_CASE(inset, "inset");
    RAW_SET_PROP_SWITCH_CASE(insetBlock, "insetBlock");
    RAW_SET_PROP_SWITCH_CASE(insetBlockEnd, "insetBlockEnd");
    RAW_SET_PROP_SWITCH_CASE(insetBlockStart, "insetBlockStart");
    RAW_SET_PROP_SWITCH_CASE(insetInline, "insetInline");
    RAW_SET_PROP_SWITCH_CASE(insetInlineEnd, "insetInlineEnd");
    RAW_SET_PROP_SWITCH_CASE(insetInlineStart, "insetInlineStart");
    RAW_SET_PROP_SWITCH_CASE(marginInline, "marginInline");
    RAW_SET_PROP_SWITCH_CASE(marginInlineStart, "marginInlineStart");
    RAW_SET_PROP_SWITCH_CASE(marginInlineEnd, "marginInlineEnd");
    RAW_SET_PROP_SWITCH_CASE(marginBlock, "marginBlock");
    RAW_SET_PROP_SWITCH_CASE(marginBlockStart, "marginBlockStart");
    RAW_SET_PROP_SWITCH_CASE(marginBlockEnd, "marginBlockEnd");
    RAW_SET_PROP_SWITCH_CASE(paddingInline, "paddingInline");
    RAW_SET_PROP_SWITCH_CASE(paddingInlineStart, "paddingInlineStart");
    RAW_SET_PROP_SWITCH_CASE(paddingInlineEnd, "paddingInlineEnd");
    RAW_SET_PROP_SWITCH_CASE(paddingBlock, "paddingBlock");
    RAW_SET_PROP_SWITCH_CASE(paddingBlockStart, "paddingBlockStart");
    RAW_SET_PROP_SWITCH_CASE(paddingBlockEnd, "paddingBlockEnd");
  }
}

#pragma mark - DebugStringConvertible

#if ABI50_0_0RN_DEBUG_STRING_CONVERTIBLE
SharedDebugStringConvertibleList YogaStylableProps::getDebugProps() const {
  const auto defaultYogaStyle = yoga::Style{};
  return {
      debugStringConvertibleItem(
          "direction", yogaStyle.direction(), defaultYogaStyle.direction()),
      debugStringConvertibleItem(
          "flexDirection",
          yogaStyle.flexDirection(),
          defaultYogaStyle.flexDirection()),
      debugStringConvertibleItem(
          "justifyContent",
          yogaStyle.justifyContent(),
          defaultYogaStyle.justifyContent()),
      debugStringConvertibleItem(
          "alignContent",
          yogaStyle.alignContent(),
          defaultYogaStyle.alignContent()),
      debugStringConvertibleItem(
          "alignItems", yogaStyle.alignItems(), defaultYogaStyle.alignItems()),
      debugStringConvertibleItem(
          "alignSelf", yogaStyle.alignSelf(), defaultYogaStyle.alignSelf()),
      debugStringConvertibleItem(
          "positionType",
          yogaStyle.positionType(),
          defaultYogaStyle.positionType()),
      debugStringConvertibleItem(
          "flexWrap", yogaStyle.flexWrap(), defaultYogaStyle.flexWrap()),
      debugStringConvertibleItem(
          "overflow", yogaStyle.overflow(), defaultYogaStyle.overflow()),
      debugStringConvertibleItem(
          "display", yogaStyle.display(), defaultYogaStyle.display()),
      debugStringConvertibleItem(
          "flex", yogaStyle.flex(), defaultYogaStyle.flex()),
      debugStringConvertibleItem(
          "flexGrow", yogaStyle.flexGrow(), defaultYogaStyle.flexGrow()),
      debugStringConvertibleItem(
          "rowGap",
          yogaStyle.gap()[ABI50_0_0YGGutterRow],
          defaultYogaStyle.gap()[ABI50_0_0YGGutterRow]),
      debugStringConvertibleItem(
          "columnGap",
          yogaStyle.gap()[ABI50_0_0YGGutterColumn],
          defaultYogaStyle.gap()[ABI50_0_0YGGutterColumn]),
      debugStringConvertibleItem(
          "gap",
          yogaStyle.gap()[ABI50_0_0YGGutterAll],
          defaultYogaStyle.gap()[ABI50_0_0YGGutterAll]),
      debugStringConvertibleItem(
          "flexShrink", yogaStyle.flexShrink(), defaultYogaStyle.flexShrink()),
      debugStringConvertibleItem(
          "flexBasis", yogaStyle.flexBasis(), defaultYogaStyle.flexBasis()),
      debugStringConvertibleItem(
          "margin", yogaStyle.margin(), defaultYogaStyle.margin()),
      debugStringConvertibleItem(
          "position", yogaStyle.position(), defaultYogaStyle.position()),
      debugStringConvertibleItem(
          "padding", yogaStyle.padding(), defaultYogaStyle.padding()),
      debugStringConvertibleItem(
          "border", yogaStyle.border(), defaultYogaStyle.border()),
      debugStringConvertibleItem(
          "width",
          yogaStyle.dimension(ABI50_0_0YGDimensionWidth),
          defaultYogaStyle.dimension(ABI50_0_0YGDimensionWidth)),
      debugStringConvertibleItem(
          "height",
          yogaStyle.dimension(ABI50_0_0YGDimensionHeight),
          defaultYogaStyle.dimension(ABI50_0_0YGDimensionHeight)),
      debugStringConvertibleItem(
          "minWidth",
          yogaStyle.minDimension(ABI50_0_0YGDimensionWidth),
          defaultYogaStyle.minDimension(ABI50_0_0YGDimensionWidth)),
      debugStringConvertibleItem(
          "minHeight",
          yogaStyle.minDimension(ABI50_0_0YGDimensionHeight),
          defaultYogaStyle.minDimension(ABI50_0_0YGDimensionHeight)),
      debugStringConvertibleItem(
          "maxWidth",
          yogaStyle.maxDimension(ABI50_0_0YGDimensionWidth),
          defaultYogaStyle.maxDimension(ABI50_0_0YGDimensionWidth)),
      debugStringConvertibleItem(
          "maxHeight",
          yogaStyle.maxDimension(ABI50_0_0YGDimensionHeight),
          defaultYogaStyle.maxDimension(ABI50_0_0YGDimensionHeight)),
      debugStringConvertibleItem(
          "aspectRatio",
          yogaStyle.aspectRatio(),
          defaultYogaStyle.aspectRatio()),
  };
}
#endif

void YogaStylableProps::convertRawPropAliases(
    const PropsParserContext& context,
    const YogaStylableProps& sourceProps,
    const RawProps& rawProps) {
  inset = convertRawProp(
      context,
      rawProps,
      "inset",
      sourceProps.inset,
      CompactValue::ofUndefined());
  insetBlock = convertRawProp(
      context,
      rawProps,
      "insetBlock",
      sourceProps.insetBlock,
      CompactValue::ofUndefined());
  insetBlockEnd = convertRawProp(
      context,
      rawProps,
      "insetBlockEnd",
      sourceProps.insetBlockEnd,
      CompactValue::ofUndefined());
  insetBlockStart = convertRawProp(
      context,
      rawProps,
      "insetBlockStart",
      sourceProps.insetBlockStart,
      CompactValue::ofUndefined());
  insetInline = convertRawProp(
      context,
      rawProps,
      "insetInline",
      sourceProps.insetInline,
      CompactValue::ofUndefined());
  insetInlineEnd = convertRawProp(
      context,
      rawProps,
      "insetInlineEnd",
      sourceProps.insetInlineEnd,
      CompactValue::ofUndefined());
  insetInlineStart = convertRawProp(
      context,
      rawProps,
      "insetInlineStart",
      sourceProps.insetInlineStart,
      CompactValue::ofUndefined());
  marginInline = convertRawProp(
      context,
      rawProps,
      "marginInline",
      sourceProps.marginInline,
      CompactValue::ofUndefined());
  marginInlineStart = convertRawProp(
      context,
      rawProps,
      "marginInlineStart",
      sourceProps.marginInlineStart,
      CompactValue::ofUndefined());
  marginInlineEnd = convertRawProp(
      context,
      rawProps,
      "marginInlineEnd",
      sourceProps.marginInlineEnd,
      CompactValue::ofUndefined());
  marginBlock = convertRawProp(
      context,
      rawProps,
      "marginBlock",
      sourceProps.marginBlock,
      CompactValue::ofUndefined());
  marginBlockStart = convertRawProp(
      context,
      rawProps,
      "marginBlockStart",
      sourceProps.marginBlockStart,
      CompactValue::ofUndefined());
  marginBlockEnd = convertRawProp(
      context,
      rawProps,
      "marginBlockEnd",
      sourceProps.marginBlockEnd,
      CompactValue::ofUndefined());

  paddingInline = convertRawProp(
      context,
      rawProps,
      "paddingInline",
      sourceProps.paddingInline,
      CompactValue::ofUndefined());
  paddingInlineStart = convertRawProp(
      context,
      rawProps,
      "paddingInlineStart",
      sourceProps.paddingInlineStart,
      CompactValue::ofUndefined());
  paddingInlineEnd = convertRawProp(
      context,
      rawProps,
      "paddingInlineEnd",
      sourceProps.paddingInlineEnd,
      CompactValue::ofUndefined());
  paddingBlock = convertRawProp(
      context,
      rawProps,
      "paddingBlock",
      sourceProps.paddingBlock,
      CompactValue::ofUndefined());
  paddingBlockStart = convertRawProp(
      context,
      rawProps,
      "paddingBlockStart",
      sourceProps.paddingBlockStart,
      CompactValue::ofUndefined());
  paddingBlockEnd = convertRawProp(
      context,
      rawProps,
      "paddingBlockEnd",
      sourceProps.paddingBlockEnd,
      CompactValue::ofUndefined());
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
