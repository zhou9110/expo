/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <cassert>
#include <string>

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include <ABI50_0_0ReactCommon/ABI50_0_0CallInvoker.h>
#include <ABI50_0_0ReactCommon/ABI50_0_0CallbackWrapper.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

jsi::Object deepCopyJSIObject(jsi::Runtime& rt, const jsi::Object& obj);
jsi::Array deepCopyJSIArray(jsi::Runtime& rt, const jsi::Array& arr);

struct Promise : public LongLivedObject {
  Promise(jsi::Runtime& rt, jsi::Function resolve, jsi::Function reject);

  void resolve(const jsi::Value& result);
  void reject(const std::string& error);

  jsi::Runtime& runtime_;
  jsi::Function resolve_;
  jsi::Function reject_;
};

using PromiseSetupFunctionType =
    std::function<void(jsi::Runtime& rt, std::shared_ptr<Promise>)>;
jsi::Value createPromiseAsJSIValue(
    jsi::Runtime& rt,
    PromiseSetupFunctionType&& func);

class RAIICallbackWrapperDestroyer {
 public:
  RAIICallbackWrapperDestroyer(std::weak_ptr<CallbackWrapper> callbackWrapper)
      : callbackWrapper_(callbackWrapper) {}

  ~RAIICallbackWrapperDestroyer() {
    auto strongWrapper = callbackWrapper_.lock();
    if (!strongWrapper) {
      return;
    }

    strongWrapper->destroy();
  }

 private:
  std::weak_ptr<CallbackWrapper> callbackWrapper_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
