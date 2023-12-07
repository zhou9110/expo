/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <functional>
#include <mutex>

#include <ABI50_0_0React/renderer/mounting/ABI50_0_0MountingTransaction.h>
#include <ABI50_0_0React/renderer/telemetry/ABI50_0_0TransactionTelemetry.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class MountingCoordinator;

using MountingTransactionCallback = std::function<void(
    const MountingTransaction& transaction,
    const SurfaceTelemetry& surfaceTelemetry)>;

/*
 * Provides convenient tools for aggregating and accessing telemetry data
 * associated with running Surface.
 */
class TelemetryController final {
  friend class MountingCoordinator;

  /*
   * To be used by `MountingCoordinator`.
   */
  TelemetryController(const MountingCoordinator& mountingCoordinator) noexcept;

  /*
   * Not copyable.
   */
  TelemetryController(const TelemetryController& other) noexcept = delete;
  TelemetryController& operator=(const TelemetryController& other) noexcept =
      delete;

 public:
  /*
   * Calls `MountingCoordinator::pullTransaction()` and aggregates telemetry.
   */
  bool pullTransaction(
      const MountingTransactionCallback& willMount,
      const MountingTransactionCallback& doMount,
      const MountingTransactionCallback& didMount) const;

 private:
  const MountingCoordinator& mountingCoordinator_;
  mutable SurfaceTelemetry compoundTelemetry_{};
  mutable std::mutex mutex_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
