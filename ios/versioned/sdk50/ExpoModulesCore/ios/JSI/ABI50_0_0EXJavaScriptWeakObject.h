// Copyright 2022-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXJavaScriptValue.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXJavaScriptRuntime.h>

#ifdef __cplusplus
#import <ABI50_0_0jsi/ABI50_0_0jsi.h>

namespace jsi = ABI50_0_0facebook::jsi;
#endif // __cplusplus

NS_SWIFT_NAME(JavaScriptWeakObject)
@interface ABI50_0_0EXJavaScriptWeakObject : NSObject

#ifdef __cplusplus
- (nonnull instancetype)initWith:(std::shared_ptr<jsi::Object>)jsObject
                         runtime:(nonnull ABI50_0_0EXJavaScriptRuntime *)runtime;
#endif // __cplusplus

- (nullable ABI50_0_0EXJavaScriptObject *)lock;

@end
