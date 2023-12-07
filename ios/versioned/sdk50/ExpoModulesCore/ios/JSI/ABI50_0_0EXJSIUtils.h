// Copyright 2018-present 650 Industries. All rights reserved.

#ifdef __cplusplus

#import <functional>

#import <ABI50_0_0jsi/ABI50_0_0jsi.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTTurboModule.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0TurboModuleUtils.h>
#import <ABI50_0_0ExpoModulesCore/ObjectDeallocator.h>

namespace jsi = ABI50_0_0facebook::jsi;
namespace react = ABI50_0_0facebook::ABI50_0_0React;

namespace ABI50_0_0expo {

#pragma mark - Promises

using PromiseInvocationBlock = void (^)(ABI50_0_0RCTPromiseResolveBlock resolveWrapper, ABI50_0_0RCTPromiseRejectBlock rejectWrapper);

void callPromiseSetupWithBlock(jsi::Runtime &runtime, std::shared_ptr<react::CallInvoker> jsInvoker, std::shared_ptr<react::Promise> promise, PromiseInvocationBlock setupBlock);

#pragma mark - Classes

using ClassConstructor = std::function<void(jsi::Runtime &runtime, const jsi::Value &thisValue, const jsi::Value *args, size_t count)>;

std::shared_ptr<jsi::Function> createClass(jsi::Runtime &runtime, const char *name, ClassConstructor constructor);

/**
 Creates a new object, using the provided object as the prototype.
 */
std::shared_ptr<jsi::Object> createObjectWithPrototype(jsi::Runtime &runtime, std::shared_ptr<jsi::Object> prototype);

#pragma mark - Weak objects

/**
 Checks whether the `WeakRef` class is available in the given runtime.
 According to the docs, it is unimplemented in JSC prior to iOS 14.5.
 As of the time of writing this comment it's also unimplemented in Hermes
 where you should use `jsi::WeakObject` instead.
 https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakRef
 */
bool isWeakRefSupported(jsi::Runtime &runtime);

/**
 Creates the `WeakRef` with given JSI object. You should first use `isWeakRefSupported`
 to check whether this feature is supported by the runtime.
 */
std::shared_ptr<jsi::Object> createWeakRef(jsi::Runtime &runtime, std::shared_ptr<jsi::Object> object);

/**
 Returns the `WeakRef` object's target object, or an empty pointer if the target object has been reclaimed.
 */
std::shared_ptr<jsi::Object> derefWeakRef(jsi::Runtime &runtime, std::shared_ptr<jsi::Object> object);

#pragma mark - Errors

jsi::Value makeCodedError(jsi::Runtime &runtime, NSString *code, NSString *message);

} // namespace ABI50_0_0expo

#endif
