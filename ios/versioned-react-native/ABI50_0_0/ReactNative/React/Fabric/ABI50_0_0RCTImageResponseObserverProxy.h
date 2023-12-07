/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#import "ABI50_0_0RCTImageResponseDelegate.h"

#include <ABI50_0_0React/renderer/imagemanager/ABI50_0_0ImageResponseObserver.h>

NS_ASSUME_NONNULL_BEGIN

namespace ABI50_0_0facebook::ABI50_0_0React {

class ABI50_0_0RCTImageResponseObserverProxy final : public ImageResponseObserver {
 public:
  ABI50_0_0RCTImageResponseObserverProxy(id<ABI50_0_0RCTImageResponseDelegate> delegate = nil);

  void didReceiveImage(const ImageResponse& imageResponse) const override;
  void didReceiveProgress(float progress) const override;
  void didReceiveFailure() const override;

 private:
  __weak id<ABI50_0_0RCTImageResponseDelegate> delegate_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React

NS_ASSUME_NONNULL_END
