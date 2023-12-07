/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTComponentViewDescriptor.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponentViewProtocol.h>
#import <ABI50_0_0jsi/ABI50_0_0jsi.h>
#import <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorRegistry.h>

NS_ASSUME_NONNULL_BEGIN

void ABI50_0_0RCTInstallNativeComponentRegistryBinding(ABI50_0_0facebook::jsi::Runtime &runtime);

/**
 * Protocol that can be implemented to provide some 3rd party components to Fabric.
 * Fabric will check in this map whether there are some components that need to be registered.
 */
@protocol ABI50_0_0RCTComponentViewFactoryComponentProvider <NSObject>

/**
 * Return a dictionary of third party components where the `key` is the Component Handler and the `value` is a Class
 * that conforms to `ABI50_0_0RCTComponentViewProtocol`.
 */
- (NSDictionary<NSString *, Class<ABI50_0_0RCTComponentViewProtocol>> *)thirdPartyFabricComponents;

@end

/**
 * Registry of supported component view classes that can instantiate
 * view component instances by given component handle.
 */
@interface ABI50_0_0RCTComponentViewFactory : NSObject

@property (nonatomic, weak) id<ABI50_0_0RCTComponentViewFactoryComponentProvider> thirdPartyFabricComponentsProvider;

/**
 * Constructs and returns an instance of the class with a bunch of already registered standard components.
 */
+ (ABI50_0_0RCTComponentViewFactory *)currentComponentViewFactory;

/**
 * Registers a component view class in the factory.
 */
- (void)registerComponentViewClass:(Class<ABI50_0_0RCTComponentViewProtocol>)componentViewClass;

/**
 * Registers component if there is a matching class. Returns true if it matching class is found or the component has
 * already been registered, false otherwise.
 */
- (BOOL)registerComponentIfPossible:(const std::string &)componentName;

/**
 * Creates a component view with given component handle.
 */
- (ABI50_0_0RCTComponentViewDescriptor)createComponentViewWithComponentHandle:(ABI50_0_0facebook::ABI50_0_0React::ComponentHandle)componentHandle;

/**
 * Creates *managed* `ComponentDescriptorRegistry`. After creation, the object continues to store a weak pointer to the
 * registry and update it accordingly to the changes in the object.
 */
- (ABI50_0_0facebook::ABI50_0_0React::ComponentDescriptorRegistry::Shared)createComponentDescriptorRegistryWithParameters:
    (ABI50_0_0facebook::ABI50_0_0React::ComponentDescriptorParameters)parameters;

@end

NS_ASSUME_NONNULL_END
