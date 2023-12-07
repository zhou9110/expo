/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0RCTJSIExecutorRuntimeInstaller.h"

#import <ABI50_0_0React/ABI50_0_0RCTLog.h>
#include <chrono>

namespace ABI50_0_0facebook::ABI50_0_0React {

JSIExecutor::RuntimeInstaller ABI50_0_0RCTJSIExecutorRuntimeInstaller(JSIExecutor::RuntimeInstaller runtimeInstallerToWrap)
{
  return [runtimeInstaller = runtimeInstallerToWrap](jsi::Runtime &runtime) {
    Logger iosLoggingBinder = [](const std::string &message, unsigned int logLevel) {
      _ABI50_0_0RCTLogJavaScriptInternal(static_cast<ABI50_0_0RCTLogLevel>(logLevel), [NSString stringWithUTF8String:message.c_str()]);
    };
    bindNativeLogger(runtime, iosLoggingBinder);

    // Wrap over the original runtimeInstaller
    if (runtimeInstaller) {
      runtimeInstaller(runtime);
    }
  };
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
