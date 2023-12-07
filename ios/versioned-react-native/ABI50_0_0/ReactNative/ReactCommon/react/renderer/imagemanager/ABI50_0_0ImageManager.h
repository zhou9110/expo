/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>

#include <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>
#include <ABI50_0_0React/renderer/imagemanager/ABI50_0_0ImageRequest.h>
#include <ABI50_0_0React/renderer/imagemanager/ABI50_0_0primitives.h>
#include <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class ImageManager;

using SharedImageManager = std::shared_ptr<ImageManager>;

/*
 * Cross platform facade for iOS-specific ABI50_0_0RCTImageManager.
 */
class ImageManager {
 public:
  ImageManager(const ContextContainer::Shared& contextContainer);
  ~ImageManager();

  ImageRequest requestImage(const ImageSource& imageSource, SurfaceId surfaceId)
      const;

 private:
  void* self_{};
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
