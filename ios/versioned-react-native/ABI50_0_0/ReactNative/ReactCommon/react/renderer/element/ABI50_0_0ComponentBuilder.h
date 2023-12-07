/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>

#include <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorRegistry.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ComponentDescriptor.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNodeFragment.h>

#include <ABI50_0_0React/renderer/element/ABI50_0_0Element.h>
#include <ABI50_0_0React/renderer/element/ABI50_0_0ElementFragment.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Build `ShadowNode` trees with a given given `Element` trees.
 */
class ComponentBuilder final {
 public:
  ComponentBuilder(
      ComponentDescriptorRegistry::Shared componentDescriptorRegistry);

  /*
   * Copyable and movable.
   */
  ComponentBuilder(const ComponentBuilder& componentBuilder) = default;
  ComponentBuilder(ComponentBuilder&& componentBuilder) noexcept = default;
  ComponentBuilder& operator=(const ComponentBuilder& other) = default;
  ComponentBuilder& operator=(ComponentBuilder&& other) = default;

  /*
   * Builds a `ShadowNode` tree with given `Element` tree using stored
   * `ComponentDescriptorRegistry`.
   */
  template <typename ShadowNodeT>
  std::shared_ptr<ShadowNodeT> build(Element<ShadowNodeT> element) const {
    return std::static_pointer_cast<ShadowNodeT>(build(element.fragment_));
  }

 private:
  /*
   * Internal, type-erased version of `build`.
   */
  ShadowNode::Unshared build(const ElementFragment& elementFragment) const;

  ComponentDescriptorRegistry::Shared componentDescriptorRegistry_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
