/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0ReactCommon/ABI50_0_0RuntimeExecutor.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNodeFamily.h>
#include <ABI50_0_0React/renderer/leakchecker/ABI50_0_0WeakFamilyRegistry.h>
#include <vector>

namespace ABI50_0_0facebook::ABI50_0_0React {

using GarbageCollectionTrigger = std::function<void()>;

class LeakChecker final {
 public:
  LeakChecker(RuntimeExecutor runtimeExecutor);

  void uiManagerDidCreateShadowNodeFamily(
      const ShadowNodeFamily::Shared& shadowNodeFamily) const;
  void stopSurface(SurfaceId surfaceId);

 private:
  void checkSurfaceForLeaks(SurfaceId surfaceId) const;

  const RuntimeExecutor runtimeExecutor_{};

  WeakFamilyRegistry registry_{};
  SurfaceId previouslyStoppedSurface_{};
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
