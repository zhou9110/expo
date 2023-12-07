// Copyright 2016-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXCameraInterface.h>

#import <ABI50_0_0ExpoGL/ABI50_0_0EXGLContext.h>
#import <ABI50_0_0ExpoGL/ABI50_0_0EXGLObject.h>

@interface ABI50_0_0EXGLCameraObject : ABI50_0_0EXGLObject

- (instancetype)initWithContext:(ABI50_0_0EXGLContext *)glContext andCamera:(id<ABI50_0_0EXCameraInterface>)camera;

@end
