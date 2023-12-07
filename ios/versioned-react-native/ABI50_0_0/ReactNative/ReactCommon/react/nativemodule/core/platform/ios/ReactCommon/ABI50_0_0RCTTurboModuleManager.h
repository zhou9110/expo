/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#import <memory>

#import <ABI50_0_0React/ABI50_0_0RCTBridgeModuleDecorator.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeProxy.h>
#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>
#import <ABI50_0_0React/ABI50_0_0RCTTurboModuleRegistry.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RuntimeExecutor.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0TurboModuleBinding.h>
#import "ABI50_0_0RCTTurboModule.h"

@protocol ABI50_0_0RCTTurboModuleManagerDelegate <NSObject>

/**
 * Given a module name, return its actual class. If nil is returned, basic ObjC class lookup is performed.
 */
- (Class)getModuleClassFromName:(const char *)name;

/**
 * Given a module class, provide an instance for it. If nil is returned, default initializer is used.
 */
- (id<ABI50_0_0RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass;

@optional

/**
 * Create an instance of a TurboModule without relying on any ObjC++ module instance.
 */
- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule>)getTurboModule:(const std::string &)name
                                                      jsInvoker:
                                                          (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker>)jsInvoker;

/**
 * Return a pre-initialized list of leagcy native modules.
 * These modules shouldn't be TurboModule-compatible (i.e: they should not conform to ABI50_0_0RCTTurboModule).
 *
 * This method is only used by the TurboModule interop layer.
 *
 * It must match the signature of ABI50_0_0RCTBridgeDelegate extraModulesForBridge:
 * - (NSArray<id<ABI50_0_0RCTBridgeModule>> *)extraModulesForBridge:(ABI50_0_0RCTBridge *)bridge;
 */
- (NSArray<id<ABI50_0_0RCTBridgeModule>> *)extraModulesForBridge:(ABI50_0_0RCTBridge *)bridge
    __attribute((deprecated("Please make all native modules returned from this method TurboModule-compatible.")));

@end

@interface ABI50_0_0RCTTurboModuleManager : NSObject <ABI50_0_0RCTTurboModuleRegistry>

- (instancetype)initWithBridge:(ABI50_0_0RCTBridge *)bridge
                      delegate:(id<ABI50_0_0RCTTurboModuleManagerDelegate>)delegate
                     jsInvoker:(std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker>)jsInvoker;

- (instancetype)initWithBridgeProxy:(ABI50_0_0RCTBridgeProxy *)bridgeProxy
              bridgeModuleDecorator:(ABI50_0_0RCTBridgeModuleDecorator *)bridgeModuleDecorator
                           delegate:(id<ABI50_0_0RCTTurboModuleManagerDelegate>)delegate
                          jsInvoker:(std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker>)jsInvoker;

- (void)installJSBindings:(ABI50_0_0facebook::jsi::Runtime &)runtime;

- (void)invalidate;

@end
