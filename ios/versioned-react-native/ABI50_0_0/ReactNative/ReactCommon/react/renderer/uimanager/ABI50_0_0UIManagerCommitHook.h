/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/root/ABI50_0_0RootShadowNode.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class ShadowTree;
class UIManager;

/*
 * Implementing a commit hook allows to observe and alter Shadow Tree commits.
 */
class UIManagerCommitHook {
 public:
  /*
   * Called right after the commit hook is registered or unregistered.
   */
  virtual void commitHookWasRegistered(const UIManager& uiManager) noexcept = 0;
  virtual void commitHookWasUnregistered(
      const UIManager& uiManager) noexcept = 0;

  /*
   * Called right before a `ShadowTree` commits a new tree.
   * The semantic of the method corresponds to a method of the same name
   * from `ShadowTreeDelegate`.
   */
  virtual RootShadowNode::Unshared shadowTreeWillCommit(
      const ShadowTree& shadowTree,
      const RootShadowNode::Shared& oldRootShadowNode,
      const RootShadowNode::Unshared& newRootShadowNode) noexcept = 0;

  virtual ~UIManagerCommitHook() noexcept = default;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
