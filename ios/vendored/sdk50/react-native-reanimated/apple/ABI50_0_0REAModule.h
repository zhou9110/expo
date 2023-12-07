#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventEmitter.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManagerObserverCoordinator.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManagerUtils.h>

#import <ABI50_0_0RNReanimated/ABI50_0_0REAAnimationsManager.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REANodesManager.h>

@interface ABI50_0_0REAModule : ABI50_0_0RCTEventEmitter <ABI50_0_0RCTBridgeModule, ABI50_0_0RCTEventDispatcherObserver, ABI50_0_0RCTUIManagerObserver>

@property (nonatomic, readonly) ABI50_0_0REANodesManager *nodesManager;
@property ABI50_0_0REAAnimationsManager *animationsManager;

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
- (void)installReanimatedAfterReload;
#endif

@end
