/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTImageResponseObserverProxy.h"

#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>
#import <ABI50_0_0React/renderer/imagemanager/ABI50_0_0ImageResponse.h>
#import <ABI50_0_0React/renderer/imagemanager/ABI50_0_0ImageResponseObserver.h>
#import <ABI50_0_0React/utils/ABI50_0_0ManagedObjectWrapper.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

ABI50_0_0RCTImageResponseObserverProxy::ABI50_0_0RCTImageResponseObserverProxy(id<ABI50_0_0RCTImageResponseDelegate> delegate)
    : delegate_(delegate)
{
}

void ABI50_0_0RCTImageResponseObserverProxy::didReceiveImage(const ImageResponse &imageResponse) const
{
  UIImage *image = (UIImage *)unwrapManagedObject(imageResponse.getImage());
  id metadata = unwrapManagedObject(imageResponse.getMetadata());
  id<ABI50_0_0RCTImageResponseDelegate> delegate = delegate_;
  auto this_ = this;
  ABI50_0_0RCTExecuteOnMainQueue(^{
    [delegate didReceiveImage:image metadata:metadata fromObserver:this_];
  });
}

void ABI50_0_0RCTImageResponseObserverProxy::didReceiveProgress(float progress) const
{
  auto this_ = this;
  id<ABI50_0_0RCTImageResponseDelegate> delegate = delegate_;
  ABI50_0_0RCTExecuteOnMainQueue(^{
    [delegate didReceiveProgress:progress fromObserver:this_];
  });
}

void ABI50_0_0RCTImageResponseObserverProxy::didReceiveFailure() const
{
  auto this_ = this;
  id<ABI50_0_0RCTImageResponseDelegate> delegate = delegate_;
  ABI50_0_0RCTExecuteOnMainQueue(^{
    [delegate didReceiveFailureFromObserver:this_];
  });
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
