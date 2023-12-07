/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>
#import <ABI50_0_0React/renderer/imagemanager/ABI50_0_0ImageRequest.h>

@protocol ABI50_0_0RCTImageManagerProtocol <NSObject>

- (ABI50_0_0facebook::ABI50_0_0React::ImageRequest)requestImage:(ABI50_0_0facebook::ABI50_0_0React::ImageSource)imageSource
                                    surfaceId:(ABI50_0_0facebook::ABI50_0_0React::SurfaceId)surfaceId;
@end
