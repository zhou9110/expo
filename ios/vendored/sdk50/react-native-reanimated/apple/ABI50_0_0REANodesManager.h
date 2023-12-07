#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTSurfacePresenterStub.h>
#endif

#import <ABI50_0_0RNReanimated/ABI50_0_0READisplayLink.h>

@class ABI50_0_0REAModule;

typedef void (^ABI50_0_0REAOnAnimationCallback)(ABI50_0_0READisplayLink *displayLink);
typedef void (^ABI50_0_0REANativeAnimationOp)(ABI50_0_0RCTUIManager *uiManager);
typedef void (^ABI50_0_0REAEventHandler)(id<ABI50_0_0RCTEvent> event);
typedef void (^CADisplayLinkOperation)(ABI50_0_0READisplayLink *displayLink);

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
typedef void (^ABI50_0_0REAPerformOperations)();
#endif

@interface ABI50_0_0REANodesManager : NSObject

@property (nonatomic, weak, nullable) ABI50_0_0RCTUIManager *uiManager;
@property (nonatomic, weak, nullable) ABI50_0_0REAModule *reanimatedModule;
@property (nonatomic, readonly) CFTimeInterval currentAnimationTimestamp;

@property (nonatomic, nullable) NSSet<NSString *> *uiProps;
@property (nonatomic, nullable) NSSet<NSString *> *nativeProps;

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
- (nonnull instancetype)initWithModule:(ABI50_0_0REAModule *)reanimatedModule
                                bridge:(ABI50_0_0RCTBridge *)bridge
                      surfacePresenter:(id<ABI50_0_0RCTSurfacePresenterStub>)surfacePresenter;
#else
- (instancetype)initWithModule:(ABI50_0_0REAModule *)reanimatedModule uiManager:(ABI50_0_0RCTUIManager *)uiManager;
#endif
- (void)invalidate;
- (void)operationsBatchDidComplete;

- (void)postOnAnimation:(ABI50_0_0REAOnAnimationCallback)clb;
- (void)registerEventHandler:(ABI50_0_0REAEventHandler)eventHandler;
- (void)dispatchEvent:(id<ABI50_0_0RCTEvent>)event;

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
- (void)setSurfacePresenter:(id<ABI50_0_0RCTSurfacePresenterStub>)surfacePresenter;
- (void)registerPerformOperations:(ABI50_0_0REAPerformOperations)performOperations;
- (void)synchronouslyUpdateViewOnUIThread:(nonnull NSNumber *)viewTag props:(nonnull NSDictionary *)uiProps;
#else
- (void)configureUiProps:(nonnull NSSet<NSString *> *)uiPropsSet
          andNativeProps:(nonnull NSSet<NSString *> *)nativePropsSet;
- (void)updateProps:(nonnull NSDictionary *)props
      ofViewWithTag:(nonnull NSNumber *)viewTag
           withName:(nonnull NSString *)viewName;
- (void)maybeFlushUpdateBuffer;
- (void)enqueueUpdateViewOnNativeThread:(nonnull NSNumber *)ABI50_0_0ReactTag
                               viewName:(NSString *)viewName
                            nativeProps:(NSMutableDictionary *)nativeProps
                       trySynchronously:(BOOL)trySync;
- (NSString *)obtainProp:(nonnull NSNumber *)viewTag propName:(nonnull NSString *)propName;
#endif
- (void)maybeFlushUIUpdatesQueue;

@end
