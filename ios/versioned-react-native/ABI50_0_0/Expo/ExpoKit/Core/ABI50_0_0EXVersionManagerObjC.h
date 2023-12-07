// Copyright 2015-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0React/ABI50_0_0RCTLog.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>

#import "ABI50_0_0EXVersionUtils.h"

@class ABI50_0_0EXManifestsManifest;

@interface ABI50_0_0EXVersionManagerObjC : NSObject

- (nonnull instancetype)initWithParams:(nonnull NSDictionary *)params
                              manifest:(nonnull ABI50_0_0EXManifestsManifest *)manifest
                          fatalHandler:(void (^ _Nonnull)(NSError * _Nullable))fatalHandler
                           logFunction:(nonnull ABI50_0_0RCTLogFunction)logFunction
                          logThreshold:(ABI50_0_0RCTLogLevel)logThreshold;

- (void)bridgeWillStartLoading:(id)bridge;
- (void)bridgeFinishedLoading:(id)bridge;
- (void)invalidate;

/**
 *  Dev tools (implementation varies by SDK)
 */
- (void)showDevMenuForBridge:(id)bridge;
- (void)disableRemoteDebuggingForBridge:(id)bridge;
- (void)toggleRemoteDebuggingForBridge:(id)bridge;
- (void)togglePerformanceMonitorForBridge:(id)bridge;
- (void)toggleElementInspectorForBridge:(id)bridge;
- (uint32_t)addWebSocketNotificationHandler:(void (^)(NSDictionary<NSString *, id> *))handler
                         queue:(dispatch_queue_t)queue
                     forMethod:(NSString *)method;

- (NSDictionary<NSString *, NSString *> *)devMenuItemsForBridge:(id)bridge;
- (void)selectDevMenuItemWithKey:(NSString *)key onBridge:(id)bridge;

/**
 *  Provides the extra native modules required to set up a bridge with this version.
 */
- (NSArray *)extraModulesForBridge:(id)bridge;

- (void *)versionedJsExecutorFactoryForBridge:(id)bridge;

@end
