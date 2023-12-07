/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */
#import "ABI50_0_0RNSVGMask.h"
#import "ABI50_0_0RNSVGBrushType.h"
#import "ABI50_0_0RNSVGNode.h"
#import "ABI50_0_0RNSVGPainter.h"

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricComponentsPlugins.h>
#import <react/renderer/components/rnsvg/ComponentDescriptors.h>
#import <react/renderer/components/view/conversions.h>
#import "ABI50_0_0RNSVGFabricConversions.h"
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@implementation ABI50_0_0RNSVGMask

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
using namespace ABI50_0_0facebook::ABI50_0_0React;

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ABI50_0_0RNSVGMaskProps>();
    _props = defaultProps;
  }
  return self;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ABI50_0_0RNSVGMaskComponentDescriptor>();
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &newProps = static_cast<const ABI50_0_0RNSVGMaskProps &>(*props);

  self.x = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.x)];
  self.y = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.y)];
  if (ABI50_0_0RCTNSStringFromStringNilIfEmpty(newProps.height)) {
    self.maskheight = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.height)];
  }
  if (ABI50_0_0RCTNSStringFromStringNilIfEmpty(newProps.width)) {
    self.maskwidth = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.width)];
  }
  self.maskUnits = newProps.maskUnits == 0 ? kRNSVGUnitsObjectBoundingBox : kRNSVGUnitsUserSpaceOnUse;
  self.maskContentUnits = newProps.maskUnits == 0 ? kRNSVGUnitsObjectBoundingBox : kRNSVGUnitsUserSpaceOnUse;

  setCommonGroupProps(newProps, self);
  _props = std::static_pointer_cast<ABI50_0_0RNSVGMaskProps const>(props);
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];
  _x = nil;
  _y = nil;
  _maskheight = nil;
  _maskwidth = nil;
  _maskUnits = kRNSVGUnitsObjectBoundingBox;
  _maskContentUnits = kRNSVGUnitsObjectBoundingBox;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

- (ABI50_0_0RNSVGPlatformView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  return nil;
}

- (void)parseReference
{
  self.dirty = false;
  [self.svgView defineMask:self maskName:self.name];
}

- (void)setX:(ABI50_0_0RNSVGLength *)x
{
  if ([x isEqualTo:_x]) {
    return;
  }

  _x = x;
  [self invalidate];
}

- (void)setY:(ABI50_0_0RNSVGLength *)y
{
  if ([y isEqualTo:_y]) {
    return;
  }

  _y = y;
  [self invalidate];
}

- (void)setMaskwidth:(ABI50_0_0RNSVGLength *)maskwidth
{
  if ([maskwidth isEqualTo:_maskwidth]) {
    return;
  }

  _maskwidth = maskwidth;
  [self invalidate];
}

- (void)setMaskheight:(ABI50_0_0RNSVGLength *)maskheight
{
  if ([maskheight isEqualTo:_maskheight]) {
    return;
  }

  _maskheight = maskheight;
  [self invalidate];
}

- (void)setMaskUnits:(ABI50_0_0RNSVGUnits)maskUnits
{
  if (maskUnits == _maskUnits) {
    return;
  }

  _maskUnits = maskUnits;
  [self invalidate];
}

- (void)setMaskContentUnits:(ABI50_0_0RNSVGUnits)maskContentUnits
{
  if (maskContentUnits == _maskContentUnits) {
    return;
  }

  _maskContentUnits = maskContentUnits;
  [self invalidate];
}

@end

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RNSVGMaskCls(void)
{
  return ABI50_0_0RNSVGMask.class;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
