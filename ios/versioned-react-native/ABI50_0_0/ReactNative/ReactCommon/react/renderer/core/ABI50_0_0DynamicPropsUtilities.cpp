/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0DynamicPropsUtilities.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

folly::dynamic mergeDynamicProps(
    const folly::dynamic& source,
    const folly::dynamic& patch) {
  auto result = source;

  if (!result.isObject()) {
    result = folly::dynamic::object();
  }

  if (!patch.isObject()) {
    return result;
  }

  // Note, here we have to preserve sub-prop objects with `null` value as
  // an indication for the legacy mounting layer that it needs to clean them up.
  for (const auto& pair : patch.items()) {
    result[pair.first] = pair.second;
  }

  return result;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
