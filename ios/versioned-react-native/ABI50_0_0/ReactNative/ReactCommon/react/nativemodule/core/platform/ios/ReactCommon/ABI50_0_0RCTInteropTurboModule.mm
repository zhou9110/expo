/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0RCTInteropTurboModule.h"

#import <objc/message.h>
#import <objc/runtime.h>

#import <ABI50_0_0React/ABI50_0_0RCTAssert.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTCxxConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTManagedPointer.h>
#import <ABI50_0_0React/ABI50_0_0RCTModuleMethod.h>
#import <ABI50_0_0React/ABI50_0_0RCTParserUtils.h>

namespace ABI50_0_0facebook {
namespace ABI50_0_0React {

namespace {

// This is used for generating short exception strings.
std::string getType(jsi::Runtime &rt, const jsi::Value &v)
{
  if (v.isUndefined()) {
    return "undefined";
  } else if (v.isNull()) {
    return "null";
  } else if (v.isBool()) {
    return v.getBool() ? "true" : "false";
  } else if (v.isNumber()) {
    return "number";
  } else if (v.isString()) {
    return "string";
  } else if (v.isSymbol()) {
    return "symbol";
  } else if (v.isBigInt()) {
    return "bigint";
  } else if (v.isObject()) {
    jsi::Object vObj = v.getObject(rt);
    return vObj.isFunction(rt) ? "function" : vObj.isArray(rt) ? "array" : "object";
  } else {
    return "unknown";
  }
}

std::vector<const ABI50_0_0RCTMethodInfo *> getMethodInfos(Class moduleClass)
{
  std::vector<const ABI50_0_0RCTMethodInfo *> methodInfos;

  Class cls = moduleClass;
  while (cls && cls != [NSObject class] && cls != [NSProxy class]) {
    unsigned int methodCount;
    Method *methods = class_copyMethodList(object_getClass(cls), &methodCount);

    for (unsigned int i = 0; i < methodCount; i++) {
      Method method = methods[i];
      SEL selector = method_getName(method);
      if ([NSStringFromSelector(selector) hasPrefix:@"__rct_export__"]) {
        IMP imp = method_getImplementation(method);
        const ABI50_0_0RCTMethodInfo *methodInfo = ((const ABI50_0_0RCTMethodInfo *(*)(id, SEL))imp)(moduleClass, selector);
        methodInfos.push_back(methodInfo);
      }
    }

    free(methods);
    cls = class_getSuperclass(cls);
  }

  return methodInfos;
}

NSString *getJSMethodName(const ABI50_0_0RCTMethodInfo *methodInfo)
{
  std::string jsName = methodInfo->jsName;
  if (jsName != "") {
    return @(jsName.c_str());
  }

  NSString *methodName = @(methodInfo->objcName);
  NSRange colonRange = [methodName rangeOfString:@":"];
  if (colonRange.location != NSNotFound) {
    methodName = [methodName substringToIndex:colonRange.location];
  }
  methodName = [methodName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  ABI50_0_0RCTAssert(
      methodName.length,
      @"%s is not a valid JS function name, please"
       " supply an alternative using ABI50_0_0RCT_REMAP_METHOD()",
      methodInfo->objcName);

  return methodName;
}

class ObjCInteropTurboModuleParseException : public std::runtime_error {
 public:
  ObjCInteropTurboModuleParseException(std::string moduleName, std::string methodName, std::string message)
      : std::runtime_error(
            "Failed to create module \"" + moduleName + "\": Error while parsing method " + moduleName + "." +
            methodName + ": " + message)
  {
  }
};

struct ExportedMethod {
  NSString *methodName;
  NSArray<NSString *> *argumentTypes;
  std::string returnType;
  SEL selector;
};

std::vector<ExportedMethod> parseExportedMethods(std::string moduleName, Class moduleClass)
{
  std::vector<const ABI50_0_0RCTMethodInfo *> methodInfos = getMethodInfos(moduleClass);
  std::vector<ExportedMethod> methods;
  methods.reserve(methodInfos.size());

  for (const ABI50_0_0RCTMethodInfo *methodInfo : methodInfos) {
    NSString *jsMethodName = getJSMethodName(methodInfo);
    NSArray<ABI50_0_0RCTMethodArgument *> *arguments;
    SEL objCMethodSelector = NSSelectorFromString(ABI50_0_0RCTParseMethodSignature(methodInfo->objcName, &arguments));
    NSMethodSignature *objCMethodSignature = [moduleClass instanceMethodSignatureForSelector:objCMethodSelector];
    std::string objCMethodReturnType = [objCMethodSignature methodReturnType];

    if (objCMethodSignature.numberOfArguments - 2 != [arguments count]) {
      std::string message = "Parsed argument count (i.e: " + std::to_string([arguments count]) +
          ") != Objective C method signature argument count (i.e: " +
          std::to_string(objCMethodSignature.numberOfArguments - 2) + ").";
      throw ObjCInteropTurboModuleParseException(moduleName, [jsMethodName UTF8String], message);
    }

    NSMutableArray<NSString *> *argumentTypes = [NSMutableArray new];
    for (NSUInteger i = 0; i < [arguments count]; i += 1) {
      [argumentTypes addObject:arguments[i].type];
    }

    if ([argumentTypes count] == 1) {
      std::string lastArgType = [argumentTypes[[argumentTypes count] - 1] UTF8String];
      if (lastArgType == "ABI50_0_0RCTPromiseResolveBlock" || lastArgType == "ABI50_0_0RCTPromiseRejectBlock") {
        std::string message =
            "Methods that return promises must accept a ABI50_0_0RCTPromiseResolveBlock followed by a ABI50_0_0RCTPromiseRejectBlock. This method just accepts a " +
            lastArgType + ".";
        throw ObjCInteropTurboModuleParseException(moduleName, [jsMethodName UTF8String], message);
      }
    } else if ([argumentTypes count] > 1) {
      std::string lastArgType = [argumentTypes[[argumentTypes count] - 1] UTF8String];
      std::string secondLastArgType = [argumentTypes[[argumentTypes count] - 2] UTF8String];
      if ((secondLastArgType == "ABI50_0_0RCTPromiseResolveBlock" && lastArgType != "ABI50_0_0RCTPromiseRejectBlock") ||
          (secondLastArgType != "ABI50_0_0RCTPromiseResolveBlock" && lastArgType == "ABI50_0_0RCTPromiseRejectBlock")) {
        std::string message =
            "Methods that return promises must accept a ABI50_0_0RCTPromiseResolveBlock followed by a ABI50_0_0RCTPromiseRejectBlock. This method accepts a " +
            secondLastArgType + " followed by a " + lastArgType + ".";
        throw ObjCInteropTurboModuleParseException(moduleName, [jsMethodName UTF8String], message);
      }
    }

    methods.push_back(
        {.methodName = jsMethodName,
         .argumentTypes = argumentTypes,
         .returnType = objCMethodReturnType,
         .selector = objCMethodSelector});
  }

  return methods;
}

SEL selectorForType(NSString *type)
{
  const char *input = type.UTF8String;
  return NSSelectorFromString([ABI50_0_0RCTParseType(&input) stringByAppendingString:@":"]);
}

template <typename T>
T ABI50_0_0RCTConvertTo(SEL selector, id json)
{
  T (*convert)(id, SEL, id) = (__typeof__(convert))objc_msgSend;
  return convert([ABI50_0_0RCTConvert class], selector, json);
}

} // namespace

ObjCInteropTurboModule::ObjCInteropTurboModule(const ObjCTurboModule::InitParams &params)
    : ObjCTurboModule(params), constantsCache_(jsi::Value::undefined())
{
  std::vector<ExportedMethod> methods = parseExportedMethods(name_, [params.instance class]);
  methodDescriptors_.reserve(methods.size());

  NSMutableDictionary<NSString *, NSArray<NSString *> *> *methodArgTypeNames = [NSMutableDictionary new];
  methodArgumentTypeNames_ = methodArgTypeNames;

  for (const ExportedMethod &method : methods) {
    const int numArgs = [method.argumentTypes count];
    const bool isPromiseMethod =
        numArgs >= 2 && [method.argumentTypes[numArgs - 1] isEqualToString:@"ABI50_0_0RCTPromiseRejectBlock"];

    const int jsArgCount = isPromiseMethod ? numArgs - 2 : numArgs;

    /**
     * In the TurboModule system, only promises and voids are special. So, set those.
     * In the else case, just assume ObjectKind. This will be ignored by the interop layer.
     * In the else case, the interop layer will just call into ::convertReturnIdToJSIValue()
     */
    const TurboModuleMethodValueKind returnKind = isPromiseMethod ? PromiseKind
        : method.returnType == @encode(void)                      ? VoidKind
                                                                  : ObjectKind;

    methodMap_[[method.methodName UTF8String]] = MethodMetadata{static_cast<size_t>(jsArgCount), nullptr};

    for (NSUInteger i = 0; i < numArgs; i += 1) {
      NSString *typeName = method.argumentTypes[i];

      if ([typeName hasPrefix:@"ABI50_0_0JS::"]) {
        NSString *rctCxxConvertSelector =
            [[typeName stringByReplacingOccurrencesOfString:@"::" withString:@"_"] stringByAppendingString:@":"];
        setMethodArgConversionSelector(method.methodName, i, rctCxxConvertSelector);
      }
    }

    methodArgTypeNames[method.methodName] = method.argumentTypes;
    methodDescriptors_.push_back({
        .methodName = [method.methodName UTF8String],
        .selector = method.selector,
        .jsArgCount = jsArgCount,
        .jsReturnKind = returnKind,
    });
  }

  if ([params.instance respondsToSelector:@selector(constantsToExport)]) {
    methodDescriptors_.push_back({
      .methodName = "getConstants", .selector = @selector(constantsToExport), .jsArgCount = 0,
      .jsReturnKind = ObjectKind,
    });
  } else {
    static SEL getConstantsSelector = NSSelectorFromString(@"getConstants");
    if ([params.instance respondsToSelector:getConstantsSelector]) {
      methodDescriptors_.push_back({
          .methodName = "getConstants",
          .selector = getConstantsSelector,
          .jsArgCount = 0,
          .jsReturnKind = ObjectKind,
      });
    }
  }
}

jsi::Value ObjCInteropTurboModule::create(jsi::Runtime &runtime, const jsi::PropNameID &propName)
{
  for (size_t i = 0; i < methodDescriptors_.size(); i += 1) {
    if (methodDescriptors_[i].methodName == propName.utf8(runtime)) {
      if (propName.utf8(runtime) == "getConstants") {
        return jsi::Function::createFromHostFunction(
            runtime,
            propName,
            static_cast<unsigned int>(methodDescriptors_[i].jsArgCount),
            [this, i](jsi::Runtime &rt, const jsi::Value &thisVal, const jsi::Value *args, size_t count) mutable {
              if (!this->constantsCache_.isUndefined()) {
                return jsi::Value(rt, this->constantsCache_);
              }

              // TODO: Dispatch getConstants to the main queue, if the module requires main queue setup
              jsi::Value ret = this->invokeObjCMethod(
                  rt,
                  this->methodDescriptors_[i].jsReturnKind,
                  this->methodDescriptors_[i].methodName,
                  this->methodDescriptors_[i].selector,
                  args,
                  count);

              bool isRetValid = ret.isUndefined() || ret.isNull() ||
                  (ret.isObject() && !ret.asObject(rt).isFunction(rt) && !ret.asObject(rt).isArray(rt));

              if (!isRetValid) {
                std::string methodJsSignature = name_ + ".getConstants()";
                std::string errorPrefix = methodJsSignature + ": ";
                throw jsi::JSError(
                    rt,
                    errorPrefix + "Expected return value to be null, undefined, or a plain object. But, got: " +
                        getType(rt, ret));
              }

              if (ret.isUndefined() || ret.isNull()) {
                this->constantsCache_ = jsi::Object(rt);
              } else {
                this->constantsCache_ = jsi::Value(rt, ret);
              }

              return ret;
            });
      }

      return jsi::Function::createFromHostFunction(
          runtime,
          propName,
          static_cast<unsigned int>(methodDescriptors_[i].jsArgCount),
          [this, i](jsi::Runtime &rt, const jsi::Value &thisVal, const jsi::Value *args, size_t count) {
            return this->invokeObjCMethod(
                rt,
                this->methodDescriptors_[i].jsReturnKind,
                this->methodDescriptors_[i].methodName,
                this->methodDescriptors_[i].selector,
                args,
                count);
          });
    }
  }

  jsi::Object constants = getConstants(runtime).asObject(runtime);
  jsi::Value constant = constants.getProperty(runtime, propName);

  if (!constant.isUndefined()) {
    // TODO(T145105887): Output warning. Tried to access a constant as a
    // property on the native module object. Please migrate to getConstants().
  }

  return constant;
}

void ObjCInteropTurboModule::setInvocationArg(
    jsi::Runtime &runtime,
    const char *methodNameCStr,
    const std::string &objCArgType,
    const jsi::Value &jsiArg,
    size_t index,
    NSInvocation *inv,
    NSMutableArray *retainedObjectsForInvocation)
{
  NSString *methodName = @(methodNameCStr);
  std::string methodJsSignature = name_ + "." + methodNameCStr + "()";

  NSString *argumentType = getArgumentTypeName(runtime, methodName, index);
  std::string errorPrefix = methodJsSignature + ": Error while converting JavaScript argument " +
      std::to_string(index) + " to Objective C type " + [argumentType UTF8String] + ". ";

  SEL selector = selectorForType(argumentType);

  if ([ABI50_0_0RCTConvert respondsToSelector:selector]) {
    id objCArg = TurboModuleConvertUtils::convertJSIValueToObjCObject(runtime, jsiArg, jsInvoker_);

    if (objCArgType == @encode(char)) {
      char arg = ABI50_0_0RCTConvertTo<char>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(unsigned char)) {
      unsigned char arg = ABI50_0_0RCTConvertTo<unsigned char>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(short)) {
      short arg = ABI50_0_0RCTConvertTo<short>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(unsigned short)) {
      unsigned short arg = ABI50_0_0RCTConvertTo<unsigned short>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(int)) {
      int arg = ABI50_0_0RCTConvertTo<int>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(unsigned int)) {
      unsigned int arg = ABI50_0_0RCTConvertTo<unsigned int>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(long)) {
      long arg = ABI50_0_0RCTConvertTo<long>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(unsigned long)) {
      unsigned long arg = ABI50_0_0RCTConvertTo<unsigned long>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(long long)) {
      long long arg = ABI50_0_0RCTConvertTo<long long>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(unsigned long long)) {
      unsigned long long arg = ABI50_0_0RCTConvertTo<unsigned long long>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(float)) {
      float arg = ABI50_0_0RCTConvertTo<float>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(double)) {
      double arg = ABI50_0_0RCTConvertTo<double>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(BOOL)) {
      BOOL arg = ABI50_0_0RCTConvertTo<BOOL>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(SEL)) {
      SEL arg = ABI50_0_0RCTConvertTo<SEL>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(const char *)) {
      const char *arg = ABI50_0_0RCTConvertTo<const char *>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(void *)) {
      void *arg = ABI50_0_0RCTConvertTo<void *>(selector, objCArg);
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType == @encode(id)) {
      id arg = ABI50_0_0RCTConvertTo<id>(selector, objCArg);
      if (arg) {
        [retainedObjectsForInvocation addObject:arg];
      }
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    if (objCArgType[0] == _C_STRUCT_B) {
      NSMethodSignature *typeSignature = [ABI50_0_0RCTConvert methodSignatureForSelector:selector];
      NSInvocation *typeInvocation = [NSInvocation invocationWithMethodSignature:typeSignature];
      typeInvocation.selector = selector;
      typeInvocation.target = [ABI50_0_0RCTConvert class];

      void *returnValue = malloc(typeSignature.methodReturnLength);
      if (!returnValue) {
        // CWE - 391 : Unchecked error condition
        // https://www.cvedetails.com/cwe-details/391/Unchecked-Error-Condition.html
        // https://eli.thegreenplace.net/2009/10/30/handling-out-of-memory-conditions-in-c
        abort();
      }
      [typeInvocation setArgument:&objCArg atIndex:2];
      [typeInvocation invoke];

      [typeInvocation getReturnValue:returnValue];
      [inv setArgument:returnValue atIndex:index + 2];
      free(returnValue);
      return;
    }

    const char *BLOCK_TYPE = @encode(__typeof__(^{
    }));

    if (objCArgType == BLOCK_TYPE) {
      /**
       * ABI50_0_0RCTModuleMethod doesn't actually call into ABI50_0_0RCTConvert in this case.
       */
      id arg = [objCArg copy];
      if (arg) {
        [retainedObjectsForInvocation addObject:arg];
      }
      [inv setArgument:&arg atIndex:(index) + 2];
      return;
    }

    throw jsi::JSError(runtime, errorPrefix + "Objective C type " + [argumentType UTF8String] + " is unsupported.");
  }

  if ([argumentType isEqualToString:@"ABI50_0_0RCTResponseSenderBlock"]) {
    if (!(jsiArg.isObject() && jsiArg.asObject(runtime).isFunction(runtime))) {
      throw jsi::JSError(
          runtime, errorPrefix + "JavaScript argument must be a function. Got " + getType(runtime, jsiArg));
    }

    ABI50_0_0RCTResponseSenderBlock arg =
        (ABI50_0_0RCTResponseSenderBlock)TurboModuleConvertUtils::convertJSIValueToObjCObject(runtime, jsiArg, jsInvoker_);
    if (arg) {
      [retainedObjectsForInvocation addObject:arg];
    }
    [inv setArgument:&arg atIndex:(index) + 2];
    return;
  }

  if ([argumentType isEqualToString:@"ABI50_0_0RCTResponseErrorBlock"]) {
    if (!(jsiArg.isObject() && jsiArg.asObject(runtime).isFunction(runtime))) {
      throw jsi::JSError(
          runtime, errorPrefix + "JavaScript argument must be a function. Got " + getType(runtime, jsiArg));
    }

    ABI50_0_0RCTResponseSenderBlock senderBlock =
        (ABI50_0_0RCTResponseSenderBlock)TurboModuleConvertUtils::convertJSIValueToObjCObject(runtime, jsiArg, jsInvoker_);
    ABI50_0_0RCTResponseErrorBlock arg = ^(NSError *error) {
      senderBlock(@[ ABI50_0_0RCTJSErrorFromNSError(error) ]);
    };
    [retainedObjectsForInvocation addObject:arg];
    [inv setArgument:&arg atIndex:(index) + 2];
    return;
  }

  if ([argumentType isEqualToString:@"ABI50_0_0RCTPromiseResolveBlock"] ||
      [argumentType isEqualToString:@"ABI50_0_0RCTPromiseRejectBlock"]) {
    throw jsi::JSError(
        runtime,
        errorPrefix + "The TurboModule interop layer should not convert JavaScript arguments to " +
            [argumentType UTF8String] +
            " inside ObjCinteropTurboModule::setInvocationArg(). Please report this as an issue.");
  }

  if ([argumentType hasPrefix:@"ABI50_0_0JS::"]) {
    NSString *selectorNameForCxxType =
        [[argumentType stringByReplacingOccurrencesOfString:@"::" withString:@"_"] stringByAppendingString:@":"];
    selector = NSSelectorFromString(selectorNameForCxxType);

    bool isPlainObject = jsiArg.isObject() && !jsiArg.asObject(runtime).isFunction(runtime) &&
        !jsiArg.asObject(runtime).isArray(runtime);
    if (!isPlainObject) {
      throw jsi::JSError(
          runtime, errorPrefix + "JavaScript argument must be a plain object. Got " + getType(runtime, jsiArg));
    }

    id arg = TurboModuleConvertUtils::convertJSIValueToObjCObject(runtime, jsiArg, jsInvoker_);

    ABI50_0_0RCTManagedPointer *(*convert)(id, SEL, id) = (__typeof__(convert))objc_msgSend;
    ABI50_0_0RCTManagedPointer *box = convert([ABI50_0_0RCTCxxConvert class], selector, arg);

    void *pointer = box.voidPointer;
    [inv setArgument:&pointer atIndex:index + 2];
    [retainedObjectsForInvocation addObject:box];
    return;
  }
}

jsi::Value ObjCInteropTurboModule::convertReturnIdToJSIValue(
    jsi::Runtime &runtime,
    const char *methodNameCStr,
    TurboModuleMethodValueKind returnType,
    id result)
{
  std::string methodJsSignature = name_ + "." + methodNameCStr + "()";
  std::string errorPrefix =
      methodJsSignature + ": Error while converting return Objective C value to JavaScript type. ";

  if (returnType == VoidKind) {
    return jsi::Value::undefined();
  }

  if (result == (id)kCFNull || result == nil) {
    return jsi::Value::null();
  }

  jsi::Value returnValue = TurboModuleConvertUtils::convertObjCObjectToJSIValue(runtime, result);
  if (!returnValue.isUndefined()) {
    return returnValue;
  }

  throw jsi::JSError(runtime, methodJsSignature + "Objective C type was unsupported.");
}

NSString *ObjCInteropTurboModule::getArgumentTypeName(jsi::Runtime &runtime, NSString *methodName, int argIndex)
{
  const char *methodNameCStr = [methodName UTF8String];
  std::string methodJsSignature = name_ + "." + methodNameCStr + "()";
  std::string errorPrefix =
      methodJsSignature + ": Error while trying to get Objective C type of parameter " + std::to_string(argIndex) + ".";

  if (methodArgumentTypeNames_[methodName] == nil) {
    throw jsi::JSError(runtime, errorPrefix + "No parameter types found for method.");
  }

  if ([methodArgumentTypeNames_[methodName] count] <= argIndex) {
    int paramCount = [methodArgumentTypeNames_[methodName] count];
    throw jsi::JSError(runtime, errorPrefix + "Method has only " + std::to_string(paramCount) + " parameter types.");
  }

  return methodArgumentTypeNames_[methodName][argIndex];
}

bool ObjCInteropTurboModule::exportsConstants()
{
  for (size_t i = 0; i < methodDescriptors_.size(); i += 1) {
    if (methodDescriptors_[i].methodName == "getConstants") {
      return true;
    }
  }

  return false;
}

const jsi::Value &ObjCInteropTurboModule::getConstants(jsi::Runtime &runtime)
{
  if (!constantsCache_.isUndefined()) {
    return constantsCache_;
  }

  if (!exportsConstants()) {
    constantsCache_ = jsi::Object(runtime);
    return constantsCache_;
  }

  jsi::Value getConstantsProp = get(runtime, jsi::PropNameID::forAscii(runtime, "getConstants"));

  if (getConstantsProp.isObject()) {
    jsi::Object getConstantsObj = getConstantsProp.asObject(runtime);
    if (getConstantsObj.isFunction(runtime)) {
      jsi::Function getConstantsFn = getConstantsObj.asFunction(runtime);
      getConstantsFn.call(runtime);
      return constantsCache_;
    }
  }

  // Unable to invoke the getConstants() method.
  // Maybe the module didn't define a getConstants() method.
  // Default constants to {}, so no constants are spread into the NativeModule
  constantsCache_ = jsi::Object(runtime);
  return constantsCache_;
}

std::vector<ABI50_0_0facebook::jsi::PropNameID> ObjCInteropTurboModule::getPropertyNames(ABI50_0_0facebook::jsi::Runtime &runtime)
{
  std::vector<ABI50_0_0facebook::jsi::PropNameID> propNames = ObjCTurboModule::getPropertyNames(runtime);

  jsi::Object constants = getConstants(runtime).asObject(runtime);
  jsi::Array constantNames = constants.getPropertyNames(runtime);

  for (size_t i = 0; i < constantNames.size(runtime); i += 1) {
    jsi::Value constantName = constantNames.getValueAtIndex(runtime, i);
    if (constantName.isString()) {
      propNames.push_back(jsi::PropNameID::forString(runtime, constantName.asString(runtime)));
    }
  }

  return propNames;
}

} // namespace ABI50_0_0React
} // namespace ABI50_0_0facebook
