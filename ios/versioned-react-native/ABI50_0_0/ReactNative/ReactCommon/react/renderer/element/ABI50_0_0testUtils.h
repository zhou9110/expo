/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorProviderRegistry.h>
#include <ABI50_0_0React/renderer/components/modal/ABI50_0_0ModalHostViewComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/root/ABI50_0_0RootComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/scrollview/ABI50_0_0ScrollViewComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0ParagraphComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0RawTextComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0TextComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewComponentDescriptor.h>
#include <ABI50_0_0React/renderer/element/ABI50_0_0ComponentBuilder.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

inline ComponentBuilder simpleComponentBuilder(
    ContextContainer::Shared contextContainer = nullptr) {
  ComponentDescriptorProviderRegistry componentDescriptorProviderRegistry{};
  auto eventDispatcher = EventDispatcher::Shared{};
  auto componentDescriptorRegistry =
      componentDescriptorProviderRegistry.createComponentDescriptorRegistry(
          ComponentDescriptorParameters{
              eventDispatcher, std::move(contextContainer), nullptr});

  componentDescriptorProviderRegistry.add(
      concreteComponentDescriptorProvider<RootComponentDescriptor>());
  componentDescriptorProviderRegistry.add(
      concreteComponentDescriptorProvider<ViewComponentDescriptor>());
  componentDescriptorProviderRegistry.add(
      concreteComponentDescriptorProvider<ScrollViewComponentDescriptor>());
  componentDescriptorProviderRegistry.add(
      concreteComponentDescriptorProvider<ParagraphComponentDescriptor>());
  componentDescriptorProviderRegistry.add(
      concreteComponentDescriptorProvider<TextComponentDescriptor>());
  componentDescriptorProviderRegistry.add(
      concreteComponentDescriptorProvider<RawTextComponentDescriptor>());
  componentDescriptorProviderRegistry.add(
      concreteComponentDescriptorProvider<ModalHostViewComponentDescriptor>());

  return ComponentBuilder{componentDescriptorRegistry};
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
