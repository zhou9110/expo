/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#ifdef HERMES_ENABLE_DEBUGGER

#include <memory>
#include <mutex>
#include <string>
#include <unordered_map>
#include <unordered_set>

#include <hermes/ABI50_0_0hermes.h>
#include <hermes/inspector-modern/chrome/ABI50_0_0Registration.h>
#include <hermes/inspector/ABI50_0_0RuntimeAdapter.h>
#include <hermes/inspector/chrome/ABI50_0_0CDPHandler.h>
#include <ABI50_0_0jsinspector-modern/ABI50_0_0InspectorInterfaces.h>

namespace ABI50_0_0facebook {
namespace ABI50_0_0hermes {
namespace inspector_modern {
namespace chrome {

/*
 * ConnectionDemux keeps track of all debuggable Hermes runtimes (called
 * "pages" in the higher-level ABI50_0_0React Native API) in this process. See
 * Registration.h for documentation of the public API.
 */
class ConnectionDemux {
 public:
  explicit ConnectionDemux(
      ABI50_0_0facebook::ABI50_0_0React::jsinspector_modern::IInspector &inspector);
  ~ConnectionDemux();

  ConnectionDemux(const ConnectionDemux &) = delete;
  ConnectionDemux &operator=(const ConnectionDemux &) = delete;

  DebugSessionToken enableDebugging(
      std::unique_ptr<RuntimeAdapter> adapter,
      const std::string &title);
  void disableDebugging(DebugSessionToken session);

 private:
  int addPage(
      std::shared_ptr<ABI50_0_0hermes::inspector_modern::chrome::CDPHandler> conn);
  void removePage(int pageId);

  ABI50_0_0facebook::ABI50_0_0React::jsinspector_modern::IInspector &globalInspector_;

  std::mutex mutex_;
  std::unordered_map<
      int,
      std::shared_ptr<ABI50_0_0hermes::inspector_modern::chrome::CDPHandler>>
      conns_;
  std::shared_ptr<std::unordered_set<std::string>> inspectedContexts_;
};

} // namespace chrome
} // namespace inspector_modern
} // namespace ABI50_0_0hermes
} // namespace ABI50_0_0facebook

#endif // HERMES_ENABLE_DEBUGGER
