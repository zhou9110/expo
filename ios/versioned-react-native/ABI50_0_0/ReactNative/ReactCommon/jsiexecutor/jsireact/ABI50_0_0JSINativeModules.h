/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>
#include <string>

#include <ABI50_0_0cxxreact/ABI50_0_0ModuleRegistry.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <optional>

namespace ABI50_0_0facebook::ABI50_0_0React {

/**
 * Holds and creates JS representations of the modules in ModuleRegistry
 */
class JSINativeModules {
 public:
  explicit JSINativeModules(std::shared_ptr<ModuleRegistry> moduleRegistry);
  jsi::Value getModule(jsi::Runtime& rt, const jsi::PropNameID& name);
  void reset();

 private:
  std::optional<jsi::Function> m_genNativeModuleJS;
  std::shared_ptr<ModuleRegistry> m_moduleRegistry;
  std::unordered_map<std::string, jsi::Object> m_objects;

  std::optional<jsi::Object> createModule(
      jsi::Runtime& rt,
      const std::string& name);
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
