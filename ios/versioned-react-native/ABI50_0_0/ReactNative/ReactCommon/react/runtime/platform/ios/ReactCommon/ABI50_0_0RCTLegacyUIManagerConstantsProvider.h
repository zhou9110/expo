/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

namespace ABI50_0_0facebook::ABI50_0_0React {
/*
 * Installs UIManger constants provider into JavaScript runtime. This is needed
 * to implement UIManager.getConstants in bridgeless mode. The constants object
 * contains view configs for every legacy native component.
 */
void installLegacyUIManagerConstantsProviderBinding(jsi::Runtime& runtime);
} // namespace ABI50_0_0facebook::ABI50_0_0React
