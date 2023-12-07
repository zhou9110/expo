/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/root/ABI50_0_0RootShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNode.h>
#include <memory>
#include <utility>

namespace ABI50_0_0facebook::ABI50_0_0React {

using MutationObserverId = int32_t;

struct MutationRecord {
  MutationObserverId mutationObserverId;
  ShadowNode::Shared targetShadowNode;
  std::vector<ShadowNode::Shared> addedShadowNodes;
  std::vector<ShadowNode::Shared> removedShadowNodes;
};

class MutationObserver {
 public:
  MutationObserver(MutationObserverId intersectionObserverId);

  void observe(ShadowNode::Shared targetShadowNode, bool observeSubtree);
  void unobserve(const ShadowNode& targetShadowNode);

  bool isObserving() const;

  void recordMutations(
      const RootShadowNode& oldRootShadowNode,
      const RootShadowNode& newRootShadowNode,
      std::vector<const MutationRecord>& recordedMutations) const;

 private:
  MutationObserverId mutationObserverId_;
  std::vector<ShadowNode::Shared> deeplyObservedShadowNodes_;
  std::vector<ShadowNode::Shared> shallowlyObservedShadowNodes_;

  using SetOfShadowNodePointers = std::unordered_set<const ShadowNode*>;

  void recordMutationsInTarget(
      ShadowNode::Shared targetShadowNode,
      const RootShadowNode& oldRootShadowNode,
      const RootShadowNode& newRootShadowNode,
      bool observeSubtree,
      std::vector<const MutationRecord>& recordedMutations,
      SetOfShadowNodePointers& processedNodes) const;

  void recordMutationsInSubtrees(
      ShadowNode::Shared targetShadowNode,
      const ShadowNode& oldNode,
      const ShadowNode& newNode,
      bool observeSubtree,
      std::vector<const MutationRecord>& recordedMutations,
      SetOfShadowNodePointers processedNodes) const;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
