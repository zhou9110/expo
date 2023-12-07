/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#ifdef DEBUG

#pragma once

#include <string>

#include <ABI50_0_0yoga/enums/ABI50_0_0PrintOptions.h>
#include <ABI50_0_0yoga/node/ABI50_0_0Node.h>

namespace ABI50_0_0facebook::yoga {

void nodeToString(
    std::string& str,
    const yoga::Node* node,
    PrintOptions options,
    uint32_t level);

void print(const yoga::Node* node, PrintOptions options);

} // namespace ABI50_0_0facebook::yoga

#endif
