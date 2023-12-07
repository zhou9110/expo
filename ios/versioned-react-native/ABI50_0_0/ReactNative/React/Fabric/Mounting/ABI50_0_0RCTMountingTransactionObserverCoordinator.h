/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTComponentViewDescriptor.h>
#import <unordered_map>
#import <unordered_set>

#import "ABI50_0_0RCTMountingTransactionObserverCoordinator.h"

#include <ABI50_0_0React/renderer/mounting/ABI50_0_0MountingTransaction.h>

class ABI50_0_0RCTMountingTransactionObserverCoordinator final {
 public:
  /*
   * Registers (and unregisters) specified `componentViewDescriptor` in the
   * registry of views that need to be notified. Does nothing if a particular
   * `componentViewDescriptor` does not listen the events.
   */
  void registerViewComponentDescriptor(
      const ABI50_0_0RCTComponentViewDescriptor& componentViewDescriptor,
      ABI50_0_0facebook::ABI50_0_0React::SurfaceId surfaceId);
  void unregisterViewComponentDescriptor(
      const ABI50_0_0RCTComponentViewDescriptor& componentViewDescriptor,
      ABI50_0_0facebook::ABI50_0_0React::SurfaceId surfaceId);

  /*
   * To be called from `ABI50_0_0RCTMountingManager`.
   */
  void notifyObserversMountingTransactionWillMount(
      const ABI50_0_0facebook::ABI50_0_0React::MountingTransaction& transaction,
      const ABI50_0_0facebook::ABI50_0_0React::SurfaceTelemetry& surfaceTelemetry) const;
  void notifyObserversMountingTransactionDidMount(
      const ABI50_0_0facebook::ABI50_0_0React::MountingTransaction& transaction,
      const ABI50_0_0facebook::ABI50_0_0React::SurfaceTelemetry& surfaceTelemetry) const;

 private:
  std::unordered_map<
      ABI50_0_0facebook::ABI50_0_0React::SurfaceId,
      std::unordered_set<ABI50_0_0RCTComponentViewDescriptor>>
      registry_;
};
