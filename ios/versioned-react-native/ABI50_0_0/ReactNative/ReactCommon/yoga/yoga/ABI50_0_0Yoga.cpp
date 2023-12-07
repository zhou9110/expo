/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <ABI50_0_0yoga/ABI50_0_0Yoga-internal.h>
#include <ABI50_0_0yoga/ABI50_0_0Yoga.h>

#include <ABI50_0_0yoga/algorithm/ABI50_0_0Cache.h>
#include <ABI50_0_0yoga/algorithm/ABI50_0_0CalculateLayout.h>
#include <ABI50_0_0yoga/algorithm/ABI50_0_0PixelGrid.h>
#include <ABI50_0_0yoga/debug/ABI50_0_0AssertFatal.h>
#include <ABI50_0_0yoga/debug/ABI50_0_0Log.h>
#include <ABI50_0_0yoga/debug/ABI50_0_0NodeToString.h>
#include <ABI50_0_0yoga/event/ABI50_0_0event.h>
#include <ABI50_0_0yoga/node/ABI50_0_0Node.h>

using namespace ABI50_0_0facebook;
using namespace ABI50_0_0facebook::yoga;

bool ABI50_0_0YGFloatIsUndefined(const float value) {
  return yoga::isUndefined(value);
}

void* ABI50_0_0YGNodeGetContext(ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getContext();
}

void ABI50_0_0YGNodeSetContext(ABI50_0_0YGNodeRef node, void* context) {
  return resolveRef(node)->setContext(context);
}

ABI50_0_0YGConfigConstRef ABI50_0_0YGNodeGetConfig(ABI50_0_0YGNodeRef node) {
  return resolveRef(node)->getConfig();
}

void ABI50_0_0YGNodeSetConfig(ABI50_0_0YGNodeRef node, ABI50_0_0YGConfigRef config) {
  resolveRef(node)->setConfig(resolveRef(config));
}

bool ABI50_0_0YGNodeHasMeasureFunc(ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->hasMeasureFunc();
}

void ABI50_0_0YGNodeSetMeasureFunc(ABI50_0_0YGNodeRef node, ABI50_0_0YGMeasureFunc measureFunc) {
  resolveRef(node)->setMeasureFunc(measureFunc);
}

bool ABI50_0_0YGNodeHasBaselineFunc(ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->hasBaselineFunc();
}

void ABI50_0_0YGNodeSetBaselineFunc(ABI50_0_0YGNodeRef node, ABI50_0_0YGBaselineFunc baselineFunc) {
  resolveRef(node)->setBaselineFunc(baselineFunc);
}

ABI50_0_0YGDirtiedFunc ABI50_0_0YGNodeGetDirtiedFunc(ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getDirtiedFunc();
}

void ABI50_0_0YGNodeSetDirtiedFunc(ABI50_0_0YGNodeRef node, ABI50_0_0YGDirtiedFunc dirtiedFunc) {
  resolveRef(node)->setDirtiedFunc(dirtiedFunc);
}

void ABI50_0_0YGNodeSetPrintFunc(ABI50_0_0YGNodeRef node, ABI50_0_0YGPrintFunc printFunc) {
  resolveRef(node)->setPrintFunc(printFunc);
}

bool ABI50_0_0YGNodeGetHasNewLayout(ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getHasNewLayout();
}

void ABI50_0_0YGConfigSetPrintTreeFlag(ABI50_0_0YGConfigRef config, bool enabled) {
  resolveRef(config)->setShouldPrintTree(enabled);
}

void ABI50_0_0YGNodeSetHasNewLayout(ABI50_0_0YGNodeRef node, bool hasNewLayout) {
  resolveRef(node)->setHasNewLayout(hasNewLayout);
}

ABI50_0_0YGNodeType ABI50_0_0YGNodeGetNodeType(ABI50_0_0YGNodeConstRef node) {
  return unscopedEnum(resolveRef(node)->getNodeType());
}

void ABI50_0_0YGNodeSetNodeType(ABI50_0_0YGNodeRef node, ABI50_0_0YGNodeType nodeType) {
  return resolveRef(node)->setNodeType(scopedEnum(nodeType));
}

bool ABI50_0_0YGNodeIsDirty(ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->isDirty();
}

void ABI50_0_0YGNodeMarkDirtyAndPropagateToDescendants(const ABI50_0_0YGNodeRef node) {
  return resolveRef(node)->markDirtyAndPropagateDownwards();
}

ABI50_0_0YGNodeRef ABI50_0_0YGNodeNewWithConfig(const ABI50_0_0YGConfigConstRef config) {
  auto* node = new yoga::Node{resolveRef(config)};
  yoga::assertFatal(
      config != nullptr, "Tried to construct ABI50_0_0YGNode with null config");
  Event::publish<Event::NodeAllocation>(node, {config});

  return node;
}

ABI50_0_0YGConfigConstRef ABI50_0_0YGConfigGetDefault() {
  return &yoga::Config::getDefault();
}

ABI50_0_0YGNodeRef ABI50_0_0YGNodeNew(void) {
  return ABI50_0_0YGNodeNewWithConfig(ABI50_0_0YGConfigGetDefault());
}

ABI50_0_0YGNodeRef ABI50_0_0YGNodeClone(ABI50_0_0YGNodeConstRef oldNodeRef) {
  auto oldNode = resolveRef(oldNodeRef);
  const auto node = new yoga::Node(*oldNode);
  yoga::assertFatalWithConfig(
      oldNode->getConfig(),
      node != nullptr,
      "Could not allocate memory for node");
  Event::publish<Event::NodeAllocation>(node, {node->getConfig()});
  node->setOwner(nullptr);
  return node;
}

void ABI50_0_0YGNodeFree(const ABI50_0_0YGNodeRef nodeRef) {
  const auto node = resolveRef(nodeRef);

  if (auto owner = node->getOwner()) {
    owner->removeChild(node);
    node->setOwner(nullptr);
  }

  const size_t childCount = node->getChildCount();
  for (size_t i = 0; i < childCount; i++) {
    auto child = node->getChild(i);
    child->setOwner(nullptr);
  }

  node->clearChildren();
  ABI50_0_0YGNodeDeallocate(node);
}

void ABI50_0_0YGNodeDeallocate(const ABI50_0_0YGNodeRef node) {
  Event::publish<Event::NodeDeallocation>(node, {ABI50_0_0YGNodeGetConfig(node)});
  delete resolveRef(node);
}

void ABI50_0_0YGNodeFreeRecursiveWithCleanupFunc(
    const ABI50_0_0YGNodeRef rootRef,
    ABI50_0_0YGNodeCleanupFunc cleanup) {
  const auto root = resolveRef(rootRef);

  size_t skipped = 0;
  while (root->getChildCount() > skipped) {
    const auto child = root->getChild(skipped);
    if (child->getOwner() != root) {
      // Don't free shared nodes that we don't own.
      skipped += 1;
    } else {
      ABI50_0_0YGNodeRemoveChild(root, child);
      ABI50_0_0YGNodeFreeRecursive(child);
    }
  }
  if (cleanup != nullptr) {
    cleanup(root);
  }
  ABI50_0_0YGNodeFree(root);
}

void ABI50_0_0YGNodeFreeRecursive(const ABI50_0_0YGNodeRef root) {
  return ABI50_0_0YGNodeFreeRecursiveWithCleanupFunc(root, nullptr);
}

void ABI50_0_0YGNodeReset(ABI50_0_0YGNodeRef node) {
  resolveRef(node)->reset();
}

ABI50_0_0YGConfigRef ABI50_0_0YGConfigNew(void) {
  return new yoga::Config(getDefaultLogger());
}

void ABI50_0_0YGConfigFree(const ABI50_0_0YGConfigRef config) {
  delete resolveRef(config);
}

void ABI50_0_0YGNodeSetIsReferenceBaseline(ABI50_0_0YGNodeRef nodeRef, bool isReferenceBaseline) {
  const auto node = resolveRef(nodeRef);
  if (node->isReferenceBaseline() != isReferenceBaseline) {
    node->setIsReferenceBaseline(isReferenceBaseline);
    node->markDirtyAndPropagate();
  }
}

bool ABI50_0_0YGNodeIsReferenceBaseline(ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->isReferenceBaseline();
}

void ABI50_0_0YGNodeInsertChild(
    const ABI50_0_0YGNodeRef ownerRef,
    const ABI50_0_0YGNodeRef childRef,
    const size_t index) {
  auto owner = resolveRef(ownerRef);
  auto child = resolveRef(childRef);

  yoga::assertFatalWithNode(
      owner,
      child->getOwner() == nullptr,
      "Child already has a owner, it must be removed first.");

  yoga::assertFatalWithNode(
      owner,
      !owner->hasMeasureFunc(),
      "Cannot add child: Nodes with measure functions cannot have children.");

  owner->insertChild(child, index);
  child->setOwner(owner);
  owner->markDirtyAndPropagate();
}

void ABI50_0_0YGNodeSwapChild(
    const ABI50_0_0YGNodeRef ownerRef,
    const ABI50_0_0YGNodeRef childRef,
    const size_t index) {
  auto owner = resolveRef(ownerRef);
  auto child = resolveRef(childRef);

  owner->replaceChild(child, index);
  child->setOwner(owner);
}

void ABI50_0_0YGNodeRemoveChild(
    const ABI50_0_0YGNodeRef ownerRef,
    const ABI50_0_0YGNodeRef excludedChildRef) {
  auto owner = resolveRef(ownerRef);
  auto excludedChild = resolveRef(excludedChildRef);

  if (owner->getChildCount() == 0) {
    // This is an empty set. Nothing to remove.
    return;
  }

  // Children may be shared between parents, which is indicated by not having an
  // owner. We only want to reset the child completely if it is owned
  // exclusively by one node.
  auto childOwner = excludedChild->getOwner();
  if (owner->removeChild(excludedChild)) {
    if (owner == childOwner) {
      excludedChild->setLayout({}); // layout is no longer valid
      excludedChild->setOwner(nullptr);
    }
    owner->markDirtyAndPropagate();
  }
}

void ABI50_0_0YGNodeRemoveAllChildren(const ABI50_0_0YGNodeRef ownerRef) {
  auto owner = resolveRef(ownerRef);

  const size_t childCount = owner->getChildCount();
  if (childCount == 0) {
    // This is an empty set already. Nothing to do.
    return;
  }
  auto* firstChild = owner->getChild(0);
  if (firstChild->getOwner() == owner) {
    // If the first child has this node as its owner, we assume that this child
    // set is unique.
    for (size_t i = 0; i < childCount; i++) {
      yoga::Node* oldChild = owner->getChild(i);
      oldChild->setLayout({}); // layout is no longer valid
      oldChild->setOwner(nullptr);
    }
    owner->clearChildren();
    owner->markDirtyAndPropagate();
    return;
  }
  // Otherwise, we are not the owner of the child set. We don't have to do
  // anything to clear it.
  owner->setChildren({});
  owner->markDirtyAndPropagate();
}

void ABI50_0_0YGNodeSetChildren(
    const ABI50_0_0YGNodeRef ownerRef,
    const ABI50_0_0YGNodeRef* childrenRefs,
    const size_t count) {
  auto owner = resolveRef(ownerRef);
  auto children = reinterpret_cast<yoga::Node* const*>(childrenRefs);

  if (!owner) {
    return;
  }

  const std::vector<yoga::Node*> childrenVector = {children, children + count};
  if (childrenVector.size() == 0) {
    if (owner->getChildCount() > 0) {
      for (auto* child : owner->getChildren()) {
        child->setLayout({});
        child->setOwner(nullptr);
      }
      owner->setChildren({});
      owner->markDirtyAndPropagate();
    }
  } else {
    if (owner->getChildCount() > 0) {
      for (auto* oldChild : owner->getChildren()) {
        // Our new children may have nodes in common with the old children. We
        // don't reset these common nodes.
        if (std::find(childrenVector.begin(), childrenVector.end(), oldChild) ==
            childrenVector.end()) {
          oldChild->setLayout({});
          oldChild->setOwner(nullptr);
        }
      }
    }
    owner->setChildren(childrenVector);
    for (yoga::Node* child : childrenVector) {
      child->setOwner(owner);
    }
    owner->markDirtyAndPropagate();
  }
}

ABI50_0_0YGNodeRef ABI50_0_0YGNodeGetChild(const ABI50_0_0YGNodeRef nodeRef, const size_t index) {
  const auto node = resolveRef(nodeRef);

  if (index < node->getChildren().size()) {
    return node->getChild(index);
  }
  return nullptr;
}

size_t ABI50_0_0YGNodeGetChildCount(const ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getChildren().size();
}

ABI50_0_0YGNodeRef ABI50_0_0YGNodeGetOwner(const ABI50_0_0YGNodeRef node) {
  return resolveRef(node)->getOwner();
}

ABI50_0_0YGNodeRef ABI50_0_0YGNodeGetParent(const ABI50_0_0YGNodeRef node) {
  return resolveRef(node)->getOwner();
}

void ABI50_0_0YGNodeMarkDirty(const ABI50_0_0YGNodeRef nodeRef) {
  const auto node = resolveRef(nodeRef);

  yoga::assertFatalWithNode(
      node,
      node->hasMeasureFunc(),
      "Only leaf nodes with custom measure functions "
      "should manually mark themselves as dirty");

  node->markDirtyAndPropagate();
}

void ABI50_0_0YGNodeCopyStyle(
    const ABI50_0_0YGNodeRef dstNodeRef,
    const ABI50_0_0YGNodeConstRef srcNodeRef) {
  auto dstNode = resolveRef(dstNodeRef);
  auto srcNode = resolveRef(srcNodeRef);

  if (!(dstNode->getStyle() == srcNode->getStyle())) {
    dstNode->setStyle(srcNode->getStyle());
    dstNode->markDirtyAndPropagate();
  }
}

float ABI50_0_0YGNodeStyleGetFlexGrow(const ABI50_0_0YGNodeConstRef nodeRef) {
  const auto node = resolveRef(nodeRef);
  return node->getStyle().flexGrow().isUndefined()
      ? Style::DefaultFlexGrow
      : node->getStyle().flexGrow().unwrap();
}

float ABI50_0_0YGNodeStyleGetFlexShrink(const ABI50_0_0YGNodeConstRef nodeRef) {
  const auto node = resolveRef(nodeRef);
  return node->getStyle().flexShrink().isUndefined()
      ? (node->getConfig()->useWebDefaults() ? Style::WebDefaultFlexShrink
                                             : Style::DefaultFlexShrink)
      : node->getStyle().flexShrink().unwrap();
}

namespace {

template <typename T, typename NeedsUpdate, typename Update>
void updateStyle(
    yoga::Node* node,
    T value,
    NeedsUpdate&& needsUpdate,
    Update&& update) {
  if (needsUpdate(node->getStyle(), value)) {
    update(node->getStyle(), value);
    node->markDirtyAndPropagate();
  }
}

template <typename Ref, typename T>
void updateStyle(ABI50_0_0YGNodeRef node, Ref (Style::*prop)(), T value) {
  updateStyle(
      resolveRef(node),
      value,
      [prop](Style& s, T x) { return (s.*prop)() != x; },
      [prop](Style& s, T x) { (s.*prop)() = x; });
}

template <typename Ref, typename Idx>
void updateIndexedStyleProp(
    ABI50_0_0YGNodeRef node,
    Ref (Style::*prop)(),
    Idx idx,
    CompactValue value) {
  updateStyle(
      resolveRef(node),
      value,
      [idx, prop](Style& s, CompactValue x) { return (s.*prop)()[idx] != x; },
      [idx, prop](Style& s, CompactValue x) { (s.*prop)()[idx] = x; });
}

template <auto GetterT, auto SetterT, typename IdxT>
void updateIndexedStyleProp(ABI50_0_0YGNodeRef node, IdxT idx, CompactValue value) {
  updateStyle(
      resolveRef(node),
      value,
      [idx](Style& s, CompactValue x) { return (s.*GetterT)(idx) != x; },
      [idx](Style& s, CompactValue x) { (s.*SetterT)(idx, x); });
}

} // namespace

// MSVC has trouble inferring the return type of pointer to member functions
// with const and non-const overloads, instead of preferring the non-const
// overload like clang and GCC. For the purposes of updateStyle(), we can help
// MSVC by specifying that return type explicitly. In combination with
// decltype, MSVC will prefer the non-const version.
#define MSVC_HINT(PROP) decltype(Style{}.PROP())

void ABI50_0_0YGNodeStyleSetDirection(const ABI50_0_0YGNodeRef node, const ABI50_0_0YGDirection value) {
  updateStyle<MSVC_HINT(direction)>(node, &Style::direction, scopedEnum(value));
}
ABI50_0_0YGDirection ABI50_0_0YGNodeStyleGetDirection(const ABI50_0_0YGNodeConstRef node) {
  return unscopedEnum(resolveRef(node)->getStyle().direction());
}

void ABI50_0_0YGNodeStyleSetFlexDirection(
    const ABI50_0_0YGNodeRef node,
    const ABI50_0_0YGFlexDirection flexDirection) {
  updateStyle<MSVC_HINT(flexDirection)>(
      node, &Style::flexDirection, scopedEnum(flexDirection));
}
ABI50_0_0YGFlexDirection ABI50_0_0YGNodeStyleGetFlexDirection(const ABI50_0_0YGNodeConstRef node) {
  return unscopedEnum(resolveRef(node)->getStyle().flexDirection());
}

void ABI50_0_0YGNodeStyleSetJustifyContent(
    const ABI50_0_0YGNodeRef node,
    const ABI50_0_0YGJustify justifyContent) {
  updateStyle<MSVC_HINT(justifyContent)>(
      node, &Style::justifyContent, scopedEnum(justifyContent));
}
ABI50_0_0YGJustify ABI50_0_0YGNodeStyleGetJustifyContent(const ABI50_0_0YGNodeConstRef node) {
  return unscopedEnum(resolveRef(node)->getStyle().justifyContent());
}

void ABI50_0_0YGNodeStyleSetAlignContent(
    const ABI50_0_0YGNodeRef node,
    const ABI50_0_0YGAlign alignContent) {
  updateStyle<MSVC_HINT(alignContent)>(
      node, &Style::alignContent, scopedEnum(alignContent));
}
ABI50_0_0YGAlign ABI50_0_0YGNodeStyleGetAlignContent(const ABI50_0_0YGNodeConstRef node) {
  return unscopedEnum(resolveRef(node)->getStyle().alignContent());
}

void ABI50_0_0YGNodeStyleSetAlignItems(const ABI50_0_0YGNodeRef node, const ABI50_0_0YGAlign alignItems) {
  updateStyle<MSVC_HINT(alignItems)>(
      node, &Style::alignItems, scopedEnum(alignItems));
}
ABI50_0_0YGAlign ABI50_0_0YGNodeStyleGetAlignItems(const ABI50_0_0YGNodeConstRef node) {
  return unscopedEnum(resolveRef(node)->getStyle().alignItems());
}

void ABI50_0_0YGNodeStyleSetAlignSelf(const ABI50_0_0YGNodeRef node, const ABI50_0_0YGAlign alignSelf) {
  updateStyle<MSVC_HINT(alignSelf)>(
      node, &Style::alignSelf, scopedEnum(alignSelf));
}
ABI50_0_0YGAlign ABI50_0_0YGNodeStyleGetAlignSelf(const ABI50_0_0YGNodeConstRef node) {
  return unscopedEnum(resolveRef(node)->getStyle().alignSelf());
}

void ABI50_0_0YGNodeStyleSetPositionType(
    const ABI50_0_0YGNodeRef node,
    const ABI50_0_0YGPositionType positionType) {
  updateStyle<MSVC_HINT(positionType)>(
      node, &Style::positionType, scopedEnum(positionType));
}
ABI50_0_0YGPositionType ABI50_0_0YGNodeStyleGetPositionType(const ABI50_0_0YGNodeConstRef node) {
  return unscopedEnum(resolveRef(node)->getStyle().positionType());
}

void ABI50_0_0YGNodeStyleSetFlexWrap(const ABI50_0_0YGNodeRef node, const ABI50_0_0YGWrap flexWrap) {
  updateStyle<MSVC_HINT(flexWrap)>(
      node, &Style::flexWrap, scopedEnum(flexWrap));
}
ABI50_0_0YGWrap ABI50_0_0YGNodeStyleGetFlexWrap(const ABI50_0_0YGNodeConstRef node) {
  return unscopedEnum(resolveRef(node)->getStyle().flexWrap());
}

void ABI50_0_0YGNodeStyleSetOverflow(const ABI50_0_0YGNodeRef node, const ABI50_0_0YGOverflow overflow) {
  updateStyle<MSVC_HINT(overflow)>(
      node, &Style::overflow, scopedEnum(overflow));
}
ABI50_0_0YGOverflow ABI50_0_0YGNodeStyleGetOverflow(const ABI50_0_0YGNodeConstRef node) {
  return unscopedEnum(resolveRef(node)->getStyle().overflow());
}

void ABI50_0_0YGNodeStyleSetDisplay(const ABI50_0_0YGNodeRef node, const ABI50_0_0YGDisplay display) {
  updateStyle<MSVC_HINT(display)>(node, &Style::display, scopedEnum(display));
}
ABI50_0_0YGDisplay ABI50_0_0YGNodeStyleGetDisplay(const ABI50_0_0YGNodeConstRef node) {
  return unscopedEnum(resolveRef(node)->getStyle().display());
}

void ABI50_0_0YGNodeStyleSetFlex(const ABI50_0_0YGNodeRef node, const float flex) {
  updateStyle<MSVC_HINT(flex)>(node, &Style::flex, FloatOptional{flex});
}

float ABI50_0_0YGNodeStyleGetFlex(const ABI50_0_0YGNodeConstRef nodeRef) {
  const auto node = resolveRef(nodeRef);
  return node->getStyle().flex().isUndefined()
      ? ABI50_0_0YGUndefined
      : node->getStyle().flex().unwrap();
}

void ABI50_0_0YGNodeStyleSetFlexGrow(const ABI50_0_0YGNodeRef node, const float flexGrow) {
  updateStyle<MSVC_HINT(flexGrow)>(
      node, &Style::flexGrow, FloatOptional{flexGrow});
}

void ABI50_0_0YGNodeStyleSetFlexShrink(const ABI50_0_0YGNodeRef node, const float flexShrink) {
  updateStyle<MSVC_HINT(flexShrink)>(
      node, &Style::flexShrink, FloatOptional{flexShrink});
}

ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetFlexBasis(const ABI50_0_0YGNodeConstRef node) {
  ABI50_0_0YGValue flexBasis = resolveRef(node)->getStyle().flexBasis();
  if (flexBasis.unit == ABI50_0_0YGUnitUndefined || flexBasis.unit == ABI50_0_0YGUnitAuto) {
    flexBasis.value = ABI50_0_0YGUndefined;
  }
  return flexBasis;
}

void ABI50_0_0YGNodeStyleSetFlexBasis(const ABI50_0_0YGNodeRef node, const float flexBasis) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPoint>(flexBasis);
  updateStyle<MSVC_HINT(flexBasis)>(node, &Style::flexBasis, value);
}

void ABI50_0_0YGNodeStyleSetFlexBasisPercent(
    const ABI50_0_0YGNodeRef node,
    const float flexBasisPercent) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPercent>(flexBasisPercent);
  updateStyle<MSVC_HINT(flexBasis)>(node, &Style::flexBasis, value);
}

void ABI50_0_0YGNodeStyleSetFlexBasisAuto(const ABI50_0_0YGNodeRef node) {
  updateStyle<MSVC_HINT(flexBasis)>(
      node, &Style::flexBasis, CompactValue::ofAuto());
}

void ABI50_0_0YGNodeStyleSetPosition(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float points) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPoint>(points);
  updateIndexedStyleProp<MSVC_HINT(position)>(
      node, &Style::position, edge, value);
}
void ABI50_0_0YGNodeStyleSetPositionPercent(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float percent) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPercent>(percent);
  updateIndexedStyleProp<MSVC_HINT(position)>(
      node, &Style::position, edge, value);
}
ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetPosition(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge) {
  return resolveRef(node)->getStyle().position()[edge];
}

void ABI50_0_0YGNodeStyleSetMargin(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float points) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPoint>(points);
  updateIndexedStyleProp<MSVC_HINT(margin)>(node, &Style::margin, edge, value);
}
void ABI50_0_0YGNodeStyleSetMarginPercent(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float percent) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPercent>(percent);
  updateIndexedStyleProp<MSVC_HINT(margin)>(node, &Style::margin, edge, value);
}
void ABI50_0_0YGNodeStyleSetMarginAuto(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge) {
  updateIndexedStyleProp<MSVC_HINT(margin)>(
      node, &Style::margin, edge, CompactValue::ofAuto());
}
ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetMargin(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge) {
  return resolveRef(node)->getStyle().margin()[edge];
}

void ABI50_0_0YGNodeStyleSetPadding(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float points) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPoint>(points);
  updateIndexedStyleProp<MSVC_HINT(padding)>(
      node, &Style::padding, edge, value);
}
void ABI50_0_0YGNodeStyleSetPaddingPercent(ABI50_0_0YGNodeRef node, ABI50_0_0YGEdge edge, float percent) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPercent>(percent);
  updateIndexedStyleProp<MSVC_HINT(padding)>(
      node, &Style::padding, edge, value);
}
ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetPadding(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge) {
  return resolveRef(node)->getStyle().padding()[edge];
}

void ABI50_0_0YGNodeStyleSetBorder(
    const ABI50_0_0YGNodeRef node,
    const ABI50_0_0YGEdge edge,
    const float border) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPoint>(border);
  updateIndexedStyleProp<MSVC_HINT(border)>(node, &Style::border, edge, value);
}

float ABI50_0_0YGNodeStyleGetBorder(const ABI50_0_0YGNodeConstRef node, const ABI50_0_0YGEdge edge) {
  auto border = resolveRef(node)->getStyle().border()[edge];
  if (border.isUndefined() || border.isAuto()) {
    return ABI50_0_0YGUndefined;
  }

  return static_cast<ABI50_0_0YGValue>(border).value;
}

void ABI50_0_0YGNodeStyleSetGap(
    const ABI50_0_0YGNodeRef node,
    const ABI50_0_0YGGutter gutter,
    const float gapLength) {
  auto length = CompactValue::ofMaybe<ABI50_0_0YGUnitPoint>(gapLength);
  updateIndexedStyleProp<MSVC_HINT(gap)>(node, &Style::gap, gutter, length);
}

float ABI50_0_0YGNodeStyleGetGap(const ABI50_0_0YGNodeConstRef node, const ABI50_0_0YGGutter gutter) {
  auto gapLength = resolveRef(node)->getStyle().gap()[gutter];
  if (gapLength.isUndefined() || gapLength.isAuto()) {
    return ABI50_0_0YGUndefined;
  }

  return static_cast<ABI50_0_0YGValue>(gapLength).value;
}

// Yoga specific properties, not compatible with flexbox specification

float ABI50_0_0YGNodeStyleGetAspectRatio(const ABI50_0_0YGNodeConstRef node) {
  const FloatOptional op = resolveRef(node)->getStyle().aspectRatio();
  return op.isUndefined() ? ABI50_0_0YGUndefined : op.unwrap();
}

void ABI50_0_0YGNodeStyleSetAspectRatio(const ABI50_0_0YGNodeRef node, const float aspectRatio) {
  updateStyle<MSVC_HINT(aspectRatio)>(
      node, &Style::aspectRatio, FloatOptional{aspectRatio});
}

void ABI50_0_0YGNodeStyleSetWidth(ABI50_0_0YGNodeRef node, float points) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPoint>(points);
  updateIndexedStyleProp<&Style::dimension, &Style::setDimension>(
      node, ABI50_0_0YGDimensionWidth, value);
}
void ABI50_0_0YGNodeStyleSetWidthPercent(ABI50_0_0YGNodeRef node, float percent) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPercent>(percent);
  updateIndexedStyleProp<&Style::dimension, &Style::setDimension>(
      node, ABI50_0_0YGDimensionWidth, value);
}
void ABI50_0_0YGNodeStyleSetWidthAuto(ABI50_0_0YGNodeRef node) {
  updateIndexedStyleProp<&Style::dimension, &Style::setDimension>(
      node, ABI50_0_0YGDimensionWidth, CompactValue::ofAuto());
}
ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetWidth(ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getStyle().dimension(ABI50_0_0YGDimensionWidth);
}

void ABI50_0_0YGNodeStyleSetHeight(ABI50_0_0YGNodeRef node, float points) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPoint>(points);
  updateIndexedStyleProp<&Style::dimension, &Style::setDimension>(
      node, ABI50_0_0YGDimensionHeight, value);
}
void ABI50_0_0YGNodeStyleSetHeightPercent(ABI50_0_0YGNodeRef node, float percent) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPercent>(percent);
  updateIndexedStyleProp<&Style::dimension, &Style::setDimension>(
      node, ABI50_0_0YGDimensionHeight, value);
}
void ABI50_0_0YGNodeStyleSetHeightAuto(ABI50_0_0YGNodeRef node) {
  updateIndexedStyleProp<&Style::dimension, &Style::setDimension>(
      node, ABI50_0_0YGDimensionHeight, CompactValue::ofAuto());
}
ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetHeight(ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getStyle().dimension(ABI50_0_0YGDimensionHeight);
}

void ABI50_0_0YGNodeStyleSetMinWidth(const ABI50_0_0YGNodeRef node, const float minWidth) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPoint>(minWidth);
  updateIndexedStyleProp<&Style::minDimension, &Style::setMinDimension>(
      node, ABI50_0_0YGDimensionWidth, value);
}
void ABI50_0_0YGNodeStyleSetMinWidthPercent(const ABI50_0_0YGNodeRef node, const float minWidth) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPercent>(minWidth);
  updateIndexedStyleProp<&Style::minDimension, &Style::setMinDimension>(
      node, ABI50_0_0YGDimensionWidth, value);
}
ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetMinWidth(const ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getStyle().minDimension(ABI50_0_0YGDimensionWidth);
}

void ABI50_0_0YGNodeStyleSetMinHeight(const ABI50_0_0YGNodeRef node, const float minHeight) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPoint>(minHeight);
  updateIndexedStyleProp<&Style::minDimension, &Style::setMinDimension>(
      node, ABI50_0_0YGDimensionHeight, value);
}
void ABI50_0_0YGNodeStyleSetMinHeightPercent(
    const ABI50_0_0YGNodeRef node,
    const float minHeight) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPercent>(minHeight);
  updateIndexedStyleProp<&Style::minDimension, &Style::setMinDimension>(
      node, ABI50_0_0YGDimensionHeight, value);
}
ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetMinHeight(const ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getStyle().minDimension(ABI50_0_0YGDimensionHeight);
}

void ABI50_0_0YGNodeStyleSetMaxWidth(const ABI50_0_0YGNodeRef node, const float maxWidth) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPoint>(maxWidth);
  updateIndexedStyleProp<&Style::maxDimension, &Style::setMaxDimension>(
      node, ABI50_0_0YGDimensionWidth, value);
}
void ABI50_0_0YGNodeStyleSetMaxWidthPercent(const ABI50_0_0YGNodeRef node, const float maxWidth) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPercent>(maxWidth);
  updateIndexedStyleProp<&Style::maxDimension, &Style::setMaxDimension>(
      node, ABI50_0_0YGDimensionWidth, value);
}
ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetMaxWidth(const ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getStyle().maxDimension(ABI50_0_0YGDimensionWidth);
}

void ABI50_0_0YGNodeStyleSetMaxHeight(const ABI50_0_0YGNodeRef node, const float maxHeight) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPoint>(maxHeight);
  updateIndexedStyleProp<&Style::maxDimension, &Style::setMaxDimension>(
      node, ABI50_0_0YGDimensionHeight, value);
}
void ABI50_0_0YGNodeStyleSetMaxHeightPercent(
    const ABI50_0_0YGNodeRef node,
    const float maxHeight) {
  auto value = CompactValue::ofMaybe<ABI50_0_0YGUnitPercent>(maxHeight);
  updateIndexedStyleProp<&Style::maxDimension, &Style::setMaxDimension>(
      node, ABI50_0_0YGDimensionHeight, value);
}
ABI50_0_0YGValue ABI50_0_0YGNodeStyleGetMaxHeight(const ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getStyle().maxDimension(ABI50_0_0YGDimensionHeight);
}

namespace {

template <auto LayoutMember>
float getResolvedLayoutProperty(
    const ABI50_0_0YGNodeConstRef nodeRef,
    const ABI50_0_0YGEdge edge) {
  const auto node = resolveRef(nodeRef);
  yoga::assertFatalWithNode(
      node,
      edge <= ABI50_0_0YGEdgeEnd,
      "Cannot get layout properties of multi-edge shorthands");

  if (edge == ABI50_0_0YGEdgeStart) {
    if (node->getLayout().direction() == Direction::RTL) {
      return (node->getLayout().*LayoutMember)[ABI50_0_0YGEdgeRight];
    } else {
      return (node->getLayout().*LayoutMember)[ABI50_0_0YGEdgeLeft];
    }
  }

  if (edge == ABI50_0_0YGEdgeEnd) {
    if (node->getLayout().direction() == Direction::RTL) {
      return (node->getLayout().*LayoutMember)[ABI50_0_0YGEdgeLeft];
    } else {
      return (node->getLayout().*LayoutMember)[ABI50_0_0YGEdgeRight];
    }
  }

  return (node->getLayout().*LayoutMember)[edge];
}

} // namespace

float ABI50_0_0YGNodeLayoutGetLeft(const ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getLayout().position[ABI50_0_0YGEdgeLeft];
}

float ABI50_0_0YGNodeLayoutGetTop(const ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getLayout().position[ABI50_0_0YGEdgeTop];
}

float ABI50_0_0YGNodeLayoutGetRight(const ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getLayout().position[ABI50_0_0YGEdgeRight];
}

float ABI50_0_0YGNodeLayoutGetBottom(const ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getLayout().position[ABI50_0_0YGEdgeBottom];
}

float ABI50_0_0YGNodeLayoutGetWidth(const ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getLayout().dimension(ABI50_0_0YGDimensionWidth);
}

float ABI50_0_0YGNodeLayoutGetHeight(const ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getLayout().dimension(ABI50_0_0YGDimensionHeight);
}

ABI50_0_0YGDirection ABI50_0_0YGNodeLayoutGetDirection(const ABI50_0_0YGNodeConstRef node) {
  return unscopedEnum(resolveRef(node)->getLayout().direction());
}

bool ABI50_0_0YGNodeLayoutGetHadOverflow(const ABI50_0_0YGNodeConstRef node) {
  return resolveRef(node)->getLayout().hadOverflow();
}

float ABI50_0_0YGNodeLayoutGetMargin(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge) {
  return getResolvedLayoutProperty<&LayoutResults::margin>(node, edge);
}

float ABI50_0_0YGNodeLayoutGetBorder(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge) {
  return getResolvedLayoutProperty<&LayoutResults::border>(node, edge);
}

float ABI50_0_0YGNodeLayoutGetPadding(ABI50_0_0YGNodeConstRef node, ABI50_0_0YGEdge edge) {
  return getResolvedLayoutProperty<&LayoutResults::padding>(node, edge);
}

#ifdef DEBUG
void ABI50_0_0YGNodePrint(const ABI50_0_0YGNodeConstRef node, const ABI50_0_0YGPrintOptions options) {
  yoga::print(resolveRef(node), scopedEnum(options));
}
#endif

void ABI50_0_0YGConfigSetLogger(const ABI50_0_0YGConfigRef config, ABI50_0_0YGLogger logger) {
  if (logger != nullptr) {
    resolveRef(config)->setLogger(logger);
  } else {
    resolveRef(config)->setLogger(getDefaultLogger());
  }
}

void ABI50_0_0YGConfigSetPointScaleFactor(
    const ABI50_0_0YGConfigRef config,
    const float pixelsInPoint) {
  yoga::assertFatalWithConfig(
      resolveRef(config),
      pixelsInPoint >= 0.0f,
      "Scale factor should not be less than zero");

  // We store points for Pixel as we will use it for rounding
  if (pixelsInPoint == 0.0f) {
    // Zero is used to skip rounding
    resolveRef(config)->setPointScaleFactor(0.0f);
  } else {
    resolveRef(config)->setPointScaleFactor(pixelsInPoint);
  }
}

float ABI50_0_0YGConfigGetPointScaleFactor(const ABI50_0_0YGConfigConstRef config) {
  return resolveRef(config)->getPointScaleFactor();
}

float ABI50_0_0YGRoundValueToPixelGrid(
    const double value,
    const double pointScaleFactor,
    const bool forceCeil,
    const bool forceFloor) {
  return yoga::roundValueToPixelGrid(
      value, pointScaleFactor, forceCeil, forceFloor);
}

void ABI50_0_0YGConfigSetExperimentalFeatureEnabled(
    const ABI50_0_0YGConfigRef config,
    const ABI50_0_0YGExperimentalFeature feature,
    const bool enabled) {
  resolveRef(config)->setExperimentalFeatureEnabled(
      scopedEnum(feature), enabled);
}

bool ABI50_0_0YGConfigIsExperimentalFeatureEnabled(
    const ABI50_0_0YGConfigConstRef config,
    const ABI50_0_0YGExperimentalFeature feature) {
  return resolveRef(config)->isExperimentalFeatureEnabled(scopedEnum(feature));
}

void ABI50_0_0YGConfigSetUseWebDefaults(const ABI50_0_0YGConfigRef config, const bool enabled) {
  resolveRef(config)->setUseWebDefaults(enabled);
}

bool ABI50_0_0YGConfigGetUseWebDefaults(const ABI50_0_0YGConfigConstRef config) {
  return resolveRef(config)->useWebDefaults();
}

void ABI50_0_0YGConfigSetContext(const ABI50_0_0YGConfigRef config, void* context) {
  resolveRef(config)->setContext(context);
}

void* ABI50_0_0YGConfigGetContext(const ABI50_0_0YGConfigConstRef config) {
  return resolveRef(config)->getContext();
}

void ABI50_0_0YGConfigSetErrata(ABI50_0_0YGConfigRef config, ABI50_0_0YGErrata errata) {
  resolveRef(config)->setErrata(scopedEnum(errata));
}

ABI50_0_0YGErrata ABI50_0_0YGConfigGetErrata(ABI50_0_0YGConfigConstRef config) {
  return unscopedEnum(resolveRef(config)->getErrata());
}

void ABI50_0_0YGConfigSetCloneNodeFunc(
    const ABI50_0_0YGConfigRef config,
    const ABI50_0_0YGCloneNodeFunc callback) {
  resolveRef(config)->setCloneNodeCallback(callback);
}

// TODO: This should not be part of the public API. Remove after removing
// ComponentKit usage of it.
bool ABI50_0_0YGNodeCanUseCachedMeasurement(
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
    ABI50_0_0YGConfigRef config) {
  return yoga::canUseCachedMeasurement(
      scopedEnum(widthMode),
      availableWidth,
      scopedEnum(heightMode),
      availableHeight,
      scopedEnum(lastWidthMode),
      lastAvailableWidth,
      scopedEnum(lastHeightMode),
      lastAvailableHeight,
      lastComputedWidth,
      lastComputedHeight,
      marginRow,
      marginColumn,
      resolveRef(config));
}

void ABI50_0_0YGNodeCalculateLayout(
    const ABI50_0_0YGNodeRef node,
    const float ownerWidth,
    const float ownerHeight,
    const ABI50_0_0YGDirection ownerDirection) {
  yoga::calculateLayout(
      resolveRef(node), ownerWidth, ownerHeight, scopedEnum(ownerDirection));
}
