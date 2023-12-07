/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <algorithm>
#include <cmath>
#include <vector>

#include <ABI50_0_0yoga/ABI50_0_0Yoga.h>

ABI50_0_0YG_EXTERN_C_BEGIN

// Deallocates a Yoga Node. Unlike ABI50_0_0YGNodeFree, does not remove the node from
// its parent or children.
ABI50_0_0YG_EXPORT void ABI50_0_0YGNodeDeallocate(ABI50_0_0YGNodeRef node);

ABI50_0_0YG_EXTERN_C_END
