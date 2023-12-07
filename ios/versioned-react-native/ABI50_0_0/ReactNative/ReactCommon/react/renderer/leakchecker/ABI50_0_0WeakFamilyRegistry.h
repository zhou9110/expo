/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNodeFamily.h>
#include <unordered_map>
#include <vector>

namespace ABI50_0_0facebook::ABI50_0_0React {

class WeakFamilyRegistry final {
 public:
  using WeakFamilies = std::vector<ShadowNodeFamily::Weak>;

  void add(const ShadowNodeFamily::Shared& shadowNodeFamily) const;
  void removeFamiliesWithSurfaceId(SurfaceId surfaceId) const;
  WeakFamilies weakFamiliesForSurfaceId(SurfaceId surfaceId) const;

 private:
  /**
   * Mutex protecting `families_` property.
   */
  mutable std::mutex familiesMutex_;

  /**
   * A map of ShadowNodeFamily used on surface.
   */
  mutable std::unordered_map<SurfaceId, WeakFamilies> families_{};
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
