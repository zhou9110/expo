/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <stdio.h>
#include <cstdint>
#include <vector>

#include <ABI50_0_0yoga/ABI50_0_0Yoga.h>

#include <ABI50_0_0yoga/config/ABI50_0_0Config.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0Direction.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0Errata.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0MeasureMode.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0NodeType.h>
#include <ABI50_0_0yoga/node/ABI50_0_0LayoutResults.h>
#include <ABI50_0_0yoga/style/ABI50_0_0CompactValue.h>
#include <ABI50_0_0yoga/style/ABI50_0_0Style.h>

// Tag struct used to form the opaque ABI50_0_0YGNodeRef for the public C API
struct ABI50_0_0YGNode {};

namespace ABI50_0_0facebook::yoga {

class ABI50_0_0YG_EXPORT Node : public ::ABI50_0_0YGNode {
 private:
  bool hasNewLayout_ : 1 = true;
  bool isReferenceBaseline_ : 1 = false;
  bool isDirty_ : 1 = false;
  NodeType nodeType_ : bitCount<NodeType>() = NodeType::Default;
  void* context_ = nullptr;
  ABI50_0_0YGMeasureFunc measureFunc_ = {nullptr};
  ABI50_0_0YGBaselineFunc baselineFunc_ = {nullptr};
  ABI50_0_0YGPrintFunc printFunc_ = {nullptr};
  ABI50_0_0YGDirtiedFunc dirtiedFunc_ = nullptr;
  Style style_ = {};
  LayoutResults layout_ = {};
  size_t lineIndex_ = 0;
  Node* owner_ = nullptr;
  std::vector<Node*> children_ = {};
  const Config* config_;
  std::array<ABI50_0_0YGValue, 2> resolvedDimensions_ = {
      {ABI50_0_0YGValueUndefined, ABI50_0_0YGValueUndefined}};

  FloatOptional relativePosition(const FlexDirection axis, const float axisSize)
      const;

  void useWebDefaults() {
    style_.flexDirection() = FlexDirection::Row;
    style_.alignContent() = Align::Stretch;
  }

  // DANGER DANGER DANGER!
  // If the node assigned to has children, we'd either have to deallocate
  // them (potentially incorrect) or ignore them (danger of leaks). Only ever
  // use this after checking that there are no children.
  // DO NOT CHANGE THE VISIBILITY OF THIS METHOD!
  Node& operator=(Node&&) = default;

 public:
  Node();
  explicit Node(const Config* config);
  ~Node() = default; // cleanup of owner/children relationships in ABI50_0_0YGNodeFree

  Node(Node&&);

  // Does not expose true value semantics, as children are not cloned eagerly.
  // Should we remove this?
  Node(const Node& node) = default;

  // assignment means potential leaks of existing children, or alternatively
  // freeing unowned memory, double free, or freeing stack memory.
  Node& operator=(const Node&) = delete;

  // Getters
  void* getContext() const {
    return context_;
  }

  void print();

  bool getHasNewLayout() const {
    return hasNewLayout_;
  }

  NodeType getNodeType() const {
    return nodeType_;
  }

  bool hasMeasureFunc() const noexcept {
    return measureFunc_ != nullptr;
  }

  ABI50_0_0YGSize measure(float, MeasureMode, float, MeasureMode);

  bool hasBaselineFunc() const noexcept {
    return baselineFunc_ != nullptr;
  }

  float baseline(float width, float height) const;

  bool hasErrata(Errata errata) const {
    return config_->hasErrata(errata);
  }

  ABI50_0_0YGDirtiedFunc getDirtiedFunc() const {
    return dirtiedFunc_;
  }

  // For Performance reasons passing as reference.
  Style& getStyle() {
    return style_;
  }

  const Style& getStyle() const {
    return style_;
  }

  // For Performance reasons passing as reference.
  LayoutResults& getLayout() {
    return layout_;
  }

  const LayoutResults& getLayout() const {
    return layout_;
  }

  size_t getLineIndex() const {
    return lineIndex_;
  }

  bool isReferenceBaseline() const {
    return isReferenceBaseline_;
  }

  // returns the Node that owns this Node. An owner is used to identify
  // the YogaTree that a Node belongs to. This method will return the parent
  // of the Node when a Node only belongs to one YogaTree or nullptr when
  // the Node is shared between two or more YogaTrees.
  Node* getOwner() const {
    return owner_;
  }

  // Deprecated, use getOwner() instead.
  Node* getParent() const {
    return getOwner();
  }

  const std::vector<Node*>& getChildren() const {
    return children_;
  }

  Node* getChild(size_t index) const {
    return children_.at(index);
  }

  size_t getChildCount() const {
    return children_.size();
  }

  const Config* getConfig() const {
    return config_;
  }

  bool isDirty() const {
    return isDirty_;
  }

  std::array<ABI50_0_0YGValue, 2> getResolvedDimensions() const {
    return resolvedDimensions_;
  }

  ABI50_0_0YGValue getResolvedDimension(ABI50_0_0YGDimension dimension) const {
    return resolvedDimensions_[static_cast<size_t>(dimension)];
  }

  static CompactValue computeEdgeValueForColumn(
      const Style::Edges& edges,
      ABI50_0_0YGEdge edge,
      CompactValue defaultValue);

  static CompactValue computeEdgeValueForRow(
      const Style::Edges& edges,
      ABI50_0_0YGEdge rowEdge,
      ABI50_0_0YGEdge edge,
      CompactValue defaultValue);

  static CompactValue computeRowGap(
      const Style::Gutters& gutters,
      CompactValue defaultValue);

  static CompactValue computeColumnGap(
      const Style::Gutters& gutters,
      CompactValue defaultValue);

  // Methods related to positions, margin, padding and border
  FloatOptional getLeadingPosition(
      const FlexDirection axis,
      const float axisSize) const;
  bool isLeadingPositionDefined(const FlexDirection axis) const;
  bool isTrailingPosDefined(const FlexDirection axis) const;
  FloatOptional getTrailingPosition(
      const FlexDirection axis,
      const float axisSize) const;
  FloatOptional getLeadingMargin(
      const FlexDirection axis,
      const float widthSize) const;
  FloatOptional getTrailingMargin(
      const FlexDirection axis,
      const float widthSize) const;
  float getLeadingBorder(const FlexDirection flexDirection) const;
  float getTrailingBorder(const FlexDirection flexDirection) const;
  FloatOptional getLeadingPadding(
      const FlexDirection axis,
      const float widthSize) const;
  FloatOptional getTrailingPadding(
      const FlexDirection axis,
      const float widthSize) const;
  FloatOptional getLeadingPaddingAndBorder(
      const FlexDirection axis,
      const float widthSize) const;
  FloatOptional getTrailingPaddingAndBorder(
      const FlexDirection axis,
      const float widthSize) const;
  FloatOptional getMarginForAxis(
      const FlexDirection axis,
      const float widthSize) const;
  FloatOptional getGapForAxis(const FlexDirection axis, const float widthSize)
      const;
  // Setters

  void setContext(void* context) {
    context_ = context;
  }

  void setPrintFunc(ABI50_0_0YGPrintFunc printFunc) {
    printFunc_ = printFunc;
  }

  void setHasNewLayout(bool hasNewLayout) {
    hasNewLayout_ = hasNewLayout;
  }

  void setNodeType(NodeType nodeType) {
    nodeType_ = nodeType;
  }

  void setMeasureFunc(ABI50_0_0YGMeasureFunc measureFunc);

  void setBaselineFunc(ABI50_0_0YGBaselineFunc baseLineFunc) {
    baselineFunc_ = baseLineFunc;
  }

  void setDirtiedFunc(ABI50_0_0YGDirtiedFunc dirtiedFunc) {
    dirtiedFunc_ = dirtiedFunc;
  }

  void setStyle(const Style& style) {
    style_ = style;
  }

  void setLayout(const LayoutResults& layout) {
    layout_ = layout;
  }

  void setLineIndex(size_t lineIndex) {
    lineIndex_ = lineIndex;
  }

  void setIsReferenceBaseline(bool isReferenceBaseline) {
    isReferenceBaseline_ = isReferenceBaseline;
  }

  void setOwner(Node* owner) {
    owner_ = owner;
  }

  void setChildren(const std::vector<Node*>& children) {
    children_ = children;
  }

  // TODO: rvalue override for setChildren

  void setConfig(Config* config);

  void setDirty(bool isDirty);
  void setLayoutLastOwnerDirection(Direction direction);
  void setLayoutComputedFlexBasis(const FloatOptional computedFlexBasis);
  void setLayoutComputedFlexBasisGeneration(
      uint32_t computedFlexBasisGeneration);
  void setLayoutMeasuredDimension(
      float measuredDimension,
      ABI50_0_0YGDimension dimension);
  void setLayoutHadOverflow(bool hadOverflow);
  void setLayoutDimension(float dimensionValue, ABI50_0_0YGDimension dimension);
  void setLayoutDirection(Direction direction);
  void setLayoutMargin(float margin, ABI50_0_0YGEdge edge);
  void setLayoutBorder(float border, ABI50_0_0YGEdge edge);
  void setLayoutPadding(float padding, ABI50_0_0YGEdge edge);
  void setLayoutPosition(float position, ABI50_0_0YGEdge edge);
  void setPosition(
      const Direction direction,
      const float mainSize,
      const float crossSize,
      const float ownerWidth);
  void markDirtyAndPropagateDownwards();

  // Other methods
  ABI50_0_0YGValue marginLeadingValue(const FlexDirection axis) const;
  ABI50_0_0YGValue marginTrailingValue(const FlexDirection axis) const;
  ABI50_0_0YGValue resolveFlexBasisPtr() const;
  void resolveDimension();
  Direction resolveDirection(const Direction ownerDirection);
  void clearChildren();
  /// Replaces the occurrences of oldChild with newChild
  void replaceChild(Node* oldChild, Node* newChild);
  void replaceChild(Node* child, size_t index);
  void insertChild(Node* child, size_t index);
  /// Removes the first occurrence of child
  bool removeChild(Node* child);
  void removeChild(size_t index);

  void cloneChildrenIfNeeded();
  void markDirtyAndPropagate();
  float resolveFlexGrow() const;
  float resolveFlexShrink() const;
  bool isNodeFlexible();
  void reset();
};

inline Node* resolveRef(const ABI50_0_0YGNodeRef ref) {
  return static_cast<Node*>(ref);
}

inline const Node* resolveRef(const ABI50_0_0YGNodeConstRef ref) {
  return static_cast<const Node*>(ref);
}

} // namespace ABI50_0_0facebook::yoga
