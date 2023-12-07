/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>

#include <ABI50_0_0React/renderer/components/root/ABI50_0_0RootComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/root/ABI50_0_0RootShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutConstraints.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNode.h>
#include <ABI50_0_0React/renderer/mounting/ABI50_0_0MountingCoordinator.h>
#include <ABI50_0_0React/renderer/mounting/ABI50_0_0ShadowTreeDelegate.h>
#include <ABI50_0_0React/renderer/mounting/ABI50_0_0ShadowTreeRevision.h>
#include <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>
#include "ABI50_0_0MountingOverrideDelegate.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

using ShadowTreeCommitTransaction = std::function<RootShadowNode::Unshared(
    const RootShadowNode& oldRootShadowNode)>;

/*
 * Represents the shadow tree and its lifecycle.
 */
class ShadowTree final {
 public:
  using Unique = std::unique_ptr<ShadowTree>;

  /*
   * Represents a result of a `commit` operation.
   */
  enum class CommitStatus {
    Succeeded,
    Failed,
    Cancelled,
  };

  /*
   * Represents commits' side-effects propagation mode.
   */
  enum class CommitMode {
    // Commits' side-effects are observable via `MountingCoordinator`.
    // The rendering pipeline fully works end-to-end.
    Normal,

    // Commits' side-effects are *not* observable via `MountingCoordinator`.
    // The mounting phase is skipped in the rendering pipeline.
    Suspended,
  };

  struct CommitOptions {
    // When set to true, Shadow Node state from current revision will be applied
    // to the new revision. For more details see
    // https://ABI50_0_0Reactnative.dev/architecture/render-pipeline#ABI50_0_0React-native-renderer-state-updates
    bool enableStateReconciliation{false};

    // Indicates if mounting will be triggered synchronously and ABI50_0_0React will
    // not get a chance to interrupt painting.
    // This should be set to `false` when a commit is coming from ABI50_0_0React. It
    // will then let ABI50_0_0React run layout effects and apply updates before paint.
    // For all other commits, should be true.
    bool mountSynchronously{true};

    // Called during `tryCommit` phase. Returning true indicates current commit
    // should yield to the next commit.
    std::function<bool()> shouldYield;
  };

  /*
   * Creates a new shadow tree instance.
   */
  ShadowTree(
      SurfaceId surfaceId,
      const LayoutConstraints& layoutConstraints,
      const LayoutContext& layoutContext,
      const ShadowTreeDelegate& delegate,
      const ContextContainer& contextContainer);

  ~ShadowTree();

  /*
   * Returns the `SurfaceId` associated with the shadow tree.
   */
  SurfaceId getSurfaceId() const;

  /*
   * Sets and gets the commit mode.
   * Changing commit mode from `Suspended` to `Normal` will flush all suspended
   * changes to `MountingCoordinator`.
   */
  void setCommitMode(CommitMode commitMode) const;
  CommitMode getCommitMode() const;

  /*
   * Performs commit calling `transaction` function with a `oldRootShadowNode`
   * and expecting a `newRootShadowNode` as a return value.
   * The `transaction` function can cancel commit returning `nullptr`.
   */
  CommitStatus tryCommit(
      const ShadowTreeCommitTransaction& transaction,
      const CommitOptions& commitOptions) const;

  /*
   * Calls `tryCommit` in a loop until it finishes successfully.
   */
  CommitStatus commit(
      const ShadowTreeCommitTransaction& transaction,
      const CommitOptions& commitOptions) const;

  /*
   * Returns a `ShadowTreeRevision` representing the momentary state of
   * the `ShadowTree`.
   */
  ShadowTreeRevision getCurrentRevision() const;

  /*
   * Commit an empty tree (a new `RootShadowNode` with no children).
   */
  void commitEmptyTree() const;

  /**
   * Forces the ShadowTree to ping its delegate that an update is available.
   * Useful for animations on Android.
   * @return
   */
  void notifyDelegatesOfUpdates() const;

  MountingCoordinator::Shared getMountingCoordinator() const;

 private:
  constexpr static ShadowTreeRevision::Number INITIAL_REVISION{0};

  void mount(ShadowTreeRevision revision, bool mountSynchronously) const;

  void emitLayoutEvents(
      std::vector<const LayoutableShadowNode*>& affectedLayoutableNodes) const;

  const SurfaceId surfaceId_;
  const ShadowTreeDelegate& delegate_;
  mutable std::shared_mutex commitMutex_;
  mutable CommitMode commitMode_{
      CommitMode::Normal}; // Protected by `commitMutex_`.
  mutable ShadowTreeRevision currentRevision_; // Protected by `commitMutex_`.
  mutable ShadowTreeRevision::Number
      lastRevisionNumberWithNewState_; // Protected by `commitMutex_`.
  MountingCoordinator::Shared mountingCoordinator_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
