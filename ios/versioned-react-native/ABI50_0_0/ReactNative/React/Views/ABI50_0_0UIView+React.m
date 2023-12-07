/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0UIView+React.h"

#import <objc/runtime.h>

#import "ABI50_0_0RCTAssert.h"
#import "ABI50_0_0RCTLog.h"
#import "ABI50_0_0RCTShadowView.h"

@implementation UIView (ABI50_0_0React)

- (NSNumber *)ABI50_0_0ReactTag
{
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setABI50_0_0ReactTag:(NSNumber *)ABI50_0_0ReactTag
{
  objc_setAssociatedObject(self, @selector(ABI50_0_0ReactTag), ABI50_0_0ReactTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)rootTag
{
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setRootTag:(NSNumber *)rootTag
{
  objc_setAssociatedObject(self, @selector(rootTag), rootTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)nativeID
{
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setNativeID:(NSString *)nativeID
{
  objc_setAssociatedObject(self, @selector(nativeID), nativeID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldAccessibilityIgnoresInvertColors
{
  return self.accessibilityIgnoresInvertColors;
}

- (void)setShouldAccessibilityIgnoresInvertColors:(BOOL)shouldAccessibilityIgnoresInvertColors
{
  self.accessibilityIgnoresInvertColors = shouldAccessibilityIgnoresInvertColors;
}

- (BOOL)isABI50_0_0ReactRootView
{
  return ABI50_0_0RCTIsABI50_0_0ReactRootView(self.ABI50_0_0ReactTag);
}

- (NSNumber *)ABI50_0_0ReactTagAtPoint:(CGPoint)point
{
  UIView *view = [self hitTest:point withEvent:nil];
  while (view && !view.ABI50_0_0ReactTag) {
    view = view.superview;
  }
  return view.ABI50_0_0ReactTag;
}

- (NSArray<UIView *> *)ABI50_0_0ReactSubviews
{
  return objc_getAssociatedObject(self, _cmd);
}

- (UIView *)ABI50_0_0ReactSuperview
{
  return self.superview;
}

- (void)insertABI50_0_0ReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex
{
  // We access the associated object directly here in case someone overrides
  // the `ABI50_0_0ReactSubviews` getter method and returns an immutable array.
  NSMutableArray *subviews = objc_getAssociatedObject(self, @selector(ABI50_0_0ReactSubviews));
  if (!subviews) {
    subviews = [NSMutableArray new];
    objc_setAssociatedObject(self, @selector(ABI50_0_0ReactSubviews), subviews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  [subviews insertObject:subview atIndex:atIndex];
}

- (void)removeABI50_0_0ReactSubview:(UIView *)subview
{
  // We access the associated object directly here in case someone overrides
  // the `ABI50_0_0ReactSubviews` getter method and returns an immutable array.
  NSMutableArray *subviews = objc_getAssociatedObject(self, @selector(ABI50_0_0ReactSubviews));
  [subviews removeObject:subview];
  [subview removeFromSuperview];
}

#pragma mark - Display

- (ABI50_0_0YGDisplay)ABI50_0_0ReactDisplay
{
  return self.isHidden ? ABI50_0_0YGDisplayNone : ABI50_0_0YGDisplayFlex;
}

- (void)setABI50_0_0ReactDisplay:(ABI50_0_0YGDisplay)display
{
  self.hidden = display == ABI50_0_0YGDisplayNone;
}

#pragma mark - Layout Direction

- (UIUserInterfaceLayoutDirection)ABI50_0_0ReactLayoutDirection
{
  if ([self respondsToSelector:@selector(semanticContentAttribute)]) {
    return [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.semanticContentAttribute];
  } else {
    return [objc_getAssociatedObject(self, @selector(ABI50_0_0ReactLayoutDirection)) integerValue];
  }
}

- (void)setABI50_0_0ReactLayoutDirection:(UIUserInterfaceLayoutDirection)layoutDirection
{
  if ([self respondsToSelector:@selector(setSemanticContentAttribute:)]) {
    self.semanticContentAttribute = layoutDirection == UIUserInterfaceLayoutDirectionLeftToRight
        ? UISemanticContentAttributeForceLeftToRight
        : UISemanticContentAttributeForceRightToLeft;
  } else {
    objc_setAssociatedObject(
        self, @selector(ABI50_0_0ReactLayoutDirection), @(layoutDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
}

#pragma mark - zIndex

- (NSInteger)ABI50_0_0ReactZIndex
{
  return self.layer.zPosition;
}

- (void)setABI50_0_0ReactZIndex:(NSInteger)ABI50_0_0ReactZIndex
{
  self.layer.zPosition = ABI50_0_0ReactZIndex;
}

- (NSArray<UIView *> *)ABI50_0_0ReactZIndexSortedSubviews
{
  // Check if sorting is required - in most cases it won't be.
  BOOL sortingRequired = NO;
  for (UIView *subview in self.subviews) {
    if (subview.ABI50_0_0ReactZIndex != 0) {
      sortingRequired = YES;
      break;
    }
  }
  return sortingRequired ? [self.ABI50_0_0ReactSubviews sortedArrayUsingComparator:^NSComparisonResult(UIView *a, UIView *b) {
    if (a.ABI50_0_0ReactZIndex > b.ABI50_0_0ReactZIndex) {
      return NSOrderedDescending;
    } else {
      // Ensure sorting is stable by treating equal zIndex as ascending so
      // that original order is preserved.
      return NSOrderedAscending;
    }
  }]
                         : self.subviews;
}

- (void)didUpdateABI50_0_0ReactSubviews
{
  for (UIView *subview in self.ABI50_0_0ReactSubviews) {
    [self addSubview:subview];
  }
}

- (void)didSetProps:(__unused NSArray<NSString *> *)changedProps
{
  // The default implementation does nothing.
}

- (void)ABI50_0_0ReactSetFrame:(CGRect)frame
{
  // These frames are in terms of anchorPoint = topLeft, but internally the
  // views are anchorPoint = center for easier scale and rotation animations.
  // Convert the frame so it works with anchorPoint = center.
  CGPoint position = {CGRectGetMidX(frame), CGRectGetMidY(frame)};
  CGRect bounds = {CGPointZero, frame.size};

  // Avoid crashes due to nan coords
  if (isnan(position.x) || isnan(position.y) || isnan(bounds.origin.x) || isnan(bounds.origin.y) ||
      isnan(bounds.size.width) || isnan(bounds.size.height)) {
    ABI50_0_0RCTLogError(
        @"Invalid layout for (%@)%@. position: %@. bounds: %@",
        self.ABI50_0_0ReactTag,
        self,
        NSStringFromCGPoint(position),
        NSStringFromCGRect(bounds));
    return;
  }

  self.center = position;
  self.bounds = bounds;

  id transformOrigin = objc_getAssociatedObject(self, @selector(ABI50_0_0ReactTransformOrigin));
  if (transformOrigin) {
    updateTransform(self);
  }
}

#pragma mark - Transforms

- (CATransform3D)ABI50_0_0ReactTransform
{
  id obj = objc_getAssociatedObject(self, _cmd);
  return obj != nil ? [obj CATransform3DValue] : CATransform3DIdentity;
}

- (void)setABI50_0_0ReactTransform:(CATransform3D)ABI50_0_0ReactTransform
{
  objc_setAssociatedObject(self, @selector(ABI50_0_0ReactTransform), @(ABI50_0_0ReactTransform), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  updateTransform(self);
}

- (ABI50_0_0RCTTransformOrigin)ABI50_0_0ReactTransformOrigin
{
  id obj = objc_getAssociatedObject(self, _cmd);
  if (obj != nil) {
    ABI50_0_0RCTTransformOrigin transformOrigin;
    [obj getValue:&transformOrigin];
    return transformOrigin;
  } else {
    return (ABI50_0_0RCTTransformOrigin){(ABI50_0_0YGValue){50, ABI50_0_0YGUnitPercent}, (ABI50_0_0YGValue){50, ABI50_0_0YGUnitPercent}, 0};
  }
}

- (void)setABI50_0_0ReactTransformOrigin:(ABI50_0_0RCTTransformOrigin)ABI50_0_0ReactTransformOrigin
{
  id obj = [NSValue value:&ABI50_0_0ReactTransformOrigin withObjCType:@encode(ABI50_0_0RCTTransformOrigin)];
  objc_setAssociatedObject(self, @selector(ABI50_0_0ReactTransformOrigin), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  updateTransform(self);
}

static void updateTransform(UIView *view)
{
  CATransform3D transform;
  id rawTansformOrigin = objc_getAssociatedObject(view, @selector(ABI50_0_0ReactTransformOrigin));
  if (rawTansformOrigin) {
    CGSize size = view.bounds.size;
    CGFloat anchorPointX = 0;
    CGFloat anchorPointY = 0;
    CGFloat anchorPointZ = 0;
    ABI50_0_0RCTTransformOrigin transformOrigin;
    [rawTansformOrigin getValue:&transformOrigin];
    if (transformOrigin.x.unit == ABI50_0_0YGUnitPoint) {
      anchorPointX = transformOrigin.x.value - size.width * 0.5;
    } else if (transformOrigin.x.unit == ABI50_0_0YGUnitPercent) {
      anchorPointX = (transformOrigin.x.value * 0.01 - 0.5) * size.width;
    }

    if (transformOrigin.y.unit == ABI50_0_0YGUnitPoint) {
      anchorPointY = transformOrigin.y.value - size.height * 0.5;
    } else if (transformOrigin.y.unit == ABI50_0_0YGUnitPercent) {
      anchorPointY = (transformOrigin.y.value * 0.01 - 0.5) * size.height;
    }
    anchorPointZ = transformOrigin.z;
    transform = CATransform3DConcat(
        view.ABI50_0_0ReactTransform, CATransform3DMakeTranslation(anchorPointX, anchorPointY, anchorPointZ));
    transform =
        CATransform3DConcat(CATransform3DMakeTranslation(-anchorPointX, -anchorPointY, -anchorPointZ), transform);
  } else {
    transform = view.ABI50_0_0ReactTransform;
  }

  view.layer.transform = transform;
  // Enable edge antialiasing in rotation, skew, or perspective transforms
  view.layer.allowsEdgeAntialiasing = transform.m12 != 0.0f || transform.m21 != 0.0f || transform.m34 != 0.0f;
}

- (UIViewController *)ABI50_0_0ReactViewController
{
  id responder = [self nextResponder];
  while (responder) {
    if ([responder isKindOfClass:[UIViewController class]]) {
      return responder;
    }
    responder = [responder nextResponder];
  }
  return nil;
}

- (void)ABI50_0_0ReactAddControllerToClosestParent:(UIViewController *)controller
{
  if (!controller.parentViewController) {
    UIView *parentView = (UIView *)self.ABI50_0_0ReactSuperview;
    while (parentView) {
      if (parentView.ABI50_0_0ReactViewController) {
        [parentView.ABI50_0_0ReactViewController addChildViewController:controller];
        [controller didMoveToParentViewController:parentView.ABI50_0_0ReactViewController];
        break;
      }
      parentView = (UIView *)parentView.ABI50_0_0ReactSuperview;
    }
    return;
  }
}

/**
 * Focus manipulation.
 */
- (BOOL)ABI50_0_0ReactIsFocusNeeded
{
  return [(NSNumber *)objc_getAssociatedObject(self, @selector(ABI50_0_0ReactIsFocusNeeded)) boolValue];
}

- (void)setABI50_0_0ReactIsFocusNeeded:(BOOL)isFocusNeeded
{
  objc_setAssociatedObject(self, @selector(ABI50_0_0ReactIsFocusNeeded), @(isFocusNeeded), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ABI50_0_0ReactFocus
{
  if (![self becomeFirstResponder]) {
    self.ABI50_0_0ReactIsFocusNeeded = YES;
  }
}

- (void)ABI50_0_0ReactFocusIfNeeded
{
  if (self.ABI50_0_0ReactIsFocusNeeded) {
    if ([self becomeFirstResponder]) {
      self.ABI50_0_0ReactIsFocusNeeded = NO;
    }
  }
}

- (void)ABI50_0_0ReactBlur
{
  [self resignFirstResponder];
}

#pragma mark - Layout

- (UIEdgeInsets)ABI50_0_0ReactBorderInsets
{
  CGFloat borderWidth = self.layer.borderWidth;
  return UIEdgeInsetsMake(borderWidth, borderWidth, borderWidth, borderWidth);
}

- (UIEdgeInsets)ABI50_0_0ReactPaddingInsets
{
  return UIEdgeInsetsZero;
}

- (UIEdgeInsets)ABI50_0_0ReactCompoundInsets
{
  UIEdgeInsets borderInsets = self.ABI50_0_0ReactBorderInsets;
  UIEdgeInsets paddingInsets = self.ABI50_0_0ReactPaddingInsets;

  return UIEdgeInsetsMake(
      borderInsets.top + paddingInsets.top,
      borderInsets.left + paddingInsets.left,
      borderInsets.bottom + paddingInsets.bottom,
      borderInsets.right + paddingInsets.right);
}

- (CGRect)ABI50_0_0ReactContentFrame
{
  return UIEdgeInsetsInsetRect(self.bounds, self.ABI50_0_0ReactCompoundInsets);
}

#pragma mark - Accessibility

- (UIView *)ABI50_0_0ReactAccessibilityElement
{
  return self;
}

- (NSArray<NSDictionary *> *)accessibilityActions
{
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setAccessibilityActions:(NSArray<NSDictionary *> *)accessibilityActions
{
  objc_setAssociatedObject(
      self, @selector(accessibilityActions), accessibilityActions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)accessibilityLanguage
{
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setAccessibilityLanguage:(NSString *)accessibilityLanguage
{
  objc_setAssociatedObject(
      self, @selector(accessibilityLanguage), accessibilityLanguage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)accessibilityRole
{
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setAccessibilityRole:(NSString *)accessibilityRole
{
  objc_setAssociatedObject(self, @selector(accessibilityRole), accessibilityRole, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)role
{
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setRole:(NSString *)role
{
  objc_setAssociatedObject(self, @selector(role), role, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary<NSString *, id> *)accessibilityState
{
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setAccessibilityState:(NSDictionary<NSString *, id> *)accessibilityState
{
  objc_setAssociatedObject(self, @selector(accessibilityState), accessibilityState, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary<NSString *, id> *)accessibilityValueInternal
{
  return objc_getAssociatedObject(self, _cmd);
}
- (void)setAccessibilityValueInternal:(NSDictionary<NSString *, id> *)accessibilityValue
{
  objc_setAssociatedObject(
      self, @selector(accessibilityValueInternal), accessibilityValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIAccessibilityTraits)accessibilityRoleTraits
{
  NSNumber *traitsAsNumber = objc_getAssociatedObject(self, _cmd);
  return traitsAsNumber ? [traitsAsNumber unsignedLongLongValue] : UIAccessibilityTraitNone;
}

- (void)setAccessibilityRoleTraits:(UIAccessibilityTraits)accessibilityRoleTraits
{
  objc_setAssociatedObject(
      self,
      @selector(accessibilityRoleTraits),
      [NSNumber numberWithUnsignedLongLong:accessibilityRoleTraits],
      OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIAccessibilityTraits)roleTraits
{
  NSNumber *traitsAsNumber = objc_getAssociatedObject(self, _cmd);
  return traitsAsNumber ? [traitsAsNumber unsignedLongLongValue] : UIAccessibilityTraitNone;
}

- (void)setRoleTraits:(UIAccessibilityTraits)roleTraits
{
  objc_setAssociatedObject(
      self, @selector(roleTraits), [NSNumber numberWithUnsignedLongLong:roleTraits], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Debug
- (void)ABI50_0_0React_addRecursiveDescriptionToString:(NSMutableString *)string atLevel:(NSUInteger)level
{
  for (NSUInteger i = 0; i < level; i++) {
    [string appendString:@"   | "];
  }

  [string appendString:self.description];
  [string appendString:@"\n"];

  for (UIView *subview in self.subviews) {
    [subview ABI50_0_0React_addRecursiveDescriptionToString:string atLevel:level + 1];
  }
}

- (NSString *)ABI50_0_0React_recursiveDescription
{
  NSMutableString *description = [NSMutableString string];
  [self ABI50_0_0React_addRecursiveDescriptionToString:description atLevel:0];
  return description;
}

@end
