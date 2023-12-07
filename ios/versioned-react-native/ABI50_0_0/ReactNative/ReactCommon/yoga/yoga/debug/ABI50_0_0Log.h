/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0yoga/ABI50_0_0Yoga.h>

#include <ABI50_0_0yoga/config/ABI50_0_0Config.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0LogLevel.h>
#include <ABI50_0_0yoga/node/ABI50_0_0Node.h>

namespace ABI50_0_0facebook::yoga {

void log(LogLevel level, const char* format, ...) noexcept;

void log(
    const yoga::Node* node,
    LogLevel level,
    const char* message,
    ...) noexcept;

void log(
    const yoga::Config* config,
    LogLevel level,
    const char* format,
    ...) noexcept;

ABI50_0_0YGLogger getDefaultLogger();

} // namespace ABI50_0_0facebook::yoga
