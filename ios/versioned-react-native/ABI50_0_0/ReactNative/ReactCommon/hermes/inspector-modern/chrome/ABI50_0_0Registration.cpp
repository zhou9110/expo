/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0Registration.h"
#include "ABI50_0_0ConnectionDemux.h"

#ifdef HERMES_ENABLE_DEBUGGER

namespace ABI50_0_0facebook {
namespace ABI50_0_0hermes {
namespace inspector_modern {
namespace chrome {

namespace {

ConnectionDemux &demux() {
  static ConnectionDemux instance{
      ABI50_0_0facebook::ABI50_0_0React::jsinspector_modern::getInspectorInstance()};
  return instance;
}

} // namespace

DebugSessionToken enableDebugging(
    std::unique_ptr<RuntimeAdapter> adapter,
    const std::string &title) {
  return demux().enableDebugging(std::move(adapter), title);
}

void disableDebugging(DebugSessionToken session) {
  demux().disableDebugging(session);
}

} // namespace chrome
} // namespace inspector_modern
} // namespace ABI50_0_0hermes
} // namespace ABI50_0_0facebook

#endif // HERMES_ENABLE_DEBUGGER
