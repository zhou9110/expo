/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/root/ABI50_0_0RootShadowNode.h>
#include <ABI50_0_0React/renderer/timeline/ABI50_0_0TimelineFrame.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Represents a reference to a commit from the past used by `Timeline`.
 */
class TimelineSnapshot final {
 public:
  using List = std::vector<TimelineSnapshot>;

  TimelineSnapshot(RootShadowNode::Shared rootShadowNode, int index) noexcept;

  TimelineFrame getFrame() const noexcept;
  RootShadowNode::Shared getRootShadowNode() const noexcept;

 private:
  RootShadowNode::Shared rootShadowNode_;
  TimelineFrame frame_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
