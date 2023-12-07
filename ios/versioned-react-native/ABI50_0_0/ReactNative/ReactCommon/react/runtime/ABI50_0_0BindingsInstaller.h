/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/runtime/ABI50_0_0ReactInstance.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class BindingsInstaller {
 public:
  virtual ABI50_0_0ReactInstance::BindingsInstallFunc getBindingsInstallFunc() {
    return nullptr;
  }
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
