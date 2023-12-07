/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <string>

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/**
 * An app/platform-specific provider function to determine if a component
 * is registered in the native platform.
 */
using HasComponentProviderFunctionType =
    std::function<bool(const std::string& name)>;

/*
 * Installs HasComponentProviderFunction into JavaScript runtime.
 * Thread synchronization must be enforced externally.
 */
void bindHasComponentProvider(
    jsi::Runtime& runtime,
    HasComponentProviderFunctionType&& provider);

} // namespace ABI50_0_0facebook::ABI50_0_0React
