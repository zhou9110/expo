/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <functional>
#include <string>
#include <unordered_set>

#include <ABI50_0_0ReactCommon/ABI50_0_0CallInvoker.h>
#include <ABI50_0_0ReactCommon/ABI50_0_0TurboModule.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <ABI50_0_0React/bridging/ABI50_0_0CallbackWrapper.h>
#include <ABI50_0_0React/jni/ABI50_0_0JCallback.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

struct JTurboModule : jni::JavaClass<JTurboModule> {
  static auto constexpr kJavaDescriptor =
      "Lcom/facebook/ABI50_0_0React/turbomodule/core/interfaces/TurboModule;";
};

class JSI_EXPORT JavaTurboModule : public TurboModule {
 public:
  // TODO(T65603471): Should we unify this with a Fabric abstraction?
  struct InitParams {
    std::string moduleName;
    jni::alias_ref<jobject> instance;
    std::shared_ptr<CallInvoker> jsInvoker;
    std::shared_ptr<NativeMethodCallInvoker> nativeMethodCallInvoker;
  };

  JavaTurboModule(const InitParams& params);
  virtual ~JavaTurboModule();

  jsi::Value invokeJavaMethod(
      jsi::Runtime& runtime,
      TurboModuleMethodValueKind valueKind,
      const std::string& methodName,
      const std::string& methodSignature,
      const jsi::Value* args,
      size_t argCount,
      jmethodID& cachedMethodID);

 private:
  // instance_ can be of type JTurboModule, or JNativeModule
  jni::global_ref<jobject> instance_;
  std::shared_ptr<NativeMethodCallInvoker> nativeMethodCallInvoker_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
