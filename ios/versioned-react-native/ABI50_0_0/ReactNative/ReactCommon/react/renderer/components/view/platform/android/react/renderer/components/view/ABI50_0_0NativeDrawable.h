/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/debug/ABI50_0_0React_native_expect.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Float.h>
#include <unordered_map>

namespace ABI50_0_0facebook::ABI50_0_0React {

struct NativeDrawable {
  enum class Kind : uint8_t {
    Ripple,
    ThemeAttr,
  };

  struct Ripple {
    std::optional<int32_t> color{};
    std::optional<Float> rippleRadius{};
    bool borderless{false};

    bool operator==(const Ripple& rhs) const {
      return std::tie(this->color, this->borderless, this->rippleRadius) ==
          std::tie(rhs.color, rhs.borderless, rhs.rippleRadius);
    }
  };

  std::string themeAttr;
  Ripple ripple;
  Kind kind;

  bool operator==(const NativeDrawable& rhs) const {
    if (this->kind != rhs.kind) {
      return false;
    }

    switch (this->kind) {
      case Kind::ThemeAttr:
        return this->themeAttr == rhs.themeAttr;
      case Kind::Ripple:
        return this->ripple == rhs.ripple;
    }
  }

  bool operator!=(const NativeDrawable& rhs) const {
    return !(*this == rhs);
  }

  ~NativeDrawable() = default;
};

static inline void fromRawValue(
    const PropsParserContext& /*context*/,
    const RawValue& rawValue,
    NativeDrawable& result) {
  auto map = (std::unordered_map<std::string, RawValue>)rawValue;

  auto typeIterator = map.find("type");
  ABI50_0_0React_native_expect(
      typeIterator != map.end() && typeIterator->second.hasType<std::string>());
  std::string type = (std::string)typeIterator->second;

  if (type == "ThemeAttrAndroid") {
    auto attrIterator = map.find("attribute");
    ABI50_0_0React_native_expect(
        attrIterator != map.end() &&
        attrIterator->second.hasType<std::string>());

    result = NativeDrawable{
        (std::string)attrIterator->second,
        {},
        NativeDrawable::Kind::ThemeAttr,
    };
  } else if (type == "RippleAndroid") {
    auto color = map.find("color");
    auto borderless = map.find("borderless");
    auto rippleRadius = map.find("rippleRadius");

    result = NativeDrawable{
        std::string{},
        NativeDrawable::Ripple{
            color != map.end() && color->second.hasType<int32_t>()
                ? (int32_t)color->second
                : std::optional<int32_t>{},
            rippleRadius != map.end() && rippleRadius->second.hasType<Float>()
                ? (Float)rippleRadius->second
                : std::optional<Float>{},
            borderless != map.end() && borderless->second.hasType<bool>()
                ? (bool)borderless->second
                : false,
        },
        NativeDrawable::Kind::Ripple,
    };
  } else {
    LOG(ERROR) << "Unknown native drawable type: " << type;
    ABI50_0_0React_native_expect(false);
  }
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
