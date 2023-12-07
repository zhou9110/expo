/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0yoga/ABI50_0_0Yoga.h>
#include <ABI50_0_0yoga/config/ABI50_0_0Config.h>
#include <ABI50_0_0yoga/node/ABI50_0_0Node.h>

namespace ABI50_0_0facebook::yoga {

[[noreturn]] void fatalWithMessage(const char* message);

void assertFatal(bool condition, const char* message);
void assertFatalWithNode(
    const yoga::Node* node,
    bool condition,
    const char* message);
void assertFatalWithConfig(
    const yoga::Config* config,
    bool condition,
    const char* message);

} // namespace ABI50_0_0facebook::yoga
