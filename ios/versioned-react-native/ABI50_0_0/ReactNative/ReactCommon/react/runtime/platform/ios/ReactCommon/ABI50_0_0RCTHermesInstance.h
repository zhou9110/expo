/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0cxxreact/ABI50_0_0MessageQueueThread.h>
#import <ABI50_0_0hermes/ABI50_0_0Public/CrashManager.h>
#import <ABI50_0_0jsi/ABI50_0_0jsi.h>
#import <ABI50_0_0React/runtime/ABI50_0_0JSEngineInstance.h>
#import <ABI50_0_0React/runtime/hermes/ABI50_0_0HermesInstance.h>

namespace ABI50_0_0facebook {
namespace ABI50_0_0React {
using CrashManagerProvider =
    std::function<std::shared_ptr<::ABI50_0_0hermes::vm::CrashManager>()>;

// ObjC++ wrapper for HermesInstance.cpp
class ABI50_0_0RCTHermesInstance : public JSEngineInstance {
 public:
  ABI50_0_0RCTHermesInstance();
  ABI50_0_0RCTHermesInstance(
      std::shared_ptr<const ABI50_0_0ReactNativeConfig> ABI50_0_0ReactNativeConfig,
      CrashManagerProvider crashManagerProvider);

  std::unique_ptr<jsi::Runtime> createJSRuntime(
      std::shared_ptr<MessageQueueThread> msgQueueThread) noexcept override;

  ~ABI50_0_0RCTHermesInstance(){};

 private:
  std::shared_ptr<const ABI50_0_0ReactNativeConfig> _ABI50_0_0ReactNativeConfig;
  CrashManagerProvider _crashManagerProvider;
  std::unique_ptr<HermesInstance> _hermesInstance;
};
} // namespace ABI50_0_0React
} // namespace ABI50_0_0facebook
