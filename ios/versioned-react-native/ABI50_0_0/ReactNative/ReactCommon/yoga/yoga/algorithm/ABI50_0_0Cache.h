/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0yoga/config/ABI50_0_0Config.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0MeasureMode.h>

namespace ABI50_0_0facebook::yoga {

bool canUseCachedMeasurement(
    MeasureMode widthMode,
    float availableWidth,
    MeasureMode heightMode,
    float availableHeight,
    MeasureMode lastWidthMode,
    float lastAvailableWidth,
    MeasureMode lastHeightMode,
    float lastAvailableHeight,
    float lastComputedWidth,
    float lastComputedHeight,
    float marginRow,
    float marginColumn,
    const yoga::Config* config);

} // namespace ABI50_0_0facebook::yoga
