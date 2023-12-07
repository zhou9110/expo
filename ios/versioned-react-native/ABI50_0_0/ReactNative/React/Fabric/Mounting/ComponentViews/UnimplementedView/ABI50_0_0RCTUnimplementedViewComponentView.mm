/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTUnimplementedViewComponentView.h"

#import <ABI50_0_0React/renderer/components/rncore/ABI50_0_0ComponentDescriptors.h>
#import <ABI50_0_0React/renderer/components/rncore/ABI50_0_0EventEmitters.h>
#import <ABI50_0_0React/renderer/components/rncore/ABI50_0_0Props.h>

#import <ABI50_0_0React/renderer/components/unimplementedview/ABI50_0_0UnimplementedViewComponentDescriptor.h>
#import <ABI50_0_0React/renderer/components/unimplementedview/ABI50_0_0UnimplementedViewShadowNode.h>

#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>

#import "ABI50_0_0RCTFabricComponentsPlugins.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

@implementation ABI50_0_0RCTUnimplementedViewComponentView {
  UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const UnimplementedViewProps>();
    _props = defaultProps;

    _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
    _label.lineBreakMode = NSLineBreakByCharWrapping;
    _label.numberOfLines = 0;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.allowsDefaultTighteningForTruncation = YES;
    _label.adjustsFontSizeToFitWidth = YES;

    self.contentView = _label;
  }

  return self;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<UnimplementedViewComponentDescriptor>();
}

- (void)updateProps:(const Props::Shared &)props oldProps:(const Props::Shared &)oldProps
{
  const auto &oldUnimplementedViewProps = static_cast<const UnimplementedViewProps &>(*_props);
  const auto &newUnimplementedViewProps = static_cast<const UnimplementedViewProps &>(*props);

  if (oldUnimplementedViewProps.getComponentName() != newUnimplementedViewProps.getComponentName()) {
    _label.text =
        [NSString stringWithFormat:@"Unimplemented component: <%s>", newUnimplementedViewProps.getComponentName()];
  }

  [super updateProps:props oldProps:oldProps];
}

@end

Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RCTUnimplementedNativeViewCls(void)
{
  return ABI50_0_0RCTUnimplementedViewComponentView.class;
}
