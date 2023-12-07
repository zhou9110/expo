/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#import <string>
#import <vector>

#import <ABI50_0_0ReactCommon/ABI50_0_0TurboModule.h>
#import <ABI50_0_0jsi/ABI50_0_0jsi.h>

#import "ABI50_0_0RCTTurboModule.h"

namespace ABI50_0_0facebook {
namespace ABI50_0_0React {

class JSI_EXPORT ObjCInteropTurboModule : public ObjCTurboModule {
 public:
  struct MethodDescriptor {
    std::string methodName;
    SEL selector;
    int jsArgCount;
    TurboModuleMethodValueKind jsReturnKind;
  };

  ObjCInteropTurboModule(const ObjCTurboModule::InitParams &params);

  std::vector<ABI50_0_0facebook::jsi::PropNameID> getPropertyNames(ABI50_0_0facebook::jsi::Runtime &runtime) override;

 protected:
  jsi::Value create(jsi::Runtime &runtime, const jsi::PropNameID &propName) override;

  /**
   * Why is this overriden?
   *
   * Purpose: Converts native module method returns from Objective C values to JavaScript values.
   *
   * ObjCTurboModule converts returns by returnType. But, Legacy native modules convert returns by the Objective C type:
   * ABI50_0_0React Native cannot infer a method's returnType from the ABI50_0_0RCT_EXPORT_METHOD annotations.
   */
  jsi::Value convertReturnIdToJSIValue(
      jsi::Runtime &runtime,
      const char *methodName,
      TurboModuleMethodValueKind returnType,
      id result) override;

  /**
   * Why is this overriden?
   *
   * Purpose: Get a native module method's argument's type, given the method name, and argument index.
   *
   * This override is meant to serve as a performance optimization.
   *
   * ObjCTurboModule computes the method argument types from the ABI50_0_0RCT_EXPORT_METHOD macros lazily.
   * ObjCInteropTurboModule computes all the method argument types eagerly on module init.
   *
   * ObjCInteropTurboModule overrides getArgumentTypeName, so ObjCTurboModule doesn't end up re-computing the argument
   * type names again.
   */
  NSString *getArgumentTypeName(jsi::Runtime &runtime, NSString *methodName, int argIndex) override;

  /**
   * Why is this overriden?
   *
   * Purpose: Convert arguments from JavaScript values to Objective C values. Assign the Objective C argument to the
   * method invocation.
   *
   * ObjCTurboModule tries to minimize reliance on ABI50_0_0RCTConvert for argument conversion. Why: ABI50_0_0RCTConvert relies on the
   * ABI50_0_0RCT_EXPORT_METHOD macros, which we want to remove long term. But, Legacy native modules rely heavily on ABI50_0_0RCTConvert
   * for argument conversion.
   */
  void setInvocationArg(
      jsi::Runtime &runtime,
      const char *methodName,
      const std::string &objCArgType,
      const jsi::Value &arg,
      size_t i,
      NSInvocation *inv,
      NSMutableArray *retainedObjectsForInvocation) override;

 private:
  std::vector<MethodDescriptor> methodDescriptors_;
  NSDictionary<NSString *, NSArray<NSString *> *> *methodArgumentTypeNames_;
  jsi::Value constantsCache_;

  const jsi::Value &getConstants(jsi::Runtime &runtime);
  bool exportsConstants();
};

} // namespace ABI50_0_0React
} // namespace ABI50_0_0facebook
