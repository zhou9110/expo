/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

// NOTE: This entire file should be codegen'ed.

#include <ABI50_0_0ReactCommon/ABI50_0_0SampleTurboModuleSpec.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_voidFunc(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt, VoidKind, "voidFunc", "()V", args, count, cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getBool(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt, BooleanKind, "getBool", "(Z)Z", args, count, cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getEnum(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt, NumberKind, "getEnum", "(D)D", args, count, cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getNumber(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt, NumberKind, "getNumber", "(D)D", args, count, cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getString(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt,
          StringKind,
          "getString",
          "(Ljava/lang/String;)Ljava/lang/String;",
          args,
          count,
          cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getArray(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt,
          ArrayKind,
          "getArray",
          "(Lcom/facebook/ABI50_0_0React/bridge/ReadableArray;)Lcom/facebook/ABI50_0_0React/bridge/WritableArray;",
          args,
          count,
          cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getObject(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt,
          ObjectKind,
          "getObject",
          "(Lcom/facebook/ABI50_0_0React/bridge/ReadableMap;)Lcom/facebook/ABI50_0_0React/bridge/WritableMap;",
          args,
          count,
          cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getRootTag(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt, NumberKind, "getRootTag", "(D)D", args, count, cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getValue(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt,
          ObjectKind,
          "getValue",
          "(DLjava/lang/String;Lcom/facebook/ABI50_0_0React/bridge/ReadableMap;)Lcom/facebook/ABI50_0_0React/bridge/WritableMap;",
          args,
          count,
          cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getValueWithCallback(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt,
          VoidKind,
          "getValueWithCallback",
          "(Lcom/facebook/ABI50_0_0React/bridge/Callback;)V",
          args,
          count,
          cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getValueWithPromise(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt,
          PromiseKind,
          "getValueWithPromise",
          "(ZLcom/facebook/ABI50_0_0React/bridge/Promise;)V",
          args,
          count,
          cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_voidFuncThrows(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt, VoidKind, "voidFuncThrows", "()V", args, count, cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getObjectThrows(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt,
          ObjectKind,
          "getObjectThrows",
          "(Lcom/facebook/ABI50_0_0React/bridge/ReadableMap;)Lcom/facebook/ABI50_0_0React/bridge/WritableMap;",
          args,
          count,
          cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_promiseThrows(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt,
          PromiseKind,
          "promiseThrows",
          "(Lcom/facebook/ABI50_0_0React/bridge/Promise;)V",
          args,
          count,
          cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_voidFuncAssert(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt, VoidKind, "voidFuncAssert", "()V", args, count, cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getObjectAssert(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt,
          ObjectKind,
          "getObjectAssert",
          "(Lcom/facebook/ABI50_0_0React/bridge/ReadableMap;)Lcom/facebook/ABI50_0_0React/bridge/WritableMap;",
          args,
          count,
          cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_promiseAssert(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt,
          PromiseKind,
          "promiseAssert",
          "(Lcom/facebook/ABI50_0_0React/bridge/Promise;)V",
          args,
          count,
          cachedMethodId);
}

static ABI50_0_0facebook::jsi::Value
__hostFunction_NativeSampleTurboModuleSpecJSI_getConstants(
    ABI50_0_0facebook::jsi::Runtime& rt,
    TurboModule& turboModule,
    const ABI50_0_0facebook::jsi::Value* args,
    size_t count) {
  static jmethodID cachedMethodId = nullptr;
  return static_cast<JavaTurboModule&>(turboModule)
      .invokeJavaMethod(
          rt,
          ObjectKind,
          "getConstants",
          "()Ljava/util/Map;",
          args,
          count,
          cachedMethodId);
}

NativeSampleTurboModuleSpecJSI::NativeSampleTurboModuleSpecJSI(
    const JavaTurboModule::InitParams& params)
    : JavaTurboModule(params) {
  methodMap_["voidFunc"] =
      MethodMetadata{0, __hostFunction_NativeSampleTurboModuleSpecJSI_voidFunc};

  methodMap_["getBool"] =
      MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getBool};

  methodMap_["getEnum"] =
      MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getEnum};

  methodMap_["getNumber"] = MethodMetadata{
      1, __hostFunction_NativeSampleTurboModuleSpecJSI_getNumber};

  methodMap_["getString"] = MethodMetadata{
      1, __hostFunction_NativeSampleTurboModuleSpecJSI_getString};

  methodMap_["getArray"] =
      MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getArray};

  methodMap_["getObject"] = MethodMetadata{
      1, __hostFunction_NativeSampleTurboModuleSpecJSI_getObject};

  methodMap_["getRootTag"] = MethodMetadata{
      1, __hostFunction_NativeSampleTurboModuleSpecJSI_getRootTag};

  methodMap_["getValue"] =
      MethodMetadata{3, __hostFunction_NativeSampleTurboModuleSpecJSI_getValue};

  methodMap_["getValueWithCallback"] = MethodMetadata{
      1, __hostFunction_NativeSampleTurboModuleSpecJSI_getValueWithCallback};

  methodMap_["getValueWithPromise"] = MethodMetadata{
      1, __hostFunction_NativeSampleTurboModuleSpecJSI_getValueWithPromise};

  methodMap_["voidFuncThrows"] = MethodMetadata{
      0, __hostFunction_NativeSampleTurboModuleSpecJSI_voidFuncThrows};

  methodMap_["getObjectThrows"] = MethodMetadata{
      1, __hostFunction_NativeSampleTurboModuleSpecJSI_getObjectThrows};

  methodMap_["promiseThrows"] = MethodMetadata{
      1, __hostFunction_NativeSampleTurboModuleSpecJSI_promiseThrows};

  methodMap_["voidFuncAssert"] = MethodMetadata{
      0, __hostFunction_NativeSampleTurboModuleSpecJSI_voidFuncAssert};

  methodMap_["getObjectAssert"] = MethodMetadata{
      1, __hostFunction_NativeSampleTurboModuleSpecJSI_getObjectAssert};

  methodMap_["promiseAssert"] = MethodMetadata{
      1, __hostFunction_NativeSampleTurboModuleSpecJSI_promiseAssert};

  methodMap_["getConstants"] = MethodMetadata{
      0, __hostFunction_NativeSampleTurboModuleSpecJSI_getConstants};
}

std::shared_ptr<TurboModule> SampleTurboModuleSpec_ModuleProvider(
    const std::string& moduleName,
    const JavaTurboModule::InitParams& params) {
  if (moduleName == "SampleTurboModule") {
    return std::make_shared<NativeSampleTurboModuleSpecJSI>(params);
  }
  return nullptr;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
