/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeProxy.h>
#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>
#import <ABI50_0_0React/ABI50_0_0RCTImageCache.h>
#import <ABI50_0_0React/ABI50_0_0RCTImageDataDecoder.h>
#import <ABI50_0_0React/ABI50_0_0RCTImageLoaderLoggable.h>
#import <ABI50_0_0React/ABI50_0_0RCTImageLoaderProtocol.h>
#import <ABI50_0_0React/ABI50_0_0RCTImageURLLoader.h>
#import <ABI50_0_0React/ABI50_0_0RCTResizeMode.h>
#import <ABI50_0_0React/ABI50_0_0RCTURLRequestHandler.h>

@interface ABI50_0_0RCTImageLoader : NSObject <ABI50_0_0RCTBridgeModule, ABI50_0_0RCTImageLoaderProtocol, ABI50_0_0RCTImageLoaderLoggableProtocol>
- (instancetype)init;
- (instancetype)initWithRedirectDelegate:(id<ABI50_0_0RCTImageRedirectProtocol>)redirectDelegate NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithRedirectDelegate:(id<ABI50_0_0RCTImageRedirectProtocol>)redirectDelegate
                         loadersProvider:(NSArray<id<ABI50_0_0RCTImageURLLoader>> * (^)(ABI50_0_0RCTModuleRegistry *))getLoaders
                        decodersProvider:(NSArray<id<ABI50_0_0RCTImageDataDecoder>> * (^)(ABI50_0_0RCTModuleRegistry *))getDecoders;
@end

/**
 * DEPRECATED!! DO NOT USE
 * Instead use `[_bridge moduleForClass:[ABI50_0_0RCTImageLoader class]]`
 */
@interface ABI50_0_0RCTBridge (ABI50_0_0RCTImageLoader)

@property (nonatomic, readonly) ABI50_0_0RCTImageLoader *imageLoader;

@end

@interface ABI50_0_0RCTBridgeProxy (ABI50_0_0RCTImageLoader)

@property (nonatomic, readonly) ABI50_0_0RCTImageLoader *imageLoader;

@end
