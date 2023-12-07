/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0ReactNativeConfig.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

/**
 * ABI50_0_0ReactNative configuration as provided by the hosting app.
 * Provide a sub-class implementation to allow app specific customization.
 */
ABI50_0_0ReactNativeConfig::ABI50_0_0ReactNativeConfig() {}

ABI50_0_0ReactNativeConfig::~ABI50_0_0ReactNativeConfig() {}

EmptyABI50_0_0ReactNativeConfig::EmptyABI50_0_0ReactNativeConfig() {}

bool EmptyABI50_0_0ReactNativeConfig::getBool(const std::string& param) const {
  if (param == "ABI50_0_0React_fabric:enabled_layout_animations_ios") {
    return true;
  }
  return false;
}

std::string EmptyABI50_0_0ReactNativeConfig::getString(const std::string& param) const {
  return "";
}

int64_t EmptyABI50_0_0ReactNativeConfig::getInt64(const std::string& param) const {
  return 0;
}

double EmptyABI50_0_0ReactNativeConfig::getDouble(const std::string& param) const {
  return 0.0;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
