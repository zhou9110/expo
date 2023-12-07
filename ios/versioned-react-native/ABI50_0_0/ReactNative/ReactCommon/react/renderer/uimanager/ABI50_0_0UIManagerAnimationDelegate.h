/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorFactory.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0RawValue.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class UIManagerAnimationDelegate {
 public:
  virtual ~UIManagerAnimationDelegate() = default;

  /*
   * Configure a LayoutAnimation.
   * TODO: need SurfaceId here
   */
  virtual void uiManagerDidConfigureNextLayoutAnimation(
      jsi::Runtime& runtime,
      const RawValue& config,
      const jsi::Value& successCallback,
      const jsi::Value& failureCallback) const = 0;

  /**
   * Set ComponentDescriptor registry.
   *
   * @param componentDescriptorRegistry
   */
  virtual void setComponentDescriptorRegistry(
      const SharedComponentDescriptorRegistry& componentDescriptorRegistry) = 0;

  /**
   * Set Animation flags for dropping delete and create mutations
   *
   * @param reduceDeleteCreateMutation
   */
  virtual void setReduceDeleteCreateMutation(
      bool reduceDeleteCreateMutation) = 0;

  /**
   * Only needed on Android to drive animations.
   */
  virtual bool shouldAnimateFrame() const = 0;

  /**
   * Drop any animations for a given surface.
   */
  virtual void stopSurface(SurfaceId surfaceId) = 0;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
