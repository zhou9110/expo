/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <optional>

#include <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>
#include <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

// For props requiring some context to parse, this toolbox can be used.
// It should be used as infrequently as possible - most props can and should
// be parsed without any context.
struct PropsParserContext {
  PropsParserContext(
      const SurfaceId surfaceId,
      const ContextContainer& contextContainer)
      : surfaceId(surfaceId), contextContainer(contextContainer) {}

  // Non-copyable
  PropsParserContext(const PropsParserContext&) = delete;
  PropsParserContext& operator=(const PropsParserContext&) = delete;

  const SurfaceId surfaceId;
  const ContextContainer& contextContainer;

  // Temporary feature flags
  bool treatAutoAsABI50_0_0YGValueUndefined() const;

 private:
  mutable std::optional<bool> treatAutoAsABI50_0_0YGValueUndefined_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
