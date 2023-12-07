/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <memory>

#import <ABI50_0_0React/ABI50_0_0RCTBridgeDelegate.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class JSExecutorFactory;

} // namespace ABI50_0_0facebook::ABI50_0_0React

// This is a separate class so non-C++ implementations don't need to
// take a C++ dependency.

@protocol ABI50_0_0RCTCxxBridgeDelegate <ABI50_0_0RCTBridgeDelegate>

/**
 * In the ABI50_0_0RCTCxxBridge, if this method is implemented, return a
 * ExecutorFactory instance which can be used to create the executor.
 * If not implemented, or returns an empty pointer, JSIExecutorFactory
 * will be used with a JSCRuntime.
 */
- (void *)jsExecutorFactoryForBridge:(ABI50_0_0RCTBridge *)bridge;

@end

@protocol ABI50_0_0RCTCxxBridgeTurboModuleDelegate <ABI50_0_0RCTBridgeDelegate>

/**
 * The ABI50_0_0RCTCxxBridgeDelegate used outside of the Expo Go.
 */
- (std::unique_ptr<ABI50_0_0facebook::ABI50_0_0React::JSExecutorFactory>)jsExecutorFactoryForBridge:(ABI50_0_0RCTBridge *)bridge;

@end
