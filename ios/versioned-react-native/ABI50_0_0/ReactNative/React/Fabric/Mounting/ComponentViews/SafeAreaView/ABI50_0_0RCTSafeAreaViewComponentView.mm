/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTSafeAreaViewComponentView.h"

#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>
#import <ABI50_0_0React/renderer/components/safeareaview/ABI50_0_0SafeAreaViewComponentDescriptor.h>
#import <ABI50_0_0React/renderer/components/safeareaview/ABI50_0_0SafeAreaViewState.h>
#import "ABI50_0_0RCTConversions.h"
#import "ABI50_0_0RCTFabricComponentsPlugins.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

@implementation ABI50_0_0RCTSafeAreaViewComponentView {
  SafeAreaViewShadowNode::ConcreteState::Shared _state;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const SafeAreaViewProps>();
    _props = defaultProps;
  }

  return self;
}

- (void)safeAreaInsetsDidChange
{
  [super safeAreaInsetsDidChange];

  [self _updateStateIfNecessary];
}

- (void)_updateStateIfNecessary
{
  if (!_state) {
    return;
  }

  UIEdgeInsets insets = self.safeAreaInsets;
  insets.left = ABI50_0_0RCTRoundPixelValue(insets.left);
  insets.top = ABI50_0_0RCTRoundPixelValue(insets.top);
  insets.right = ABI50_0_0RCTRoundPixelValue(insets.right);
  insets.bottom = ABI50_0_0RCTRoundPixelValue(insets.bottom);

  auto newPadding = ABI50_0_0RCTEdgeInsetsFromUIEdgeInsets(insets);
  auto threshold = 1.0 / ABI50_0_0RCTScreenScale() + 0.01; // Size of a pixel plus some small threshold.

  _state->updateState(
      [=](const SafeAreaViewShadowNode::ConcreteState::Data &oldData)
          -> SafeAreaViewShadowNode::ConcreteState::SharedData {
        auto oldPadding = oldData.padding;
        auto deltaPadding = newPadding - oldPadding;

        if (std::abs(deltaPadding.left) < threshold && std::abs(deltaPadding.top) < threshold &&
            std::abs(deltaPadding.right) < threshold && std::abs(deltaPadding.bottom) < threshold) {
          return nullptr;
        }

        auto newData = oldData;
        newData.padding = newPadding;
        return std::make_shared<SafeAreaViewShadowNode::ConcreteState::Data const>(newData);
      });
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<SafeAreaViewComponentDescriptor>();
}

- (void)updateState:(const ABI50_0_0facebook::ABI50_0_0React::State::Shared &)state
           oldState:(const ABI50_0_0facebook::ABI50_0_0React::State::Shared &)oldState
{
  _state = std::static_pointer_cast<SafeAreaViewShadowNode::ConcreteState const>(state);
}

- (void)finalizeUpdates:(ABI50_0_0RNComponentViewUpdateMask)updateMask
{
  [super finalizeUpdates:updateMask];
  [self _updateStateIfNecessary];
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];
  _state.reset();
}

@end

Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RCTSafeAreaViewCls(void)
{
  return ABI50_0_0RCTSafeAreaViewComponentView.class;
}
