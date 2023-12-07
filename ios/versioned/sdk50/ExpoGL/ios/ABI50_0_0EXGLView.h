// Copyright 2016-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoGL/ABI50_0_0EXGLNativeApi.h>
#import <ABI50_0_0ExpoGL/ABI50_0_0EXGLContext.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXModuleRegistry.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXLegacyExpoViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0EXGLView : UIView <ABI50_0_0EXGLContextDelegate, ABI50_0_0EXLegacyExpoViewProtocol>

- (ABI50_0_0EXGLContextId)exglCtxId;

// AR
- (void)setArSessionManager:(id)arSessionManager;
- (void)maybeStopARSession;

@property (nonatomic, copy, nullable) ABI50_0_0EXDirectEventBlock onSurfaceCreate;
@property (nonatomic, assign) NSInteger msaaSamples;
@property (nonatomic, assign) BOOL enableExperimentalWorkletSupport;

// "protected"
@property (nonatomic, strong, nullable) ABI50_0_0EXGLContext *glContext;
@property (nonatomic, strong, nullable) EAGLContext *uiEaglCtx;

@end

NS_ASSUME_NONNULL_END
