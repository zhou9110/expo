/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/renderer/imagemanager/ABI50_0_0ImageManager.h>

#import <ABI50_0_0React/ABI50_0_0RCTImageLoaderWithAttributionProtocol.h>
#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>
#import <ABI50_0_0React/utils/ABI50_0_0ManagedObjectWrapper.h>

#import "ABI50_0_0RCTImageManager.h"
#import "ABI50_0_0RCTSyncImageManager.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

ImageManager::ImageManager(const ContextContainer::Shared &contextContainer)
{
  id<ABI50_0_0RCTImageLoaderWithAttributionProtocol> imageLoader =
      (id<ABI50_0_0RCTImageLoaderWithAttributionProtocol>)unwrapManagedObject(
          contextContainer->at<std::shared_ptr<void>>("ABI50_0_0RCTImageLoader"));
  if (ABI50_0_0RCTRunningInTestEnvironment()) {
    self_ = (__bridge_retained void *)[[ABI50_0_0RCTSyncImageManager alloc] initWithImageLoader:imageLoader];
  } else {
    self_ = (__bridge_retained void *)[[ABI50_0_0RCTImageManager alloc] initWithImageLoader:imageLoader];
  }
}

ImageManager::~ImageManager()
{
  CFRelease(self_);
  self_ = nullptr;
}

ImageRequest ImageManager::requestImage(const ImageSource &imageSource, SurfaceId surfaceId) const
{
  ABI50_0_0RCTImageManager *imageManager = (__bridge ABI50_0_0RCTImageManager *)self_;
  return [imageManager requestImage:imageSource surfaceId:surfaceId];
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
