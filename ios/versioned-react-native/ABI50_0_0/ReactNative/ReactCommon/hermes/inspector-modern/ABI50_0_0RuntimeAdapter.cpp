/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0RuntimeAdapter.h"

namespace ABI50_0_0facebook {
namespace ABI50_0_0hermes {
namespace inspector_modern {

RuntimeAdapter::~RuntimeAdapter() = default;

void RuntimeAdapter::tickleJs() {}

SharedRuntimeAdapter::SharedRuntimeAdapter(
    std::shared_ptr<HermesRuntime> runtime)
    : runtime_(std::move(runtime)) {}

SharedRuntimeAdapter::~SharedRuntimeAdapter() = default;

HermesRuntime &SharedRuntimeAdapter::getRuntime() {
  return *runtime_;
}

} // namespace inspector_modern
} // namespace ABI50_0_0hermes
} // namespace ABI50_0_0facebook
