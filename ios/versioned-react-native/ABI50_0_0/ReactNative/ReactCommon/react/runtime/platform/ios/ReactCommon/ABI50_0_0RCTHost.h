/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>
#import <ABI50_0_0React/runtime/ABI50_0_0JSEngineInstance.h>

#import "ABI50_0_0RCTInstance.h"

NS_ASSUME_NONNULL_BEGIN

@class ABI50_0_0RCTFabricSurface;
@class ABI50_0_0RCTHost;
@class ABI50_0_0RCTModuleRegistry;

@protocol ABI50_0_0RCTTurboModuleManagerDelegate;

// Runtime API

@protocol ABI50_0_0RCTHostDelegate <NSObject>

- (void)host:(ABI50_0_0RCTHost *)host
    didReceiveJSErrorStack:(NSArray<NSDictionary<NSString *, id> *> *)stack
                   message:(NSString *)message
               exceptionId:(NSUInteger)exceptionId
                   isFatal:(BOOL)isFatal;

- (void)hostDidStart:(ABI50_0_0RCTHost *)host;

@end

@protocol ABI50_0_0RCTHostRuntimeDelegate <NSObject>

- (void)host:(ABI50_0_0RCTHost *)host didInitializeRuntime:(ABI50_0_0facebook::jsi::Runtime &)runtime;

@end

typedef std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::JSEngineInstance> (^ABI50_0_0RCTHostJSEngineProvider)(void);

@interface ABI50_0_0RCTHost : NSObject

- (instancetype)initWithBundleURL:(NSURL *)bundleURL
                     hostDelegate:(id<ABI50_0_0RCTHostDelegate>)hostDelegate
       turboModuleManagerDelegate:(id<ABI50_0_0RCTTurboModuleManagerDelegate>)turboModuleManagerDelegate
                 jsEngineProvider:(ABI50_0_0RCTHostJSEngineProvider)jsEngineProvider NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak, nullable) id<ABI50_0_0RCTHostRuntimeDelegate> runtimeDelegate;

- (void)start;

- (void)callFunctionOnJSModule:(NSString *)moduleName method:(NSString *)method args:(NSArray *)args;

// Renderer API

- (ABI50_0_0RCTFabricSurface *)createSurfaceWithModuleName:(NSString *)moduleName
                                             mode:(ABI50_0_0facebook::ABI50_0_0React::DisplayMode)displayMode
                                initialProperties:(NSDictionary *)properties;

- (ABI50_0_0RCTFabricSurface *)createSurfaceWithModuleName:(NSString *)moduleName initialProperties:(NSDictionary *)properties;

- (ABI50_0_0RCTSurfacePresenter *)getSurfacePresenter;

// Native module API

- (ABI50_0_0RCTModuleRegistry *)getModuleRegistry;

@end

NS_ASSUME_NONNULL_END
