/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeModuleDecorator.h>
#import <UIKit/UIKit.h>
#include <folly/dynamic.h>

NS_ASSUME_NONNULL_BEGIN

@class ABI50_0_0RCTComponentData;
@class ABI50_0_0RCTBridge;
@class ABI50_0_0RCTBridgeProxy;

typedef void (^InterceptorBlock)(std::string eventName, folly::dynamic event);

@interface ABI50_0_0RCTLegacyViewManagerInteropCoordinator : NSObject

- (instancetype)initWithComponentData:(ABI50_0_0RCTComponentData *)componentData
                               bridge:(nullable ABI50_0_0RCTBridge *)bridge
                          bridgeProxy:(nullable ABI50_0_0RCTBridgeProxy *)bridgeProxy
                bridgelessInteropData:(ABI50_0_0RCTBridgeModuleDecorator *)bridgelessInteropData;

- (UIView *)createPaperViewWithTag:(NSInteger)tag;

- (void)addObserveForTag:(NSInteger)tag usingBlock:(InterceptorBlock)block;

- (void)removeObserveForTag:(NSInteger)tag;

- (void)setProps:(const folly::dynamic &)props forView:(UIView *)view;

- (NSString *)componentViewName;

- (void)handleCommand:(NSString *)commandName
                 args:(NSArray *)args
             ABI50_0_0ReactTag:(NSInteger)tag
            paperView:(UIView *)paperView;

- (void)removeViewFromRegistryWithTag:(NSInteger)tag;

- (void)addViewToRegistry:(UIView *)view withTag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
