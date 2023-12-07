/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTBridgeProxy.h"
#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTLog.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import <ABI50_0_0jsi/ABI50_0_0jsi.h>

using namespace ABI50_0_0facebook;

@interface ABI50_0_0RCTUIManagerProxy : NSProxy
- (instancetype)initWithViewRegistry:(ABI50_0_0RCTViewRegistry *)viewRegistry NS_DESIGNATED_INITIALIZER;

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel;
- (void)forwardInvocation:(NSInvocation *)invocation;
@end

@implementation ABI50_0_0RCTBridgeProxy {
  ABI50_0_0RCTUIManagerProxy *_uiManagerProxy;
  ABI50_0_0RCTModuleRegistry *_moduleRegistry;
  ABI50_0_0RCTBundleManager *_bundleManager;
  ABI50_0_0RCTCallableJSModules *_callableJSModules;
  void (^_dispatchToJSThread)(dispatch_block_t);
  void (^_registerSegmentWithId)(NSNumber *, NSString *);
}

- (instancetype)initWithViewRegistry:(ABI50_0_0RCTViewRegistry *)viewRegistry
                      moduleRegistry:(ABI50_0_0RCTModuleRegistry *)moduleRegistry
                       bundleManager:(ABI50_0_0RCTBundleManager *)bundleManager
                   callableJSModules:(ABI50_0_0RCTCallableJSModules *)callableJSModules
                  dispatchToJSThread:(void (^)(dispatch_block_t))dispatchToJSThread
               registerSegmentWithId:(void (^)(NSNumber *, NSString *))registerSegmentWithId
{
  self = [super self];
  if (self) {
    self->_uiManagerProxy = [[ABI50_0_0RCTUIManagerProxy alloc] initWithViewRegistry:viewRegistry];
    self->_moduleRegistry = moduleRegistry;
    self->_bundleManager = bundleManager;
    self->_callableJSModules = callableJSModules;
    self->_dispatchToJSThread = dispatchToJSThread;
    self->_registerSegmentWithId = registerSegmentWithId;
  }
  return self;
}

- (void)dispatchBlock:(dispatch_block_t)block queue:(dispatch_queue_t)queue
{
  [self logWarning:@"Please migrate to dispatchToJSThread: @synthesize dispatchToJSThread = _dispatchToJSThread"
               cmd:_cmd];

  if (queue == ABI50_0_0RCTJSThread) {
    _dispatchToJSThread(block);
  } else if (queue) {
    dispatch_async(queue, block);
  }
}

/**
 * Used By:
 *  - ABI50_0_0RCTDevSettings
 */
- (Class)executorClass
{
  [self logWarning:@"This method is unsupported. Returning nil." cmd:_cmd];
  return nil;
}

/**
 * Used By:
 *  - ABI50_0_0RCTBlobCollector
 */
- (jsi::Runtime *)runtime
{
  [self logWarning:@"This method is unsupported. Returning nullptr." cmd:_cmd];
  return nullptr;
}

/**
 * ABI50_0_0RCTModuleRegistry
 */
- (id)moduleForName:(NSString *)moduleName
{
  [self logWarning:@"Please migrate to ABI50_0_0RCTModuleRegistry: @synthesize moduleRegistry = _moduleRegistry." cmd:_cmd];
  return [_moduleRegistry moduleForName:[moduleName UTF8String]];
}

- (id)moduleForName:(NSString *)moduleName lazilyLoadIfNecessary:(BOOL)lazilyLoad
{
  [self logWarning:@"Please migrate to ABI50_0_0RCTModuleRegistry: @synthesize moduleRegistry = _moduleRegistry." cmd:_cmd];
  return [_moduleRegistry moduleForName:[moduleName UTF8String] lazilyLoadIfNecessary:lazilyLoad];
}

- (id)moduleForClass:(Class)moduleClass
{
  [self logWarning:@"Please migrate to ABI50_0_0RCTModuleRegistry: @synthesize moduleRegistry = _moduleRegistry." cmd:_cmd];
  NSString *moduleName = ABI50_0_0RCTBridgeModuleNameForClass(moduleClass);
  return [_moduleRegistry moduleForName:[moduleName UTF8String] lazilyLoadIfNecessary:YES];
}

- (NSArray *)modulesConformingToProtocol:(Protocol *)protocol
{
  [self logError:@"The TurboModule system cannot load modules by protocol. Returning an empty NSArray*." cmd:_cmd];
  return @[];
}

- (BOOL)moduleIsInitialized:(Class)moduleClass
{
  [self logWarning:@"Please migrate to ABI50_0_0RCTModuleRegistry: @synthesize moduleRegistry = _moduleRegistry." cmd:_cmd];
  return [_moduleRegistry moduleIsInitialized:moduleClass];
}

- (NSArray<Class> *)moduleClasses
{
  [self logError:@"The TurboModuleManager does not implement this method. Returning an empty NSArray*." cmd:_cmd];
  return @[];
}

/**
 * ABI50_0_0RCTBundleManager
 */
- (void)setBundleURL:(NSURL *)bundleURL
{
  [self logWarning:@"Please migrate to ABI50_0_0RCTBundleManager: @synthesize bundleManager = _bundleManager." cmd:_cmd];
  [_bundleManager setBundleURL:bundleURL];
}

- (NSURL *)bundleURL
{
  [self logWarning:@"Please migrate to ABI50_0_0RCTBundleManager: @synthesize bundleManager = _bundleManager." cmd:_cmd];
  return [_bundleManager bundleURL];
}

/**
 * ABI50_0_0RCTCallableJSModules
 */
- (void)enqueueJSCall:(NSString *)moduleDotMethod args:(NSArray *)args
{
  [self logWarning:@"Please migrate to ABI50_0_0RCTCallableJSModules: @synthesize callableJSModules = _callableJSModules."
               cmd:_cmd];

  NSArray<NSString *> *ids = [moduleDotMethod componentsSeparatedByString:@"."];
  NSString *module = ids[0];
  NSString *method = ids[1];
  [_callableJSModules invokeModule:module method:method withArgs:args];
}

- (void)enqueueJSCall:(NSString *)module
               method:(NSString *)method
                 args:(NSArray *)args
           completion:(dispatch_block_t)completion
{
  [self logWarning:@"Please migrate to ABI50_0_0RCTCallableJSModules: @synthesize callableJSModules = _callableJSModules."
               cmd:_cmd];
  [_callableJSModules invokeModule:module method:method withArgs:args onComplete:completion];
}

- (void)registerSegmentWithId:(NSUInteger)segmentId path:(NSString *)path
{
  self->_registerSegmentWithId(@(segmentId), path);
}

- (id<ABI50_0_0RCTBridgeDelegate>)delegate
{
  [self logError:@"This method is unsupported. Returning nil." cmd:_cmd];
  return nil;
}

- (NSDictionary *)launchOptions
{
  [self logError:@"This method is not supported. Returning nil." cmd:_cmd];
  return nil;
}

- (BOOL)loading
{
  [self logWarning:@"This method is not implemented. Returning NO." cmd:_cmd];
  return NO;
}

- (BOOL)valid
{
  [self logWarning:@"This method is not implemented. Returning NO." cmd:_cmd];
  return NO;
}

- (ABI50_0_0RCTPerformanceLogger *)performanceLogger
{
  [self logWarning:@"This method is not supported. Returning nil." cmd:_cmd];
  return nil;
}

- (void)reload
{
  [self logError:@"Please use ABI50_0_0RCTReloadCommand instead. Nooping." cmd:_cmd];
}

- (void)reloadWithReason:(NSString *)reason
{
  [self logError:@"Please use ABI50_0_0RCTReloadCommand instead. Nooping." cmd:_cmd];
}

- (void)onFastRefresh
{
  [[NSNotificationCenter defaultCenter] postNotificationName:ABI50_0_0RCTBridgeFastRefreshNotification object:self];
}

- (void)requestReload __deprecated_msg("Use ABI50_0_0RCTReloadCommand instead")
{
  [self logError:@"Please use ABI50_0_0RCTReloadCommand instead. Nooping." cmd:_cmd];
}

- (BOOL)isBatchActive
{
  [self logWarning:@"This method is not supported. Returning NO." cmd:_cmd];
  return NO;
}

/**
 * ABI50_0_0RCTBridge ()
 */

- (NSString *)bridgeDescription
{
  [self logWarning:@"This method is not supported. Returning \"BridgeProxy\"." cmd:_cmd];
  return @"BridgeProxy";
}

- (void)enqueueCallback:(NSNumber *)cbID args:(NSArray *)args
{
  [self logError:@"This method is not supported. No-oping." cmd:_cmd];
}

- (ABI50_0_0RCTBridge *)batchedBridge
{
  [self logWarning:@"This method is not supported. Returning bridge proxy." cmd:_cmd];
  return (ABI50_0_0RCTBridge *)self;
}

- (void)setBatchedBridge
{
  [self logError:@"This method is not supported. No-oping." cmd:_cmd];
}

- (ABI50_0_0RCTBridgeModuleListProvider)moduleProvider
{
  [self logWarning:@"This method is not supported. Returning empty block" cmd:_cmd];
  return ^{
    return @[];
  };
}

- (ABI50_0_0RCTModuleRegistry *)moduleRegistry
{
  return _moduleRegistry;
}

/**
 * ABI50_0_0RCTBridge (ABI50_0_0RCTCxxBridge)
 */

- (ABI50_0_0RCTBridge *)parentBridge
{
  [self logWarning:@"This method is not supported. Returning bridge proxy." cmd:_cmd];
  return (ABI50_0_0RCTBridge *)self;
}

- (BOOL)moduleSetupComplete
{
  [self logWarning:@"This method is not supported. Returning YES." cmd:_cmd];
  return YES;
}

- (void)start
{
  [self
      logError:
          @"Starting the bridge proxy does nothing. If you want to start ABI50_0_0React Native, please use ABI50_0_0RCTHost start. Nooping"
           cmd:_cmd];
}

- (void)registerModuleForFrameUpdates:(id<ABI50_0_0RCTBridgeModule>)module withModuleData:(ABI50_0_0RCTModuleData *)moduleData
{
  [self logError:@"This method is not supported. Nooping" cmd:_cmd];
}

- (ABI50_0_0RCTModuleData *)moduleDataForName:(NSString *)moduleName
{
  [self logError:@"This method is not supported. Returning nil." cmd:_cmd];
  return nil;
}

- (void)registerAdditionalModuleClasses:(NSArray<Class> *)newModules
{
  [self
      logError:
          @"This API is unsupported. Please return all module classes from your app's ABI50_0_0RCTTurboModuleManagerDelegate getModuleClassFromName:. Nooping."
           cmd:_cmd];
}

- (void)updateModuleWithInstance:(id<ABI50_0_0RCTBridgeModule>)instance
{
  [self logError:@"This method is not supported. Nooping." cmd:_cmd];
}

- (void)startProfiling
{
  [self logWarning:@"This method is not supported. Nooping." cmd:_cmd];
}

- (void)stopProfiling:(void (^)(NSData *))callback
{
  [self logWarning:@"This method is not supported. Nooping." cmd:_cmd];
}

- (id)callNativeModule:(NSUInteger)moduleID method:(NSUInteger)methodID params:(NSArray *)params
{
  [self logError:@"This method is not supported. Nooping and returning nil." cmd:_cmd];
  return nil;
}

- (void)logMessage:(NSString *)message level:(NSString *)level
{
  [self logWarning:@"This method is not supported. Nooping." cmd:_cmd];
}

- (void)_immediatelyCallTimer:(NSNumber *)timer
{
  [self logWarning:@"This method is not supported. Nooping." cmd:_cmd];
}

/**
 * ABI50_0_0RCTBridge (Inspector)
 */
- (BOOL)inspectable
{
  [self logWarning:@"This method is not supported. Returning NO." cmd:_cmd];
  return NO;
}

/**
 * ABI50_0_0RCTBridge (ABI50_0_0RCTUIManager)
 */
- (ABI50_0_0RCTUIManager *)uiManager
{
  return (ABI50_0_0RCTUIManager *)_uiManagerProxy;
}

- (ABI50_0_0RCTBridgeProxy *)object
{
  return self;
}

/**
 * NSProxy setup
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel;
{
  return [ABI50_0_0RCTCxxBridge instanceMethodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
  [self logError:@"This method is unsupported." cmd:invocation.selector];
}

/**
 * Logging
 * TODO(155977839): Add a means to configure/disable these logs, so people do not ignore all LogBoxes
 */
- (void)logWarning:(NSString *)message cmd:(SEL)cmd
{
  if (ABI50_0_0RCTTurboModuleInteropBridgeProxyLogLevel() == kABI50_0_0RCTBridgeProxyLoggingLevelWarning) {
    ABI50_0_0RCTLogWarn(@"ABI50_0_0RCTBridgeProxy: Calling [bridge %@]. %@", NSStringFromSelector(cmd), message);
  }
}

- (void)logError:(NSString *)message cmd:(SEL)cmd
{
  if (ABI50_0_0RCTTurboModuleInteropBridgeProxyLogLevel() == kABI50_0_0RCTBridgeProxyLoggingLevelWarning ||
      ABI50_0_0RCTTurboModuleInteropBridgeProxyLogLevel() == kABI50_0_0RCTBridgeProxyLoggingLevelError) {
    ABI50_0_0RCTLogError(@"ABI50_0_0RCTBridgeProxy: Calling [bridge %@]. %@", NSStringFromSelector(cmd), message);
  }
}

@end

@implementation ABI50_0_0RCTUIManagerProxy {
  ABI50_0_0RCTViewRegistry *_viewRegistry;
  NSMutableDictionary<NSNumber *, UIView *> *_legacyViewRegistry;
}
- (instancetype)initWithViewRegistry:(ABI50_0_0RCTViewRegistry *)viewRegistry
{
  self = [super self];
  if (self) {
    _viewRegistry = viewRegistry;
    _legacyViewRegistry = [NSMutableDictionary new];
  }
  return self;
}

/**
 * ABI50_0_0RCTViewRegistry
 */
- (UIView *)viewForABI50_0_0ReactTag:(NSNumber *)ABI50_0_0ReactTag
{
  [self logWarning:@"Please migrate to ABI50_0_0RCTViewRegistry: @synthesize viewRegistry_DEPRECATED = _viewRegistry_DEPRECATED."
               cmd:_cmd];
  return [_viewRegistry viewForABI50_0_0ReactTag:ABI50_0_0ReactTag] ? [_viewRegistry viewForABI50_0_0ReactTag:ABI50_0_0ReactTag]
                                                  : [_legacyViewRegistry objectForKey:ABI50_0_0ReactTag];
}

- (void)addUIBlock:(ABI50_0_0RCTViewManagerUIBlock)block
{
  [self
      logWarning:
          @"This method isn't implemented faithfully. Please migrate to ABI50_0_0RCTViewRegistry if possible: @synthesize viewRegistry_DEPRECATED = _viewRegistry_DEPRECATED."
             cmd:_cmd];
  __weak __typeof(self) weakSelf = self;
  ABI50_0_0RCTExecuteOnMainQueue(^{
    __typeof(self) strongSelf = weakSelf;
    if (strongSelf) {
      block((ABI50_0_0RCTUIManager *)strongSelf, strongSelf->_legacyViewRegistry);
    }
  });
}

/**
 * NSProxy setup
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [ABI50_0_0RCTUIManager instanceMethodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
  [self logError:@"This methid is unsupported." cmd:invocation.selector];
}

/**
 * Logging
 * TODO(155977839): Add a means to configure/disable these logs, so people do not ignore all LogBoxes
 */
- (void)logWarning:(NSString *)message cmd:(SEL)cmd
{
  if (ABI50_0_0RCTTurboModuleInteropBridgeProxyLogLevel() == kABI50_0_0RCTBridgeProxyLoggingLevelWarning) {
    ABI50_0_0RCTLogWarn(
        @"ABI50_0_0RCTBridgeProxy (ABI50_0_0RCTUIManagerProxy): Calling [bridge.uiManager %@]. %@", NSStringFromSelector(cmd), message);
  }
}

- (void)logError:(NSString *)message cmd:(SEL)cmd
{
  if (ABI50_0_0RCTTurboModuleInteropBridgeProxyLogLevel() == kABI50_0_0RCTBridgeProxyLoggingLevelWarning ||
      ABI50_0_0RCTTurboModuleInteropBridgeProxyLogLevel() == kABI50_0_0RCTBridgeProxyLoggingLevelError) {
    ABI50_0_0RCTLogError(
        @"ABI50_0_0RCTBridgeProxy (ABI50_0_0RCTUIManagerProxy): Calling [bridge.uiManager %@]. %@", NSStringFromSelector(cmd), message);
  }
}

@end
