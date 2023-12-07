/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <string>
#include <vector>

#include <ABI50_0_0ReactCommon/ABI50_0_0TurboModule.h>
#include <fbjni/fbjni.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include "ABI50_0_0JavaTurboModule.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

class JSI_EXPORT JavaInteropTurboModule : public JavaTurboModule {
 public:
  struct MethodDescriptor {
    std::string methodName;
    std::string jniSignature;
    TurboModuleMethodValueKind jsiReturnKind;
    int jsArgCount;
  };

  JavaInteropTurboModule(
      const JavaTurboModule::InitParams& params,
      std::vector<MethodDescriptor> methodDescriptors);

  std::vector<ABI50_0_0facebook::jsi::PropNameID> getPropertyNames(
      ABI50_0_0facebook::jsi::Runtime& runtime) override;

 protected:
  jsi::Value create(jsi::Runtime& runtime, const jsi::PropNameID& propName)
      override;

 private:
  std::vector<MethodDescriptor> methodDescriptors_;
  std::vector<jmethodID> methodIDs_;
  jsi::Value constantsCache_;

  const jsi::Value& getConstants(jsi::Runtime& runtime);
  bool exportsConstants();
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
