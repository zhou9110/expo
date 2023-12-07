/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridgeDelegate.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeModuleDecorator.h>
#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>
#import <ABI50_0_0React/ABI50_0_0RCTFrameUpdate.h>
#import <ABI50_0_0React/ABI50_0_0RCTInvalidating.h>

#import "ABI50_0_0RCTBridgeConstants.h"
#import "ABI50_0_0RCTConstants.h"

@class JSValue;
@class ABI50_0_0RCTBridge;
@class ABI50_0_0RCTPerformanceLogger;

/**
 * This block can be used to instantiate modules that require additional
 * init parameters, or additional configuration prior to being used.
 * The bridge will call this block to instantiate the modules, and will
 * be responsible for invalidating/releasing them when the bridge is destroyed.
 * For this reason, the block should always return new module instances, and
 * module instances should not be shared between bridges.
 */
typedef NSArray<id<ABI50_0_0RCTBridgeModule>> * (^ABI50_0_0RCTBridgeModuleListProvider)(void);

/**
 * This function returns the module name for a given class.
 */
ABI50_0_0RCT_EXTERN NSString *ABI50_0_0RCTBridgeModuleNameForClass(Class bridgeModuleClass);

/**
 * Experimental.
 * Check/set if JSI-bound NativeModule is enabled. By default it's off.
 */
ABI50_0_0RCT_EXTERN BOOL ABI50_0_0RCTTurboModuleEnabled(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTEnableTurboModule(BOOL enabled);

// Turn on TurboModule interop
ABI50_0_0RCT_EXTERN BOOL ABI50_0_0RCTTurboModuleInteropEnabled(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTEnableTurboModuleInterop(BOOL enabled);

// Turn on TurboModule interop's Bridge proxy
ABI50_0_0RCT_EXTERN BOOL ABI50_0_0RCTTurboModuleInteropBridgeProxyEnabled(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTEnableTurboModuleInteropBridgeProxy(BOOL enabled);

typedef enum {
  kABI50_0_0RCTBridgeProxyLoggingLevelNone,
  kABI50_0_0RCTBridgeProxyLoggingLevelWarning,
  kABI50_0_0RCTBridgeProxyLoggingLevelError,
} ABI50_0_0RCTBridgeProxyLoggingLevel;

ABI50_0_0RCT_EXTERN ABI50_0_0RCTBridgeProxyLoggingLevel ABI50_0_0RCTTurboModuleInteropBridgeProxyLogLevel(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTSetTurboModuleInteropBridgeProxyLogLevel(ABI50_0_0RCTBridgeProxyLoggingLevel logLevel);

// Route all TurboModules through TurboModule interop
ABI50_0_0RCT_EXTERN BOOL ABI50_0_0RCTTurboModuleInteropForAllTurboModulesEnabled(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTEnableTurboModuleInteropForAllTurboModules(BOOL enabled);

typedef enum {
  kABI50_0_0RCTGlobalScope,
  kABI50_0_0RCTGlobalScopeUsingRetainJSCallback,
  kABI50_0_0RCTTurboModuleManagerScope,
} ABI50_0_0RCTTurboModuleCleanupMode;

ABI50_0_0RCT_EXTERN ABI50_0_0RCTTurboModuleCleanupMode ABI50_0_0RCTGetTurboModuleCleanupMode(void);
ABI50_0_0RCT_EXTERN void ABI50_0_0RCTSetTurboModuleCleanupMode(ABI50_0_0RCTTurboModuleCleanupMode mode);

/**
 * Async batched bridge used to communicate with the JavaScript application.
 */
@interface ABI50_0_0RCTBridge : NSObject <ABI50_0_0RCTInvalidating>

/**
 * Creates a new bridge with a custom ABI50_0_0RCTBridgeDelegate.
 *
 * All the interaction with the JavaScript context should be done using the bridge
 * instance of the ABI50_0_0RCTBridgeModules. Modules will be automatically instantiated
 * using the default constructor, but you can optionally pass in an array of
 * pre-initialized module instances if they require additional init parameters
 * or configuration.
 */
- (instancetype)initWithDelegate:(id<ABI50_0_0RCTBridgeDelegate>)delegate launchOptions:(NSDictionary *)launchOptions;

/**
 * DEPRECATED: Use initWithDelegate:launchOptions: instead
 *
 * The designated initializer. This creates a new bridge on top of the specified
 * executor. The bridge should then be used for all subsequent communication
 * with the JavaScript code running in the executor. Modules will be automatically
 * instantiated using the default constructor, but you can optionally pass in an
 * array of pre-initialized module instances if they require additional init
 * parameters or configuration.
 */
- (instancetype)initWithBundleURL:(NSURL *)bundleURL
                   moduleProvider:(ABI50_0_0RCTBridgeModuleListProvider)block
                    launchOptions:(NSDictionary *)launchOptions;

/**
 * This method is used to call functions in the JavaScript application context.
 * It is primarily intended for use by modules that require two-way communication
 * with the JavaScript code. Safe to call from any thread.
 */
- (void)enqueueJSCall:(NSString *)moduleDotMethod args:(NSArray *)args;
- (void)enqueueJSCall:(NSString *)module
               method:(NSString *)method
                 args:(NSArray *)args
           completion:(dispatch_block_t)completion;

/**
 * This method registers the file path of an additional JS segment by its ID.
 *
 * @experimental
 */
- (void)registerSegmentWithId:(NSUInteger)segmentId path:(NSString *)path;

/**
 * Retrieve a bridge module instance by name or class. Note that modules are
 * lazily instantiated, so calling these methods for the first time with a given
 * module name/class may cause the class to be synchronously instantiated,
 * potentially blocking both the calling thread and main thread for a short time.
 *
 * Note: This method does NOT lazily load the particular module if it's not yet loaded.
 */
- (id)moduleForName:(NSString *)moduleName;
- (id)moduleForName:(NSString *)moduleName lazilyLoadIfNecessary:(BOOL)lazilyLoad;
// Note: This method lazily load the module as necessary.
- (id)moduleForClass:(Class)moduleClass;

/**
 * When a NativeModule performs a lookup for a TurboModule, we need to query
 * the TurboModuleRegistry.
 */
- (void)setABI50_0_0RCTTurboModuleRegistry:(id<ABI50_0_0RCTTurboModuleRegistry>)turboModuleRegistry;

/**
 * This hook is called by the TurboModule infra with every ObjC module that's created.
 * It allows the bridge to attach properties to ObjC modules that give those modules
 * access to Bridge APIs.
 */
- (ABI50_0_0RCTBridgeModuleDecorator *)bridgeModuleDecorator;

/**
 * Convenience method for retrieving all modules conforming to a given protocol.
 * Modules will be synchronously instantiated if they haven't already been,
 * potentially blocking both the calling thread and main thread for a short time.
 */
- (NSArray *)modulesConformingToProtocol:(Protocol *)protocol;

/**
 * Test if a module has been initialized. Use this prior to calling
 * `moduleForClass:` or `moduleForName:` if you do not want to cause the module
 * to be instantiated if it hasn't been already.
 */
- (BOOL)moduleIsInitialized:(Class)moduleClass;

/**
 * All registered bridge module classes.
 */
@property (nonatomic, copy, readonly) NSArray<Class> *moduleClasses;

/**
 * URL of the script that was loaded into the bridge.
 */
@property (nonatomic, strong, readonly) NSURL *bundleURL;

/**
 * The class of the executor currently being used. Changes to this value will
 * take effect after the bridge is reloaded.
 */
@property (nonatomic, strong) Class executorClass;

/**
 * The delegate provided during the bridge initialization
 */
@property (nonatomic, weak, readonly) id<ABI50_0_0RCTBridgeDelegate> delegate;

/**
 * The launch options that were used to initialize the bridge.
 */
@property (nonatomic, copy, readonly) NSDictionary *launchOptions;

/**
 * Use this to check if the bridge is currently loading.
 */
@property (nonatomic, readonly, getter=isLoading) BOOL loading;

/**
 * Use this to check if the bridge has been invalidated.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

/**
 * Link to the Performance Logger that logs ABI50_0_0React Native perf events.
 */
@property (nonatomic, readonly, strong) ABI50_0_0RCTPerformanceLogger *performanceLogger;

/**
 * Reload the bundle and reset executor & modules. Safe to call from any thread.
 */
- (void)reload __deprecated_msg("Use ABI50_0_0RCTReloadCommand instead");

/**
 * Reload the bundle and reset executor & modules. Safe to call from any thread.
 */
- (void)reloadWithReason:(NSString *)reason __deprecated_msg("Use ABI50_0_0RCTReloadCommand instead");

/**
 * Handle notifications for a fast refresh. Safe to call from any thread.
 */
- (void)onFastRefresh;

/**
 * Inform the bridge, and anything subscribing to it, that it should reload.
 */
- (void)requestReload __deprecated_msg("Use ABI50_0_0RCTReloadCommand instead");

/**
 * Says whether bridge has started receiving calls from JavaScript.
 */
- (BOOL)isBatchActive;

@end
