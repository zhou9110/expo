/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0TelemetryController.h"

#include <ABI50_0_0React/renderer/mounting/ABI50_0_0MountingCoordinator.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

TelemetryController::TelemetryController(
    const MountingCoordinator& mountingCoordinator) noexcept
    : mountingCoordinator_(mountingCoordinator) {}

bool TelemetryController::pullTransaction(
    const MountingTransactionCallback& willMount,
    const MountingTransactionCallback& doMount,
    const MountingTransactionCallback& didMount) const {
  auto optional = mountingCoordinator_.pullTransaction();
  if (!optional.has_value()) {
    return false;
  }

  auto transaction = std::move(*optional);

  auto& telemetry = transaction.getTelemetry();
  auto numberOfMutations = static_cast<int>(transaction.getMutations().size());

  mutex_.lock();
  auto compoundTelemetry = compoundTelemetry_;
  mutex_.unlock();

  willMount(transaction, compoundTelemetry);

  telemetry.willMount();
  doMount(transaction, compoundTelemetry);
  telemetry.didMount();

  compoundTelemetry.incorporate(telemetry, numberOfMutations);

  didMount(transaction, compoundTelemetry);

  mutex_.lock();
  compoundTelemetry_ = compoundTelemetry;
  mutex_.unlock();

  return true;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
