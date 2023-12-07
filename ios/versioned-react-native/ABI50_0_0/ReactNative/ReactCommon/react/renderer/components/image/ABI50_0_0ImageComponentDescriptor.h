/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/image/ABI50_0_0ImageShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ConcreteComponentDescriptor.h>
#include <ABI50_0_0React/renderer/imagemanager/ABI50_0_0ImageManager.h>
#include <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Descriptor for <Image> component.
 */
class ImageComponentDescriptor final
    : public ConcreteComponentDescriptor<ImageShadowNode> {
 public:
  ImageComponentDescriptor(const ComponentDescriptorParameters& parameters)
      : ConcreteComponentDescriptor(parameters),
        imageManager_(std::make_shared<ImageManager>(contextContainer_)){};

  void adopt(ShadowNode& shadowNode) const override {
    ConcreteComponentDescriptor::adopt(shadowNode);

    auto& imageShadowNode = static_cast<ImageShadowNode&>(shadowNode);

    // `ImageShadowNode` uses `ImageManager` to initiate image loading and
    // communicate the loading state and results to mounting layer.
    imageShadowNode.setImageManager(imageManager_);
  }

 private:
  const SharedImageManager imageManager_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
