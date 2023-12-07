/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGPath.h"

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricComponentsPlugins.h>
#import <react/renderer/components/rnsvg/ComponentDescriptors.h>
#import <react/renderer/components/view/conversions.h>
#import "ABI50_0_0RNSVGFabricConversions.h"
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@implementation ABI50_0_0RNSVGPath {
  CGPathRef _path;
}

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
using namespace ABI50_0_0facebook::ABI50_0_0React;

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ABI50_0_0RNSVGPathProps>();
    _props = defaultProps;
  }
  return self;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ABI50_0_0RNSVGPathComponentDescriptor>();
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &newProps = static_cast<const ABI50_0_0RNSVGPathProps &>(*props);
  self.d = [[ABI50_0_0RNSVGPathParser alloc] initWithPathString:ABI50_0_0RCTNSStringFromString(newProps.d)];

  setCommonRenderableProps(newProps, self);
  _props = std::static_pointer_cast<ABI50_0_0RNSVGPathProps const>(props);
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];
  if (_path) {
    CGPathRelease(_path);
  }
  _path = nil;
  _d = nil;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

- (void)setD:(ABI50_0_0RNSVGPathParser *)d
{
  if (d == _d) {
    return;
  }

  [self invalidate];
  _d = d;
  CGPathRelease(_path);
  _path = CGPathRetain([d getPath]);
}

- (CGPathRef)getPath:(CGContextRef)context
{
  return _path;
}

- (void)dealloc
{
  CGPathRelease(_path);
}

@end

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RNSVGPathCls(void)
{
  return ABI50_0_0RNSVGPath.class;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
