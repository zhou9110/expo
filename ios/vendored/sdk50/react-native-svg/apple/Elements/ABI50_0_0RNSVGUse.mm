/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */
#import "ABI50_0_0RNSVGUse.h"
#import <ABI50_0_0React/ABI50_0_0RCTLog.h>
#import "ABI50_0_0RNSVGSymbol.h"

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricComponentsPlugins.h>
#import <react/renderer/components/rnsvg/ComponentDescriptors.h>
#import <react/renderer/components/view/conversions.h>
#import "ABI50_0_0RNSVGFabricConversions.h"
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@implementation ABI50_0_0RNSVGUse

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
using namespace ABI50_0_0facebook::ABI50_0_0React;

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ABI50_0_0RNSVGUseProps>();
    _props = defaultProps;
  }
  return self;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ABI50_0_0RNSVGUseComponentDescriptor>();
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &newProps = static_cast<const ABI50_0_0RNSVGUseProps &>(*props);

  self.x = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.x)];
  self.y = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.y)];
  if (ABI50_0_0RCTNSStringFromStringNilIfEmpty(newProps.height)) {
    self.useheight = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.height)];
  }
  if (ABI50_0_0RCTNSStringFromStringNilIfEmpty(newProps.width)) {
    self.usewidth = [ABI50_0_0RNSVGLength lengthWithString:ABI50_0_0RCTNSStringFromString(newProps.width)];
  }
  self.href = ABI50_0_0RCTNSStringFromStringNilIfEmpty(newProps.href);

  setCommonRenderableProps(newProps, self);
  _props = std::static_pointer_cast<ABI50_0_0RNSVGUseProps const>(props);
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];
  _x = nil;
  _y = nil;
  _useheight = nil;
  _usewidth = nil;
  _href = nil;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

- (void)setHref:(NSString *)href
{
  if ([href isEqualToString:_href]) {
    return;
  }

  [self invalidate];
  _href = href;
}

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

- (void)setUsewidth:(ABI50_0_0RNSVGLength *)usewidth
{
  if ([usewidth isEqualTo:_usewidth]) {
    return;
  }

  [self invalidate];
  _usewidth = usewidth;
}

- (void)setUseheight:(ABI50_0_0RNSVGLength *)useheight
{
  if ([useheight isEqualTo:_useheight]) {
    return;
  }

  [self invalidate];
  _useheight = useheight;
}

- (void)renderLayerTo:(CGContextRef)context rect:(CGRect)rect
{
  CGContextTranslateCTM(context, [self relativeOnWidth:self.x], [self relativeOnHeight:self.y]);
  ABI50_0_0RNSVGNode *definedTemplate = [self.svgView getDefinedTemplate:self.href];
  if (definedTemplate) {
    [self beginTransparencyLayer:context];
    [self clip:context];

    if ([definedTemplate isKindOfClass:[ABI50_0_0RNSVGRenderable class]]) {
      [(ABI50_0_0RNSVGRenderable *)definedTemplate mergeProperties:self];
    }

    if ([definedTemplate class] == [ABI50_0_0RNSVGSymbol class]) {
      ABI50_0_0RNSVGSymbol *symbol = (ABI50_0_0RNSVGSymbol *)definedTemplate;
      [symbol renderSymbolTo:context
                       width:[self relativeOnWidth:self.usewidth]
                      height:[self relativeOnHeight:self.useheight]];
    } else {
      [definedTemplate renderTo:context rect:rect];
    }

    if ([definedTemplate isKindOfClass:[ABI50_0_0RNSVGRenderable class]]) {
      [(ABI50_0_0RNSVGRenderable *)definedTemplate resetProperties];
    }

    [self endTransparencyLayer:context];
  } else if (self.href) {
    // TODO: calling yellow box here
    ABI50_0_0RCTLogWarn(
        @"`Use` element expected a pre-defined svg template as `href` prop, template named: %@ is not defined.",
        self.href);
    return;
  } else {
    return;
  }
  CGRect bounds = definedTemplate.clientRect;
  self.clientRect = bounds;

  CGAffineTransform current = CGContextGetCTM(context);
  CGAffineTransform svgToClientTransform = CGAffineTransformConcat(current, self.svgView.invInitialCTM);

  self.ctm = svgToClientTransform;
  self.screenCTM = current;

  CGAffineTransform transform = CGAffineTransformConcat(self.matrix, self.transforms);
  CGPoint mid = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
  CGPoint center = CGPointApplyAffineTransform(mid, transform);

  self.bounds = bounds;
  if (!isnan(center.x) && !isnan(center.y)) {
    self.center = center;
  }
  self.frame = bounds;
}

- (ABI50_0_0RNSVGPlatformView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  CGPoint transformed = CGPointApplyAffineTransform(point, self.invmatrix);
  transformed = CGPointApplyAffineTransform(transformed, self.invTransform);
  ABI50_0_0RNSVGNode const *definedTemplate = [self.svgView getDefinedTemplate:self.href];
  if (event) {
    self.active = NO;
  } else if (self.active) {
    return self;
  }
  ABI50_0_0RNSVGPlatformView const *hitChild = [definedTemplate hitTest:transformed withEvent:event];
  if (hitChild) {
    self.active = YES;
    return self;
  }
  return nil;
}

- (CGPathRef)getPath:(CGContextRef)context
{
  CGAffineTransform transform =
      CGAffineTransformMakeTranslation([self relativeOnWidth:self.x], [self relativeOnHeight:self.y]);
  ABI50_0_0RNSVGNode const *definedTemplate = [self.svgView getDefinedTemplate:self.href];
  if (!definedTemplate) {
    return nil;
  }
  CGPathRef path = [definedTemplate getPath:context];
  return CGPathCreateCopyByTransformingPath(path, &transform);
}

@end

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RNSVGUseCls(void)
{
  return ABI50_0_0RNSVGUse.class;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
