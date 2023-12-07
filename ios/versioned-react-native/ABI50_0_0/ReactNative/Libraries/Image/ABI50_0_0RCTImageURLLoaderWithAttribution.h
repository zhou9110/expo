/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTImageLoaderLoggable.h>
#import <ABI50_0_0React/ABI50_0_0RCTImageLoaderProtocol.h>
#import <ABI50_0_0React/ABI50_0_0RCTImageURLLoader.h>

// TODO (T61325135): Remove C++ checks
#ifdef __cplusplus
namespace ABI50_0_0facebook::ABI50_0_0React {

struct ImageURLLoaderAttribution {
  int32_t nativeViewTag = 0;
  int32_t surfaceId = 0;
  std::string queryRootName;
  NSString *analyticTag;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
#endif

@interface ABI50_0_0RCTImageURLLoaderRequest : NSObject

@property (nonatomic, strong, readonly) NSString *requestId;
@property (nonatomic, strong, readonly) NSURL *imageURL;
@property (nonatomic, copy, readonly) ABI50_0_0RCTImageLoaderCancellationBlock cancellationBlock;

- (instancetype)initWithRequestId:(NSString *)requestId
                         imageURL:(NSURL *)imageURL
                cancellationBlock:(ABI50_0_0RCTImageLoaderCancellationBlock)cancellationBlock;
- (void)cancel;

@end

/**
 * Same as the ABI50_0_0RCTImageURLLoader interface, but allows passing in optional `attribution` information.
 * This is useful for per-app logging and other instrumentation.
 */
@protocol ABI50_0_0RCTImageURLLoaderWithAttribution <ABI50_0_0RCTImageURLLoader, ABI50_0_0RCTImageLoaderLoggable>

// TODO (T61325135): Remove C++ checks
#ifdef __cplusplus
/**
 * Same as the ABI50_0_0RCTImageURLLoader variant above, but allows optional `attribution` information.
 * Caller may also specify a preferred requestId for tracking purpose.
 */
- (ABI50_0_0RCTImageURLLoaderRequest *)loadImageForURL:(NSURL *)imageURL
                                         size:(CGSize)size
                                        scale:(CGFloat)scale
                                   resizeMode:(ABI50_0_0RCTResizeMode)resizeMode
                                    requestId:(NSString *)requestId
                                     priority:(ABI50_0_0RCTImageLoaderPriority)priority
                                  attribution:(const ABI50_0_0facebook::ABI50_0_0React::ImageURLLoaderAttribution &)attribution
                              progressHandler:(ABI50_0_0RCTImageLoaderProgressBlock)progressHandler
                           partialLoadHandler:(ABI50_0_0RCTImageLoaderPartialLoadBlock)partialLoadHandler
                            completionHandler:(ABI50_0_0RCTImageLoaderCompletionBlockWithMetadata)completionHandler;
#endif

/**
 * Image instrumentation - start tracking the on-screen visibility of the native image view.
 */
- (void)trackURLImageVisibilityForRequest:(ABI50_0_0RCTImageURLLoaderRequest *)loaderRequest imageView:(UIView *)imageView;

/**
 * Image instrumentation - notify that the request was destroyed.
 */
- (void)trackURLImageRequestDidDestroy:(ABI50_0_0RCTImageURLLoaderRequest *)loaderRequest;

/**
 * Image instrumentation - notify that the native image view was destroyed.
 */
- (void)trackURLImageDidDestroy:(ABI50_0_0RCTImageURLLoaderRequest *)loaderRequest;

@end
