/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <string>

#include <ABI50_0_0ReactCommon/ABI50_0_0TurboModule.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class BridgelessNativeModuleProxy;

/**
 * Represents the JavaScript binding for the TurboModule system.
 */
class TurboModuleBinding {
 public:
  /*
   * Installs TurboModuleBinding into JavaScript runtime.
   * Thread synchronization must be enforced externally.
   */
  static void install(
      jsi::Runtime& runtime,
      TurboModuleProviderFunctionType&& moduleProvider,
      TurboModuleProviderFunctionType&& legacyModuleProvider = nullptr);

  TurboModuleBinding(TurboModuleProviderFunctionType&& moduleProvider);
  virtual ~TurboModuleBinding();

 private:
  friend BridgelessNativeModuleProxy;

  /**
   * A lookup function exposed to JS to get an instance of a TurboModule
   * for the given name.
   */
  jsi::Value getModule(jsi::Runtime& runtime, const std::string& moduleName)
      const;

  TurboModuleProviderFunctionType moduleProvider_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
