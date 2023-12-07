/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGCircle.h"
#import <ABI50_0_0React/ABI50_0_0RCTLog.h>

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricComponentsPlugins.h>
#import <react/renderer/components/rnsvg/ComponentDescriptors.h>
#import <react/renderer/components/view/conversions.h>
#import "ABI50_0_0RNSVGFabricConversions.h"
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@implementation ABI50_0_0RNSVGCircle

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
using namespace ABI50_0_0facebook::ABI50_0_0React;

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ABI50_0_0RNSVGCircleProps>();
    _props = defaultProps;
  }
  return self;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ABI50_0_0RNSVGCircleComponentDescriptor>();
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &newProps = static_cast<const ABI50_0_0RNSVGCircleProps &>(*props);

  self.cx = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.cx)];
  self.cy = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.cy)];
  self.r = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.r)];

  setCommonRenderableProps(newProps, self);
  _props = std::static_pointer_cast<ABI50_0_0RNSVGCircleProps const>(props);
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];
  _cx = nil;
  _cy = nil;
  _r = nil;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

- (void)setCx:(ABI50_0_0RNSVGLength *)cx
{
  if ([cx isEqualTo:_cx]) {
    return;
  }
  [self invalidate];
  _cx = cx;
}

- (void)setCy:(ABI50_0_0RNSVGLength *)cy
{
  if ([cy isEqualTo:_cy]) {
    return;
  }
  [self invalidate];
  _cy = cy;
}

- (void)setR:(ABI50_0_0RNSVGLength *)r
{
  if ([r isEqualTo:_r]) {
    return;
  }
  [self invalidate];
  _r = r;
}

- (CGPathRef)getPath:(CGContextRef)context
{
  CGMutablePathRef path = CGPathCreateMutable();
  CGFloat cx = [self relativeOnWidth:self.cx];
  CGFloat cy = [self relativeOnHeight:self.cy];
  CGFloat r = [self relativeOnOther:self.r];
  CGPathAddArc(path, nil, cx, cy, r, 0, 2 * (CGFloat)M_PI, NO);
  return (CGPathRef)CFAutorelease(path);
}

@end

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RNSVGCircleCls(void)
{
  return ABI50_0_0RNSVGCircle.class;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
