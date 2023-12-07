// Copyright 2016-present 650 Industries. All rights reserved.

#import <OpenGLES/EAGL.h>
#import <ABI50_0_0ExpoGL/ABI50_0_0EXGLNativeApi.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistry.h>

@class ABI50_0_0EXGLContext;

@protocol ABI50_0_0EXGLContextDelegate <NSObject>

- (void)glContextFlushed:(nonnull ABI50_0_0EXGLContext *)context;
- (void)glContextInitialized:(nonnull ABI50_0_0EXGLContext *)context;
- (void)glContextWillDestroy:(nonnull ABI50_0_0EXGLContext *)context;
- (ABI50_0_0EXGLObjectId)glContextGetDefaultFramebuffer;

@end

@interface ABI50_0_0EXGLContext : NSObject

- (nullable instancetype)initWithDelegate:(nullable id<ABI50_0_0EXGLContextDelegate>)delegate
                        andModuleRegistry:(nonnull ABI50_0_0EXModuleRegistry *)moduleRegistry;
- (void)initialize;
- (void)prepare:(nullable void(^)(BOOL))callback andEnableExperimentalWorkletSupport:(BOOL)enableExperimentalWorkletSupport;
- (BOOL)isInitialized;
- (nullable EAGLContext *)createSharedEAGLContext;
- (void)runAsync:(nonnull void(^)(void))callback;
- (void)runInEAGLContext:(nonnull EAGLContext*)context callback:(nonnull void(^)(void))callback;
- (void)takeSnapshotWithOptions:(nonnull NSDictionary *)options resolve:(nonnull ABI50_0_0EXPromiseResolveBlock)resolve reject:(nonnull ABI50_0_0EXPromiseRejectBlock)reject;
- (void)destroy;

// "protected"
@property (nonatomic, assign) ABI50_0_0EXGLContextId contextId;
@property (nonatomic, strong, nonnull) EAGLContext *eaglCtx;
@property (nonatomic, weak, nullable) id <ABI50_0_0EXGLContextDelegate> delegate;

@end
