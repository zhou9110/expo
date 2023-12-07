/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#import <memory>

#import <Foundation/Foundation.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTModuleMethod.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0CallInvoker.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0TurboModule.h>
#import <string>
#import <unordered_map>

#define ABI50_0_0RCT_IS_TURBO_MODULE_CLASS(klass) \
  ((ABI50_0_0RCTTurboModuleEnabled() && [(klass) conformsToProtocol:@protocol(ABI50_0_0RCTTurboModule)]))
#define ABI50_0_0RCT_IS_TURBO_MODULE_INSTANCE(module) ABI50_0_0RCT_IS_TURBO_MODULE_CLASS([(module) class])

namespace ABI50_0_0facebook::ABI50_0_0React {

class CallbackWrapper;
class Instance;

namespace TurboModuleConvertUtils {
jsi::Value convertObjCObjectToJSIValue(jsi::Runtime &runtime, id value);
id convertJSIValueToObjCObject(jsi::Runtime &runtime, const jsi::Value &value, std::shared_ptr<CallInvoker> jsInvoker);
}

/**
 * ObjC++ specific TurboModule base class.
 */
class JSI_EXPORT ObjCTurboModule : public TurboModule {
 public:
  // TODO(T65603471): Should we unify this with a Fabric abstraction?
  struct InitParams {
    std::string moduleName;
    id<ABI50_0_0RCTBridgeModule> instance;
    std::shared_ptr<CallInvoker> jsInvoker;
    std::shared_ptr<NativeMethodCallInvoker> nativeMethodCallInvoker;
    bool isSyncModule;
  };

  ObjCTurboModule(const InitParams &params);

  jsi::Value invokeObjCMethod(
      jsi::Runtime &runtime,
      TurboModuleMethodValueKind returnType,
      const std::string &methodName,
      SEL selector,
      const jsi::Value *args,
      size_t count);

  id<ABI50_0_0RCTBridgeModule> instance_;
  std::shared_ptr<NativeMethodCallInvoker> nativeMethodCallInvoker_;

 protected:
  void setMethodArgConversionSelector(NSString *methodName, int argIndex, NSString *fnName);

  /**
   * Why is this virtual?
   *
   * Purpose: Converts native module method returns from Objective C values to JavaScript values.
   *
   * ObjCTurboModule uses TurboModuleMethodValueKind to convert returns from Objective C values to JavaScript values.
   * ObjCInteropTurboModule just blindly converts returns from Objective C values to JavaScript values by runtime type,
   * because it cannot infer TurboModuleMethodValueKind from the ABI50_0_0RCT_EXPORT_METHOD annotations.
   */
  virtual jsi::Value convertReturnIdToJSIValue(
      jsi::Runtime &runtime,
      const char *methodName,
      TurboModuleMethodValueKind returnType,
      id result);

  /**
   * Why is this virtual?
   *
   * Purpose: Get a native module method's argument's type, given the method name, and argument index.
   *
   * ObjCInteropTurboModule computes the argument type names eagerly on module init. So, make this method virtual. That
   * way, ObjCInteropTurboModule doesn't end up computing the argument types twice: once on module init, and second on
   * method dispatch.
   */
  virtual NSString *getArgumentTypeName(jsi::Runtime &runtime, NSString *methodName, int argIndex);

  /**
   * Why is this virtual?
   *
   * Purpose: Convert arguments from JavaScript values to Objective C values. Assign the Objective C argument to the
   * method invocation.
   *
   * ObjCInteropTurboModule relies heavily on ABI50_0_0RCTConvert to convert arguments from JavaScript values to Objective C
   * values. ObjCTurboModule tries to minimize reliance on ABI50_0_0RCTConvert: ABI50_0_0RCTConvert uses the ABI50_0_0RCT_EXPORT_METHOD macros,
   * which we want to remove long term from ABI50_0_0React Native.
   */
  virtual void setInvocationArg(
      jsi::Runtime &runtime,
      const char *methodName,
      const std::string &objCArgType,
      const jsi::Value &arg,
      size_t i,
      NSInvocation *inv,
      NSMutableArray *retainedObjectsForInvocation);

 private:
  // Does the NativeModule dispatch async methods to the JS thread?
  const bool isSyncModule_;

  /**
   * TODO(ramanpreet):
   * Investigate an optimization that'll let us get rid of this NSMutableDictionary.
   * Perhaps, have the code-generated TurboModule subclass implement
   * getMethodArgConversionSelector below.
   */
  NSMutableDictionary<NSString *, NSMutableArray *> *methodArgConversionSelectors_;
  NSDictionary<NSString *, NSArray<NSString *> *> *methodArgumentTypeNames_;

  bool isMethodSync(TurboModuleMethodValueKind returnType);
  BOOL hasMethodArgConversionSelector(NSString *methodName, int argIndex);
  SEL getMethodArgConversionSelector(NSString *methodName, int argIndex);
  NSInvocation *createMethodInvocation(
      jsi::Runtime &runtime,
      bool isSync,
      const char *methodName,
      SEL selector,
      const jsi::Value *args,
      size_t count,
      NSMutableArray *retainedObjectsForInvocation);
  id performMethodInvocation(
      jsi::Runtime &runtime,
      bool isSync,
      const char *methodName,
      NSInvocation *inv,
      NSMutableArray *retainedObjectsForInvocation);

  using PromiseInvocationBlock = void (^)(ABI50_0_0RCTPromiseResolveBlock resolveWrapper, ABI50_0_0RCTPromiseRejectBlock rejectWrapper);
  jsi::Value createPromise(jsi::Runtime &runtime, std::string methodName, PromiseInvocationBlock invoke);
};

} // namespace ABI50_0_0facebook::ABI50_0_0React

@protocol ABI50_0_0RCTTurboModule <NSObject>
- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule>)getTurboModule:
    (const ABI50_0_0facebook::ABI50_0_0React::ObjCTurboModule::InitParams &)params;
@end

/**
 * These methods are all implemented by ABI50_0_0RCTCxxBridge, which subclasses ABI50_0_0RCTBridge. Hence, they must only be used in
 * contexts where the concrete class of an ABI50_0_0RCTBridge instance is ABI50_0_0RCTCxxBridge. This happens, for example, when
 * [ABI50_0_0RCTCxxBridgeDelegate jsExecutorFactoryForBridge:(ABI50_0_0RCTBridge *)] is invoked by ABI50_0_0RCTCxxBridge.
 *
 * TODO: Consolidate this extension with the one in ABI50_0_0RCTSurfacePresenter.
 */
@interface ABI50_0_0RCTBridge (ABI50_0_0RCTTurboModule)
- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker>)jsCallInvoker;
- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::NativeMethodCallInvoker>)decorateNativeMethodCallInvoker:
    (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::NativeMethodCallInvoker>)nativeMethodCallInvoker;
@end
