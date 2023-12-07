/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0ComponentDescriptor.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

ComponentDescriptor::ComponentDescriptor(
    const ComponentDescriptorParameters& parameters)
    : eventDispatcher_(parameters.eventDispatcher),
      contextContainer_(parameters.contextContainer),
      flavor_(parameters.flavor) {}

const ContextContainer::Shared& ComponentDescriptor::getContextContainer()
    const {
  return contextContainer_;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
