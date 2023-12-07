/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/root/ABI50_0_0RootShadowNode.h>
#include "ABI50_0_0UIManager.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

class ShadowTree;
class UIManager;

/*
 * Implementing a mount hook allows to observe Shadow Trees being mounted in
 * the host platform.
 */
class UIManagerMountHook {
 public:
  /*
   * Called right after a `ShadowTree` is mounted in the host platform.
   */
  virtual void shadowTreeDidMount(
      const RootShadowNode::Shared& rootShadowNode,
      double mountTime) noexcept = 0;

  virtual ~UIManagerMountHook() noexcept = default;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
