/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

jsi::Value callMethodOfModule(
    jsi::Runtime& runtime,
    const std::string& moduleName,
    const std::string& methodName,
    std::initializer_list<jsi::Value> args);

} // namespace ABI50_0_0facebook::ABI50_0_0React
