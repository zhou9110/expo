/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNode.h>
#include <ABI50_0_0React/renderer/uimanager/ABI50_0_0UIManager.h>
#include <ABI50_0_0React/renderer/uimanager/ABI50_0_0UIManagerCommitHook.h>
#include <vector>
#include "ABI50_0_0MutationObserver.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

class MutationObserverManager final : public UIManagerCommitHook {
 public:
  MutationObserverManager();

  void observe(
      MutationObserverId mutationObserverId,
      ShadowNode::Shared shadowNode,
      bool observeSubtree,
      const UIManager& uiManager);

  void unobserve(
      MutationObserverId mutationObserverId,
      const ShadowNode& shadowNode);

  void connect(
      UIManager& uiManager,
      std::function<void(std::vector<const MutationRecord>&)> onMutations);

  void disconnect(UIManager& uiManager);

#pragma mark - UIManagerCommitHook

  void commitHookWasRegistered(const UIManager& uiManager) noexcept override;
  void commitHookWasUnregistered(const UIManager& uiManager) noexcept override;

  RootShadowNode::Unshared shadowTreeWillCommit(
      const ShadowTree& shadowTree,
      const RootShadowNode::Shared& oldRootShadowNode,
      const RootShadowNode::Unshared& newRootShadowNode) noexcept override;

 private:
  std::unordered_map<
      SurfaceId,
      std::unordered_map<MutationObserverId, MutationObserver>>
      observersBySurfaceId_;

  std::function<void(std::vector<const MutationRecord>&)> onMutations_;
  bool commitHookRegistered_{};

  void runMutationObservations(
      const ShadowTree& shadowTree,
      const RootShadowNode& oldRootShadowNode,
      const RootShadowNode& newRootShadowNode);
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
