/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTBundleAssetImageLoader.h>

#import <atomic>
#import <memory>

#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTTurboModule.h>

#import "ABI50_0_0RCTImagePlugins.h"

@interface ABI50_0_0RCTBundleAssetImageLoader () <ABI50_0_0RCTTurboModule>
@end

@implementation ABI50_0_0RCTBundleAssetImageLoader

ABI50_0_0RCT_EXPORT_MODULE()

- (BOOL)canLoadImageURL:(NSURL *)requestURL
{
  return ABI50_0_0RCTIsBundleAssetURL(requestURL);
}

- (BOOL)requiresScheduling
{
  // Don't schedule this loader on the URL queue so we can load the
  // local assets synchronously to avoid flickers.
  return NO;
}

- (BOOL)shouldCacheLoadedImages
{
  // UIImage imageNamed handles the caching automatically so we don't want
  // to add it to the image cache.
  return NO;
}

- (nullable ABI50_0_0RCTImageLoaderCancellationBlock)loadImageForURL:(NSURL *)imageURL
                                                       size:(CGSize)size
                                                      scale:(CGFloat)scale
                                                 resizeMode:(ABI50_0_0RCTResizeMode)resizeMode
                                            progressHandler:(ABI50_0_0RCTImageLoaderProgressBlock)progressHandler
                                         partialLoadHandler:(ABI50_0_0RCTImageLoaderPartialLoadBlock)partialLoadHandler
                                          completionHandler:(ABI50_0_0RCTImageLoaderCompletionBlock)completionHandler
{
  UIImage *image = ABI50_0_0RCTImageFromLocalAssetURL(imageURL);
  if (image) {
    if (progressHandler) {
      progressHandler(1, 1);
    }
    completionHandler(nil, image);
  } else {
    NSString *message = [NSString stringWithFormat:@"Could not find image %@", imageURL];
    ABI50_0_0RCTLogWarn(@"%@", message);
    completionHandler(ABI50_0_0RCTErrorWithMessage(message), nil);
  }

  return nil;
}

- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule>)getTurboModule:
    (const ABI50_0_0facebook::ABI50_0_0React::ObjCTurboModule::InitParams &)params
{
  return nullptr;
}

- (float)loaderPriority
{
  return 1;
}

@end

Class ABI50_0_0RCTBundleAssetImageLoaderCls(void)
{
  return ABI50_0_0RCTBundleAssetImageLoader.class;
}
