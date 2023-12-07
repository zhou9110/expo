/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGRect.h"
#import <ABI50_0_0React/ABI50_0_0RCTLog.h>

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricComponentsPlugins.h>
#import <react/renderer/components/rnsvg/ComponentDescriptors.h>
#import <react/renderer/components/view/conversions.h>
#import "ABI50_0_0RNSVGFabricConversions.h"
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@implementation ABI50_0_0RNSVGRect

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
using namespace ABI50_0_0facebook::ABI50_0_0React;

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ABI50_0_0RNSVGRectProps>();
    _props = defaultProps;
  }
  return self;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ABI50_0_0RNSVGRectComponentDescriptor>();
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &newProps = static_cast<const ABI50_0_0RNSVGRectProps &>(*props);

  self.x = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.x)];
  self.y = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.y)];
  if (ABI50_0_0RCTNSStringFromStringNilIfEmpty(newProps.height)) {
    self.rectheight = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.height)];
  }
  if (ABI50_0_0RCTNSStringFromStringNilIfEmpty(newProps.width)) {
    self.rectwidth = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.width)];
  }
  self.rx = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.rx)];
  self.ry = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.ry)];

  setCommonRenderableProps(newProps, self);
  _props = std::static_pointer_cast<ABI50_0_0RNSVGRectProps const>(props);
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];

  _x = nil;
  _y = nil;
  _rectwidth = nil;
  _rectheight = nil;
  _rx = nil;
  _ry = nil;
}

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

- (void)setX:(ABI50_0_0RNSVGLength *)x
{
  if ([x isEqualTo:_x]) {
    return;
  }
  [self invalidate];
  _x = x;
}

- (void)setY:(ABI50_0_0RNSVGLength *)y
{
  if ([y isEqualTo:_y]) {
    return;
  }
  [self invalidate];
  _y = y;
}

- (void)setRectwidth:(ABI50_0_0RNSVGLength *)rectwidth
{
  if ([rectwidth isEqualTo:_rectwidth]) {
    return;
  }
  [self invalidate];
  _rectwidth = rectwidth;
}

- (void)setRectheight:(ABI50_0_0RNSVGLength *)rectheight
{
  if ([rectheight isEqualTo:_rectheight]) {
    return;
  }
  [self invalidate];
  _rectheight = rectheight;
}

- (void)setRx:(ABI50_0_0RNSVGLength *)rx
{
  if ([rx isEqualTo:_rx]) {
    return;
  }
  [self invalidate];
  _rx = rx;
}

- (void)setRy:(ABI50_0_0RNSVGLength *)ry
{
  if ([ry isEqualTo:_ry]) {
    return;
  }
  [self invalidate];
  _ry = ry;
}

- (CGPathRef)getPath:(CGContextRef)context
{
  CGMutablePathRef path = CGPathCreateMutable();
  CGFloat x = [self relativeOnWidth:self.x];
  CGFloat y = [self relativeOnHeight:self.y];
  CGFloat width = [self relativeOnWidth:self.rectwidth];
  CGFloat height = [self relativeOnHeight:self.rectheight];

  if (self.rx != nil || self.ry != nil) {
    CGFloat rx = 0;
    CGFloat ry = 0;
    if (self.rx == nil) {
      ry = [self relativeOnHeight:self.ry];
      rx = ry;
    } else if (self.ry == nil) {
      rx = [self relativeOnWidth:self.rx];
      ry = rx;
    } else {
      rx = [self relativeOnWidth:self.rx];
      ry = [self relativeOnHeight:self.ry];
    }

    if (rx > width / 2) {
      rx = width / 2;
    }

    if (ry > height / 2) {
      ry = height / 2;
    }

    CGPathAddRoundedRect(path, nil, CGRectMake(x, y, width, height), rx, ry);
  } else {
    CGPathAddRect(path, nil, CGRectMake(x, y, width, height));
  }

  return (CGPathRef)CFAutorelease(path);
}

@end

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RNSVGRectCls(void)
{
  return ABI50_0_0RNSVGRect.class;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
