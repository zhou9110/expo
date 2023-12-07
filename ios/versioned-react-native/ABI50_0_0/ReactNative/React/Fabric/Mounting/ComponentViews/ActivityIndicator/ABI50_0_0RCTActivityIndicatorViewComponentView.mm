/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTActivityIndicatorViewComponentView.h"

#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>

#import <ABI50_0_0React/renderer/components/rncore/ABI50_0_0ComponentDescriptors.h>
#import <ABI50_0_0React/renderer/components/rncore/ABI50_0_0EventEmitters.h>
#import <ABI50_0_0React/renderer/components/rncore/ABI50_0_0Props.h>

#import "ABI50_0_0RCTFabricComponentsPlugins.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

static UIActivityIndicatorViewStyle convertActivityIndicatorViewStyle(const ActivityIndicatorViewSize &size)
{
  switch (size) {
    case ActivityIndicatorViewSize::Small:
      return UIActivityIndicatorViewStyleMedium;
    case ActivityIndicatorViewSize::Large:
      return UIActivityIndicatorViewStyleLarge;
  }
}

@implementation ABI50_0_0RCTActivityIndicatorViewComponentView {
  UIActivityIndicatorView *_activityIndicatorView;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ActivityIndicatorViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ActivityIndicatorViewProps>();
    _props = defaultProps;

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
    _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    if (defaultProps->animating) {
      [_activityIndicatorView startAnimating];
    } else {
      [_activityIndicatorView stopAnimating];
    }
    _activityIndicatorView.color = ABI50_0_0RCTUIColorFromSharedColor(defaultProps->color);
    _activityIndicatorView.hidesWhenStopped = defaultProps->hidesWhenStopped;
    _activityIndicatorView.activityIndicatorViewStyle = convertActivityIndicatorViewStyle(defaultProps->size);

    [self addSubview:_activityIndicatorView];
  }

  return self;
}

- (void)updateProps:(const Props::Shared &)props oldProps:(const Props::Shared &)oldProps
{
  const auto &oldViewProps = static_cast<const ActivityIndicatorViewProps &>(*_props);
  const auto &newViewProps = static_cast<const ActivityIndicatorViewProps &>(*props);

  if (oldViewProps.animating != newViewProps.animating) {
    if (newViewProps.animating) {
      [_activityIndicatorView startAnimating];
    } else {
      [_activityIndicatorView stopAnimating];
    }
  }

  if (oldViewProps.color != newViewProps.color) {
    _activityIndicatorView.color = ABI50_0_0RCTUIColorFromSharedColor(newViewProps.color);
  }

  // TODO: This prop should be deprecated.
  if (oldViewProps.hidesWhenStopped != newViewProps.hidesWhenStopped) {
    _activityIndicatorView.hidesWhenStopped = newViewProps.hidesWhenStopped;
  }

  if (oldViewProps.size != newViewProps.size) {
    _activityIndicatorView.activityIndicatorViewStyle = convertActivityIndicatorViewStyle(newViewProps.size);
  }

  [super updateProps:props oldProps:oldProps];
}

@end

Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RCTActivityIndicatorViewCls(void)
{
  return ABI50_0_0RCTActivityIndicatorViewComponentView.class;
}
