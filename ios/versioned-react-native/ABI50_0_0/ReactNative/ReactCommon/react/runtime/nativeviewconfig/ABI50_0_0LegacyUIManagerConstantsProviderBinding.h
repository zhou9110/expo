/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

namespace ABI50_0_0facebook::ABI50_0_0React::LegacyUIManagerConstantsProviderBinding {

using ProviderType = std::function<jsi::Value()>;

/*
 * Installs ABI50_0_0RN$LegacyInterop_UIManager_getConstants binding into JavaScript
 * runtime. It is supposed to be used as a substitute to UIManager.getConstants
 * in bridgeless mode.
 */
void install(jsi::Runtime& runtime, ProviderType&& provider);
} // namespace ABI50_0_0facebook::ABI50_0_0React::LegacyUIManagerConstantsProviderBinding
