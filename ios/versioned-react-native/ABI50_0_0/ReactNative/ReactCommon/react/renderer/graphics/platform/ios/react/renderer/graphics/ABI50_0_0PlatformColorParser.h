/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0RawProps.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Color.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0RCTPlatformColorUtils.h>
#include <unordered_map>

namespace ABI50_0_0facebook::ABI50_0_0React {

inline SharedColor parsePlatformColor(
    const PropsParserContext& context,
    const RawValue& value) {
  if (value.hasType<std::unordered_map<std::string, RawValue>>()) {
    auto items = (std::unordered_map<std::string, RawValue>)value;
    if (items.find("semantic") != items.end() &&
        items.at("semantic").hasType<std::vector<std::string>>()) {
      auto semanticItems = (std::vector<std::string>)items.at("semantic");
      return {colorFromComponents(
          ABI50_0_0RCTPlatformColorComponentsFromSemanticItems(semanticItems))};
    }
  }

  return clearColor();
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
