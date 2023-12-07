/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/root/ABI50_0_0RootShadowNode.h>
#include <ABI50_0_0React/renderer/mounting/ABI50_0_0MountingOverrideDelegate.h>
#include <ABI50_0_0React/renderer/mounting/ABI50_0_0MountingTransaction.h>
#include <ABI50_0_0React/renderer/mounting/ABI50_0_0ShadowViewMutation.h>
#include <ABI50_0_0React/renderer/telemetry/ABI50_0_0TransactionTelemetry.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Represent a particular committed state of a shadow tree. The object contains
 * a pointer to a root shadow node, a sequential number of commit and telemetry.
 */
class ShadowTreeRevision final {
 public:
  /*
   * Sequential number of the commit that created this revision of a shadow
   * tree.
   */
  using Number = int64_t;

  friend class ShadowTree;
  friend class MountingCoordinator;

  RootShadowNode::Shared rootShadowNode;
  Number number;
  TransactionTelemetry telemetry;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
