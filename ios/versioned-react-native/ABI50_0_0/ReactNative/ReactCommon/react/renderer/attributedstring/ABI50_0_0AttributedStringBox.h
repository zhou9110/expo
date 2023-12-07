/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>

#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0AttributedString.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Represents an object storing a shared `AttributedString` or a shared pointer
 * to some opaque platform-specific object that can be used as an attributed
 * string. The class serves two main purposes:
 *  - Represent type-erased attributed string entity (which can be
 * platform-specific or platform-independent);
 *  - Represent a container that can be copied with constant complexity.
 */
class AttributedStringBox final {
 public:
  enum class Mode { Value, OpaquePointer };

  /*
   * Default constructor constructs an empty string.
   */
  AttributedStringBox();

  /*
   * Custom explicit constructors.
   */
  explicit AttributedStringBox(const AttributedString& value);
  explicit AttributedStringBox(std::shared_ptr<void> opaquePointer);

  /*
   * Movable, Copyable, Assignable.
   */
  AttributedStringBox(const AttributedStringBox& other) = default;
  AttributedStringBox(AttributedStringBox&& other) noexcept;
  AttributedStringBox& operator=(const AttributedStringBox& other) = default;
  AttributedStringBox& operator=(AttributedStringBox&& other) noexcept;

  /*
   * Getters.
   */
  Mode getMode() const;
  const AttributedString& getValue() const;
  std::shared_ptr<void> getOpaquePointer() const;

 private:
  Mode mode_;
  std::shared_ptr<const AttributedString> value_;
  std::shared_ptr<void> opaquePointer_;
};

bool operator==(const AttributedStringBox& lhs, const AttributedStringBox& rhs);
bool operator!=(const AttributedStringBox& lhs, const AttributedStringBox& rhs);

} // namespace ABI50_0_0facebook::ABI50_0_0React

template <>
struct std::hash<ABI50_0_0facebook::ABI50_0_0React::AttributedStringBox> {
  size_t operator()(
      const ABI50_0_0facebook::ABI50_0_0React::AttributedStringBox& attributedStringBox) const {
    switch (attributedStringBox.getMode()) {
      case ABI50_0_0facebook::ABI50_0_0React::AttributedStringBox::Mode::Value:
        return std::hash<ABI50_0_0facebook::ABI50_0_0React::AttributedString>()(
            attributedStringBox.getValue());
      case ABI50_0_0facebook::ABI50_0_0React::AttributedStringBox::Mode::OpaquePointer:
        return std::hash<std::shared_ptr<void>>()(
            attributedStringBox.getOpaquePointer());
    }
  }
};
