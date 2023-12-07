/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/unimplementedview/ABI50_0_0UnimplementedViewProps.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ConcreteViewShadowNode.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

extern const char UnimplementedViewComponentName[];

using UnimplementedViewShadowNode = ConcreteViewShadowNode<
    UnimplementedViewComponentName,
    UnimplementedViewProps>;

} // namespace ABI50_0_0facebook::ABI50_0_0React
