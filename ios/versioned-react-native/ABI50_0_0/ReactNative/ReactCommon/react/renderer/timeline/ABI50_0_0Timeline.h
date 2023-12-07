/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>
#include <mutex>
#include <vector>

#include <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>
#include <ABI50_0_0React/renderer/timeline/ABI50_0_0TimelineSnapshot.h>
#include <ABI50_0_0React/renderer/uimanager/ABI50_0_0UIManagerCommitHook.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class UIManager;

class Timeline final {
  friend class TimelineHandler;
  friend class TimelineController;

 public:
  Timeline(const ShadowTree& shadowTree);

 private:
#pragma mark - Private methods to be used by `TimelineHandler`.

  void pause() const noexcept;
  void resume() const noexcept;
  bool isPaused() const noexcept;
  TimelineFrame::List getFrames() const noexcept;
  TimelineFrame getCurrentFrame() const noexcept;
  void rewind(const TimelineFrame& frame) const noexcept;
  SurfaceId getSurfaceId() const noexcept;

#pragma mark - Private methods to be used by `TimelineController`.

  RootShadowNode::Unshared shadowTreeWillCommit(
      const ShadowTree& shadowTree,
      const RootShadowNode::Shared& oldRootShadowNode,
      const RootShadowNode::Unshared& newRootShadowNode) const noexcept;

#pragma mark - Private & Internal

  void record(const RootShadowNode::Shared& rootShadowNode) const noexcept;
  void rewind(const TimelineSnapshot& snapshot) const noexcept;

  mutable std::recursive_mutex mutex_;
  mutable const ShadowTree* shadowTree_{nullptr};
  mutable int currentSnapshotIndex_{0};
  mutable TimelineSnapshot::List snapshots_{};
  mutable bool paused_{false};
  mutable bool rewinding_{false};
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
