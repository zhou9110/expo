/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class SurfaceRegistryBinding final {
 public:
  SurfaceRegistryBinding() = delete;

  /*
   * Starts ABI50_0_0React Native Surface with given id, moduleName, and props.
   * Thread synchronization must be enforced externally.
   */
  static void startSurface(
      jsi::Runtime& runtime,
      SurfaceId surfaceId,
      const std::string& moduleName,
      const folly::dynamic& initialProps,
      DisplayMode displayMode);

  /*
   * Updates the ABI50_0_0React Native Surface identified with surfaceId and moduleName
   * with the given props.
   * Thread synchronization must be enforced externally.
   */
  static void setSurfaceProps(
      jsi::Runtime& runtime,
      SurfaceId surfaceId,
      const std::string& moduleName,
      const folly::dynamic& initialProps,
      DisplayMode displayMode);

  /*
   * Stops ABI50_0_0React Native Surface with given id.
   * Thread synchronization must be enforced externally.
   */
  static void stopSurface(jsi::Runtime& runtime, SurfaceId surfaceId);
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
