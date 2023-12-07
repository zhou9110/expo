/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTMountingTransactionObserverCoordinator.h"

#import "ABI50_0_0RCTMountingTransactionObserving.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

void ABI50_0_0RCTMountingTransactionObserverCoordinator::registerViewComponentDescriptor(
    const ABI50_0_0RCTComponentViewDescriptor &componentViewDescriptor,
    SurfaceId surfaceId)
{
  if (!componentViewDescriptor.observesMountingTransactionWillMount &&
      !componentViewDescriptor.observesMountingTransactionDidMount) {
    return;
  }

  auto &surfaceRegistry = registry_[surfaceId];
  assert(surfaceRegistry.count(componentViewDescriptor) == 0);
  surfaceRegistry.insert(componentViewDescriptor);
}

void ABI50_0_0RCTMountingTransactionObserverCoordinator::unregisterViewComponentDescriptor(
    const ABI50_0_0RCTComponentViewDescriptor &componentViewDescriptor,
    SurfaceId surfaceId)
{
  if (!componentViewDescriptor.observesMountingTransactionWillMount &&
      !componentViewDescriptor.observesMountingTransactionDidMount) {
    return;
  }

  auto &surfaceRegistry = registry_[surfaceId];
  assert(surfaceRegistry.count(componentViewDescriptor) == 1);
  surfaceRegistry.erase(componentViewDescriptor);
}

void ABI50_0_0RCTMountingTransactionObserverCoordinator::notifyObserversMountingTransactionWillMount(
    const MountingTransaction &transaction,
    const SurfaceTelemetry &surfaceTelemetry) const
{
  auto surfaceId = transaction.getSurfaceId();
  auto surfaceRegistryIterator = registry_.find(surfaceId);
  if (surfaceRegistryIterator == registry_.end()) {
    return;
  }
  auto &surfaceRegistry = surfaceRegistryIterator->second;
  for (const auto &componentViewDescriptor : surfaceRegistry) {
    if (componentViewDescriptor.observesMountingTransactionWillMount) {
      [(id<ABI50_0_0RCTMountingTransactionObserving>)componentViewDescriptor.view mountingTransactionWillMount:transaction
                                                                                 withSurfaceTelemetry:surfaceTelemetry];
    }
  }
}

void ABI50_0_0RCTMountingTransactionObserverCoordinator::notifyObserversMountingTransactionDidMount(
    const MountingTransaction &transaction,
    const SurfaceTelemetry &surfaceTelemetry) const
{
  auto surfaceId = transaction.getSurfaceId();
  auto surfaceRegistryIterator = registry_.find(surfaceId);
  if (surfaceRegistryIterator == registry_.end()) {
    return;
  }
  auto &surfaceRegistry = surfaceRegistryIterator->second;
  for (const auto &componentViewDescriptor : surfaceRegistry) {
    if (componentViewDescriptor.observesMountingTransactionDidMount) {
      [(id<ABI50_0_0RCTMountingTransactionObserving>)componentViewDescriptor.view mountingTransactionDidMount:transaction
                                                                                withSurfaceTelemetry:surfaceTelemetry];
    }
  }
}
