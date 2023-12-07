/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNode.h>
#include "ABI50_0_0StubView.h"
#include "ABI50_0_0StubViewTree.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Builds a ShadowView tree from given root ShadowNode using custom built-in
 * implementation (*without* using Differentiator).
 */
StubViewTree buildStubViewTreeWithoutUsingDifferentiator(
    const ShadowNode& rootShadowNode);

/*
 * Builds a ShadowView tree from given root ShadowNode using Differentiator by
 * generating mutation instructions between empty and final trees.
 */
StubViewTree buildStubViewTreeUsingDifferentiator(
    const ShadowNode& rootShadowNode);

} // namespace ABI50_0_0facebook::ABI50_0_0React
