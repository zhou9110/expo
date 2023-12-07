/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <string>

#include <ABI50_0_0React/renderer/debug/ABI50_0_0DebugStringConvertible.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

#if ABI50_0_0RN_DEBUG_STRING_CONVERTIBLE

// Trivial implementation of `DebugStringConvertible` abstract class
// with a stored output; useful for assembling `DebugStringConvertible` values
// in custom implementations of `getDebugChildren` and `getDebugProps`.
class DebugStringConvertibleItem : public DebugStringConvertible {
 public:
  DebugStringConvertibleItem(const DebugStringConvertibleItem& item) = default;

  DebugStringConvertibleItem(
      std::string name = "",
      std::string value = "",
      SharedDebugStringConvertibleList props = {},
      SharedDebugStringConvertibleList children = {});

  std::string getDebugName() const override;
  std::string getDebugValue() const override;
  SharedDebugStringConvertibleList getDebugChildren() const override;
  SharedDebugStringConvertibleList getDebugProps() const override;

 private:
  std::string name_;
  std::string value_;
  SharedDebugStringConvertibleList debugProps_;
  SharedDebugStringConvertibleList children_;
};

#endif

} // namespace ABI50_0_0facebook::ABI50_0_0React
