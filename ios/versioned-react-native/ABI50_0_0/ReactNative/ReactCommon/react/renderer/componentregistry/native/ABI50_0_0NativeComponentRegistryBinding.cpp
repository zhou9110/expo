/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0NativeComponentRegistryBinding.h"

#include <ABI50_0_0React/bridging/ABI50_0_0Bridging.h>
#include <stdexcept>
#include <string>

namespace ABI50_0_0facebook::ABI50_0_0React {

/**
 * Public API to install the Native Component Registry bindings.
 */
void bindHasComponentProvider(
    jsi::Runtime& runtime,
    HasComponentProviderFunctionType&& provider) {
  runtime.global().setProperty(
      runtime,
      "__nativeComponentRegistry__hasComponent",
      bridging::toJs(runtime, provider, {}));
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
