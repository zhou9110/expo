/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>

#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewProps.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutConstraints.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutContext.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class RootProps final : public ViewProps {
 public:
  RootProps() = default;
  RootProps(
      const PropsParserContext& context,
      const RootProps& sourceProps,
      const RawProps& rawProps);
  RootProps(
      const PropsParserContext& context,
      const RootProps& sourceProps,
      const LayoutConstraints& layoutConstraints,
      const LayoutContext& layoutContext);

#pragma mark - Props

  LayoutConstraints layoutConstraints{};
  LayoutContext layoutContext{};
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
