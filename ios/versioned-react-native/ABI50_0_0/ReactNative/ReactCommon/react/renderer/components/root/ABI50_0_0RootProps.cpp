/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0RootProps.h"

#include <ABI50_0_0React/renderer/components/view/ABI50_0_0YogaLayoutableShadowNode.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0conversions.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

// Note that a default/empty context may be passed here from RootShadowNode.
// If that's a problem and the context is necessary here, refactor
// RootShadowNode first.
RootProps::RootProps(
    const PropsParserContext& context,
    const RootProps& sourceProps,
    const RawProps& rawProps)
    : ViewProps(context, sourceProps, rawProps) {}

// Note that a default/empty context may be passed here from RootShadowNode.
// If that's a problem and the context is necessary here, refactor
// RootShadowNode first.
RootProps::RootProps(
    const PropsParserContext& /*context*/,
    const RootProps& /*sourceProps*/,
    const LayoutConstraints& layoutConstraints,
    const LayoutContext& layoutContext)
    : ViewProps(),
      layoutConstraints(layoutConstraints),
      layoutContext(layoutContext){};

} // namespace ABI50_0_0facebook::ABI50_0_0React
