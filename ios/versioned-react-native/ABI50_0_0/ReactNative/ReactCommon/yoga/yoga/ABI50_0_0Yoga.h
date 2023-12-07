/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <stdarg.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <ABI50_0_0yoga/ABI50_0_0YGEnums.h>
#include <ABI50_0_0yoga/ABI50_0_0YGMacros.h>
#include <ABI50_0_0yoga/ABI50_0_0YGValue.h>

ABI50_0_0YG_EXTERN_C_BEGIN

typedef struct ABI50_0_0YGSize {
  float width;
  float height;
} ABI50_0_0YGSize;

typedef struct ABI50_0_0YGConfig* ABI50_0_0YGConfigRef;
typedef const struct ABI50_0_0YGConfig* ABI50_0_0YGConfigConstRef;

typedef struct ABI50_0_0YGNode* ABI50_0_0YGNodeRef;
typedef const struct ABI50_0_0YGNode* ABI50_0_0YGNodeConstRef;

typedef ABI50_0_0YGSize (*ABI50_0_0YGMeasureFunc)(
    ABI50_0_0YGNodeConstRef node,
    float width,
    ABI50_0_0YGMeasureMode widthMode,
    float height,
    ABI50_0_0YGMeasureMode heightMode);
typedef float (*ABI50_0_0YGBaselineFunc)(ABI50_0_0YGNodeConstRef node, float width, float height);
typedef void (*ABI50_0_0YGDirtiedFunc)(ABI50_0_0YGNodeConstRef node);
typedef void (*ABI50_0_0YGPrintFunc)(ABI50_0_0YGNodeConstRef node);
typedef void (*ABI50_0_0YGNodeCleanupFunc)(ABI50_0_0YGNodeConstRef node);
typedef int (*ABI50_0_0YGLogger)(
    ABI50_0_0YGConfigConstRef config,
    ABI50_0_0YGNodeConstRef node,
    ABI50_0_0YGLogLevel level,
    const char* format,
    va_list args);
typedef ABI50_0_0YGNodeRef (*ABI50_0_0YGCloneNodeFunc)(
    ABI50_0_0YGNodeConstRef oldNode,
    ABI50_0_0YGNodeConstRef owner,
    size_t childIndex);

// ABI50_0_0YGNode
ABI50_0_0YG_EXPORT ABI50_0_0YGNodeRef ABI50_0_0YGNodeNew(void);
ABI50_0_0YG_EXPORT ABI50_0_0YGNodeRef ABI50_0_0YGNodeNewWithConfig(ABI50_0_0YGConfigConstRef config);
ABI50_0_0YG_EXPORT ABI50_0_0YGNodeRef ABI50_0_0YGNodeClone(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeFree(ABI50_0_0YGNodeRef node);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeFreeRecursiveWithCleanupFunc(
    ABI50_0_0YGNodeRef node,
    ABI50_0_0YGNodeCleanupFunc cleanup);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeFreeRecursive(ABI50_0_0YGNodeRef node);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeReset(ABI50_0_0YGNodeRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeInsertChild(ABI50_0_0YGNodeRef node, ABI50_0_0YGNodeRef child, size_t index);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeSwapChild(ABI50_0_0YGNodeRef node, ABI50_0_0YGNodeRef child, size_t index);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeRemoveChild(ABI50_0_0YGNodeRef node, ABI50_0_0YGNodeRef child);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeRemoveAllChildren(ABI50_0_0YGNodeRef node);
ABI50_0_0YG_EXPORT ABI50_0_0YGNodeRef ABI50_0_0YGNodeGetChild(ABI50_0_0YGNodeRef node, size_t index);
ABI50_0_0YG_EXPORT ABI50_0_0YGNodeRef ABI50_0_0YGNodeGetOwner(ABI50_0_0YGNodeRef node);
ABI50_0_0YG_EXPORT ABI50_0_0YGNodeRef ABI50_0_0YGNodeGetParent(ABI50_0_0YGNodeRef node);
ABI50_0_0YG_EXPORT size_t ABI50_0_0YGNodeGetChildCount(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT void
ABI50_0_0YGNodeSetChildren(ABI50_0_0YGNodeRef owner, const ABI50_0_0YGNodeRef* children, size_t count);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeSetIsReferenceBaseline(
    ABI50_0_0YGNodeRef node,
    bool isReferenceBaseline);

ABI50_0_0YG_EXPORT bool ABI50_0_0YGNodeIsReferenceBaseline(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeCalculateLayout(
    ABI50_0_0YGNodeRef node,
    float availableWidth,
    float availableHeight,
    ABI50_0_0YGDirection ownerDirection);

// Mark a node as dirty. Only valid for nodes with a custom measure function
// set.
//
// Yoga knows when to mark all other nodes as dirty but because nodes with
// measure functions depend on information not known to Yoga they must perform
// this dirty marking manually.
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeMarkDirty(ABI50_0_0YGNodeRef node);

// Marks the current node and all its descendants as dirty.
//
// Intended to be used for Yoga benchmarks. Don't use in production, as calling
// `ABI50_0_0YGCalculateLayout` will cause the recalculation of each and every node.
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeMarkDirtyAndPropagateToDescendants(ABI50_0_0YGNodeRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodePrint(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGPrintOptions options);

ABI50_0_0YG_EXPORT bool ABI50_0_0YGFloatIsUndefined(float value);

// TODO: This should not be part of the public API. Remove after removing
// ComponentKit usage of it.
ABI50_0_0YG_EXPORT bool ABI50_0_0YGNodeCanUseCachedMeasurement(
    ABI50_0_0YGMeasureMode widthMode,
    float availableWidth,
    ABI50_0_0YGMeasureMode heightMode,
    float availableHeight,
    ABI50_0_0YGMeasureMode lastWidthMode,
    float lastAvailableWidth,
    ABI50_0_0YGMeasureMode lastHeightMode,
    float lastAvailableHeight,
    float lastComputedWidth,
    float lastComputedHeight,
    float marginRow,
    float marginColumn,
    ABI50_0_0YGConfigRef config);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeCopyStyle(ABI50_0_0YGNodeRef dstNode, ABI50_0_0YGNodeConstRef srcNode);

ABI50_0_0YG_EXPORT void* ABI50_0_0YGNodeGetContext(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeSetContext(ABI50_0_0YGNodeRef node, void* context);

ABI50_0_0YG_EXPORT ABI50_0_0YGConfigConstRef ABI50_0_0YGNodeGetConfig(ABI50_0_0YGNodeRef node);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeSetConfig(ABI50_0_0YGNodeRef node, ABI50_0_0YGConfigRef config);

ABI50_0_0YG_EXPORT void ABI50_0_0YGConfigSetPrintTreeFlag(ABI50_0_0YGConfigRef config, bool enabled);
ABI50_0_0YG_EXPORT bool ABI50_0_0YGNodeHasMeasureFunc(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeSetMeasureFunc(ABI50_0_0YGNodeRef node, ABI50_0_0YGMeasureFunc measureFunc);
ABI50_0_0YG_EXPORT bool ABI50_0_0YGNodeHasBaselineFunc(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeSetBaselineFunc(
    ABI50_0_0YGNodeRef node,
    ABI50_0_0YGBaselineFunc baselineFunc);
ABI50_0_0YG_EXPORT ABI50_0_0YGDirtiedFunc ABI50_0_0YGNodeGetDirtiedFunc(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeSetDirtiedFunc(ABI50_0_0YGNodeRef node, ABI50_0_0YGDirtiedFunc dirtiedFunc);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeSetPrintFunc(ABI50_0_0YGNodeRef node, ABI50_0_0YGPrintFunc printFunc);
ABI50_0_0YG_EXPORT bool ABI50_0_0YGNodeGetHasNewLayout(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeSetHasNewLayout(ABI50_0_0YGNodeRef node, bool hasNewLayout);
ABI50_0_0YG_EXPORT ABI50_0_0YGNodeType ABI50_0_0YGNodeGetNodeType(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeSetNodeType(ABI50_0_0YGNodeRef node, ABI50_0_0YGNodeType nodeType);
ABI50_0_0YG_EXPORT bool ABI50_0_0YGNodeIsDirty(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetDirection(ABI50_0_0YGNodeRef node, ABI50_0_0YGDirection direction);
ABI50_0_0YG_EXPORT ABI50_0_0YGDirection ABI50_0_0YGNodeStyleGetDirection(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetFlexDirection(
    ABI50_0_0YGNodeRef node,
    ABI50_0_0YGFlexDirection flexDirection);
ABI50_0_0YG_EXPORT ABI50_0_0YGFlexDirection ABI50_0_0YGNodeStyleGetFlexDirection(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetJustifyContent(
    ABI50_0_0YGNodeRef node,
    ABI50_0_0YGJustify justifyContent);
ABI50_0_0YG_EXPORT ABI50_0_0YGJustify ABI50_0_0YGNodeStyleGetJustifyContent(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetAlignContent(ABI50_0_0YGNodeRef node, ABI50_0_0YGAlign alignContent);
ABI50_0_0YG_EXPORT ABI50_0_0YGAlign ABI50_0_0YGNodeStyleGetAlignContent(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetAlignItems(ABI50_0_0YGNodeRef node, ABI50_0_0YGAlign alignItems);
ABI50_0_0YG_EXPORT ABI50_0_0YGAlign ABI50_0_0YGNodeStyleGetAlignItems(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetAlignSelf(ABI50_0_0YGNodeRef node, ABI50_0_0YGAlign alignSelf);
ABI50_0_0YG_EXPORT ABI50_0_0YGAlign ABI50_0_0YGNodeStyleGetAlignSelf(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetPositionType(
    ABI50_0_0YGNodeRef node,
    ABI50_0_0YGPositionType positionType);
ABI50_0_0YG_EXPORT ABI50_0_0YGPositionType ABI50_0_0YGNodeStyleGetPositionType(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetFlexWrap(ABI50_0_0YGNodeRef node, ABI50_0_0YGWrap flexWrap);
ABI50_0_0YG_EXPORT ABI50_0_0YGWrap ABI50_0_0YGNodeStyleGetFlexWrap(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetOverflow(ABI50_0_0YGNodeRef node, ABI50_0_0YGOverflow overflow);
ABI50_0_0YG_EXPORT ABI50_0_0YGOverflow ABI50_0_0YGNodeStyleGetOverflow(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetDisplay(ABI50_0_0YGNodeRef node, ABI50_0_0YGDisplay display);
ABI50_0_0YG_EXPORT ABI50_0_0YGDisplay ABI50_0_0YGNodeStyleGetDisplay(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetFlex(ABI50_0_0YGNodeRef node, float flex);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeStyleGetFlex(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetFlexGrow(ABI50_0_0YGNodeRef node, float flexGrow);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeStyleGetFlexGrow(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetFlexShrink(ABI50_0_0YGNodeRef node, float flexShrink);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeStyleGetFlexShrink(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetFlexBasis(ABI50_0_0YGNodeRef node, float flexBasis);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetFlexBasisPercent(ABI50_0_0YGNodeRef node, float flexBasis);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetFlexBasisAuto(ABI50_0_0YGNodeRef node);
ABI50_0_0YG_EXPORT ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetFlexBasis(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void
ABI50_0_0YGNodeStyleSetPosition(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float position);
ABI50_0_0YG_EXPORT void
ABI50_0_0YGNodeStyleSetPositionPercent(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float position);
ABI50_0_0YG_EXPORT ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetPosition(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetMargin(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float margin);
ABI50_0_0YG_EXPORT void
ABI50_0_0YGNodeStyleSetMarginPercent(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float margin);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetMarginAuto(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge);
ABI50_0_0YG_EXPORT ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetMargin(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge);

ABI50_0_0YG_EXPORT void
ABI50_0_0YGNodeStyleSetPadding(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float padding);
ABI50_0_0YG_EXPORT void
ABI50_0_0YGNodeStyleSetPaddingPercent(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float padding);
ABI50_0_0YG_EXPORT ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetPadding(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetBorder(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float border);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeStyleGetBorder(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge);

ABI50_0_0YG_EXPORT void
ABI50_0_0YGNodeStyleSetGap(ABI50_0_0YGNodeRef node, ABI50_0_0YGGutter gutter, float gapLength);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeStyleGetGap(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGGutter gutter);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetWidth(ABI50_0_0YGNodeRef node, float width);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetWidthPercent(ABI50_0_0YGNodeRef node, float width);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetWidthAuto(ABI50_0_0YGNodeRef node);
ABI50_0_0YG_EXPORT ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetWidth(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetHeight(ABI50_0_0YGNodeRef node, float height);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetHeightPercent(ABI50_0_0YGNodeRef node, float height);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetHeightAuto(ABI50_0_0YGNodeRef node);
ABI50_0_0YG_EXPORT ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetHeight(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetMinWidth(ABI50_0_0YGNodeRef node, float minWidth);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetMinWidthPercent(ABI50_0_0YGNodeRef node, float minWidth);
ABI50_0_0YG_EXPORT ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetMinWidth(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetMinHeight(ABI50_0_0YGNodeRef node, float minHeight);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetMinHeightPercent(ABI50_0_0YGNodeRef node, float minHeight);
ABI50_0_0YG_EXPORT ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetMinHeight(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetMaxWidth(ABI50_0_0YGNodeRef node, float maxWidth);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetMaxWidthPercent(ABI50_0_0YGNodeRef node, float maxWidth);
ABI50_0_0YG_EXPORT ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetMaxWidth(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetMaxHeight(ABI50_0_0YGNodeRef node, float maxHeight);
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetMaxHeightPercent(ABI50_0_0YGNodeRef node, float maxHeight);
ABI50_0_0YG_EXPORT ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetMaxHeight(ABI50_0_0YGNodeConstRef node);

// Yoga specific properties, not compatible with flexbox specification Aspect
// ratio control the size of the undefined dimension of a node. Aspect ratio is
// encoded as a floating point value width/height. e.g. A value of 2 leads to a
// node with a width twice the size of its height while a value of 0.5 gives the
// opposite effect.
//
// - On a node with a set width/height aspect ratio control the size of the
//   unset dimension
// - On a node with a set flex basis aspect ratio controls the size of the node
//   in the cross axis if unset
// - On a node with a measure function aspect ratio works as though the measure
//   function measures the flex basis
// - On a node with flex grow/shrink aspect ratio controls the size of the node
//   in the cross axis if unset
// - Aspect ratio takes min/max dimensions into account
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeStyleSetAspectRatio(ABI50_0_0YGNodeRef node, float aspectRatio);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeStyleGetAspectRatio(ABI50_0_0YGNodeConstRef node);

ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeLayoutGetLeft(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeLayoutGetTop(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeLayoutGetRight(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeLayoutGetBottom(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeLayoutGetWidth(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeLayoutGetHeight(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT ABI50_0_0YGDirection ABI50_0_0YGNodeLayoutGetDirection(ABI50_0_0YGNodeConstRef node);
ABI50_0_0YG_EXPORT bool ABI50_0_0YGNodeLayoutGetHadOverflow(ABI50_0_0YGNodeConstRef node);

// Get the computed values for these nodes after performing layout. If they were
// set using point values then the returned value will be the same as
// ABI50_0_0YGNodeStyleGetXXX. However if they were set using a percentage value then the
// returned value is the computed value used during layout.
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeLayoutGetMargin(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeLayoutGetBorder(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge);
ABI50_0_0YG_EXPORT float ABI50_0_0YGNodeLayoutGetPadding(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge);

ABI50_0_0YG_EXPORT void ABI50_0_0YGConfigSetLogger(ABI50_0_0YGConfigRef config, ABI50_0_0YGLogger logger);
// Set this to number of pixels in 1 point to round calculation results If you
// want to avoid rounding - set PointScaleFactor to 0
ABI50_0_0YG_EXPORT void ABI50_0_0YGConfigSetPointScaleFactor(
    ABI50_0_0YGConfigRef config,
    float pixelsInPoint);
ABI50_0_0YG_EXPORT float ABI50_0_0YGConfigGetPointScaleFactor(ABI50_0_0YGConfigConstRef config);

// ABI50_0_0YGConfig
ABI50_0_0YG_EXPORT ABI50_0_0YGConfigRef ABI50_0_0YGConfigNew(void);
ABI50_0_0YG_EXPORT void ABI50_0_0YGConfigFree(ABI50_0_0YGConfigRef config);

ABI50_0_0YG_EXPORT void ABI50_0_0YGConfigSetExperimentalFeatureEnabled(
    ABI50_0_0YGConfigRef config,
    ABI50_0_0YGExperimentalFeature feature,
    bool enabled);
ABI50_0_0YG_EXPORT bool ABI50_0_0YGConfigIsExperimentalFeatureEnabled(
    ABI50_0_0YGConfigConstRef config,
    ABI50_0_0YGExperimentalFeature feature);

// Using the web defaults is the preferred configuration for new projects. Usage
// of non web defaults should be considered as legacy.
ABI50_0_0YG_EXPORT void ABI50_0_0YGConfigSetUseWebDefaults(ABI50_0_0YGConfigRef config, bool enabled);
ABI50_0_0YG_EXPORT bool ABI50_0_0YGConfigGetUseWebDefaults(ABI50_0_0YGConfigConstRef config);

ABI50_0_0YG_EXPORT void ABI50_0_0YGConfigSetCloneNodeFunc(
    ABI50_0_0YGConfigRef config,
    ABI50_0_0YGCloneNodeFunc callback);

ABI50_0_0YG_EXPORT ABI50_0_0YGConfigConstRef ABI50_0_0YGConfigGetDefault(void);

ABI50_0_0YG_EXPORT void ABI50_0_0YGConfigSetContext(ABI50_0_0YGConfigRef config, void* context);
ABI50_0_0YG_EXPORT void* ABI50_0_0YGConfigGetContext(ABI50_0_0YGConfigConstRef config);

ABI50_0_0YG_EXPORT void ABI50_0_0YGConfigSetErrata(ABI50_0_0YGConfigRef config, ABI50_0_0YGErrata errata);
ABI50_0_0YG_EXPORT ABI50_0_0YGErrata ABI50_0_0YGConfigGetErrata(ABI50_0_0YGConfigConstRef config);

ABI50_0_0YG_EXPORT float ABI50_0_0YGRoundValueToPixelGrid(
    double value,
    double pointScaleFactor,
    bool forceCeil,
    bool forceFloor);

ABI50_0_0YG_EXTERN_C_END
