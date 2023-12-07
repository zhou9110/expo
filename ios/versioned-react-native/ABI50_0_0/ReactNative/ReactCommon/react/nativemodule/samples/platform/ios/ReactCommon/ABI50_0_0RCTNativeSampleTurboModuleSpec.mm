/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTNativeSampleTurboModuleSpec.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_voidFunc(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, VoidKind, "voidFunc", @selector(voidFunc), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getBool(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, BooleanKind, "getBool", @selector(getBool:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getEnum(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, NumberKind, "getEnum", @selector(getEnum:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getNumber(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, NumberKind, "getNumber", @selector(getNumber:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getString(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, StringKind, "getString", @selector(getString:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getArray(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, ArrayKind, "getArray", @selector(getArray:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getObject(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, ObjectKind, "getObject", @selector(getObject:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getUnsafeObject(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, ObjectKind, "getUnsafeObject", @selector(getUnsafeObject:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getRootTag(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, NumberKind, "getRootTag", @selector(getRootTag:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getValue(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, ObjectKind, "getValue", @selector(getValue:y:z:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getValueWithCallback(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, VoidKind, "getValueWithCallback", @selector(getValueWithCallback:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getValueWithPromise(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(
          rt, PromiseKind, "getValueWithPromise", @selector(getValueWithPromise:resolve:reject:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getConstants(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, ObjectKind, "getConstants", @selector(getConstants), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_voidFuncThrows(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, VoidKind, "voidFuncThrows", @selector(voidFuncThrows), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getObjectThrows(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, ObjectKind, "getObjectThrows", @selector(getObjectThrows:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_promiseThrows(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, PromiseKind, "promiseThrows", @selector(promiseThrows:resolve:reject:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_voidFuncAssert(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, VoidKind, "voidFuncAssert", @selector(voidFuncAssert), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_getObjectAssert(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, ObjectKind, "getObjectAssert", @selector(getObjectAssert:), args, count);
}

static ABI50_0_0facebook::jsi::Value __hostFunction_NativeSampleTurboModuleSpecJSI_promiseAssert(
    ABI50_0_0facebook::jsi::Runtime &rt,
    TurboModule &turboModule,
    const ABI50_0_0facebook::jsi::Value *args,
    size_t count)
{
  return static_cast<ObjCTurboModule &>(turboModule)
      .invokeObjCMethod(rt, PromiseKind, "promiseAssert", @selector(promiseAssert:resolve:reject:), args, count);
}

NativeSampleTurboModuleSpecJSI::NativeSampleTurboModuleSpecJSI(const ObjCTurboModule::InitParams &params)
    : ObjCTurboModule(params)
{
  methodMap_["voidFunc"] = MethodMetadata{0, __hostFunction_NativeSampleTurboModuleSpecJSI_voidFunc};
  methodMap_["getBool"] = MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getBool};
  methodMap_["getEnum"] = MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getEnum};
  methodMap_["getNumber"] = MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getNumber};
  methodMap_["getString"] = MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getString};
  methodMap_["getArray"] = MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getArray};
  methodMap_["getObject"] = MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getObject};
  methodMap_["getUnsafeObject"] = MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getUnsafeObject};
  methodMap_["getRootTag"] = MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getRootTag};
  methodMap_["getValue"] = MethodMetadata{3, __hostFunction_NativeSampleTurboModuleSpecJSI_getValue};
  methodMap_["getValueWithCallback"] =
      MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getValueWithCallback};
  methodMap_["getValueWithPromise"] =
      MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getValueWithPromise};
  methodMap_["voidFuncThrows"] = MethodMetadata{0, __hostFunction_NativeSampleTurboModuleSpecJSI_voidFuncThrows};
  methodMap_["getObjectThrows"] = MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getObjectThrows};
  methodMap_["promiseThrows"] = MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_promiseThrows};
  methodMap_["voidFuncAssert"] = MethodMetadata{0, __hostFunction_NativeSampleTurboModuleSpecJSI_voidFuncAssert};
  methodMap_["getObjectAssert"] = MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_getObjectAssert};
  methodMap_["promiseAssert"] = MethodMetadata{1, __hostFunction_NativeSampleTurboModuleSpecJSI_promiseAssert};
  methodMap_["getConstants"] = MethodMetadata{0, __hostFunction_NativeSampleTurboModuleSpecJSI_getConstants};
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
