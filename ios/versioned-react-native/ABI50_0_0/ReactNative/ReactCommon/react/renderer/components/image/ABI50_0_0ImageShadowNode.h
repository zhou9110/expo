/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/image/ABI50_0_0ImageEventEmitter.h>
#include <ABI50_0_0React/renderer/components/image/ABI50_0_0ImageProps.h>
#include <ABI50_0_0React/renderer/components/image/ABI50_0_0ImageState.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ConcreteViewShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNodeFamily.h>
#include <ABI50_0_0React/renderer/imagemanager/ABI50_0_0ImageManager.h>
#include <ABI50_0_0React/renderer/imagemanager/ABI50_0_0primitives.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

extern const char ImageComponentName[];

/*
 * `ShadowNode` for <Image> component.
 */
class ImageShadowNode final : public ConcreteViewShadowNode<
                                  ImageComponentName,
                                  ImageProps,
                                  ImageEventEmitter,
                                  ImageState> {
 public:
  using ConcreteViewShadowNode::ConcreteViewShadowNode;

  static ShadowNodeTraits BaseTraits() {
    auto traits = ConcreteViewShadowNode::BaseTraits();
    traits.set(ShadowNodeTraits::Trait::LeafYogaNode);
    return traits;
  }

  /*
   * Associates a shared `ImageManager` with the node.
   */
  void setImageManager(const SharedImageManager& imageManager);

  static ImageState initialStateData(
      const Props::Shared& props,
      const ShadowNodeFamily::Shared& /*family*/,
      const ComponentDescriptor& componentDescriptor) {
    auto imageSource = ImageSource{ImageSource::Type::Invalid};
    return {imageSource, {imageSource, nullptr, {}}, 0};
  }

#pragma mark - LayoutableShadowNode

  void layout(LayoutContext layoutContext) override;

 private:
  ImageSource getImageSource() const;

  SharedImageManager imageManager_;

  void updateStateIfNeeded();
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
