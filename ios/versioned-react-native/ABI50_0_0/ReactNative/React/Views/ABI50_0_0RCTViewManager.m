/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTViewManager.h"

#import "ABI50_0_0RCTAssert.h"
#import "ABI50_0_0RCTBorderCurve.h"
#import "ABI50_0_0RCTBorderStyle.h"
#import "ABI50_0_0RCTBridge.h"
#import "ABI50_0_0RCTConvert+Transform.h"
#import "ABI50_0_0RCTConvert.h"
#import "ABI50_0_0RCTLog.h"
#import "ABI50_0_0RCTShadowView.h"
#import "ABI50_0_0RCTTransformOrigin.h"
#import "ABI50_0_0RCTUIManager.h"
#import "ABI50_0_0RCTUIManagerUtils.h"
#import "ABI50_0_0RCTUtils.h"
#import "ABI50_0_0RCTView.h"
#import "ABI50_0_0UIView+React.h"

@implementation ABI50_0_0RCTConvert (UIAccessibilityTraits)

ABI50_0_0RCT_MULTI_ENUM_CONVERTER(
    UIAccessibilityTraits,
    (@{
      @"adjustable" : @(UIAccessibilityTraitAdjustable),
      @"alert" : @(UIAccessibilityTraitNone),
      @"alertdialog" : @(UIAccessibilityTraitNone),
      @"allowsDirectInteraction" : @(UIAccessibilityTraitAllowsDirectInteraction),
      @"application" : @(UIAccessibilityTraitNone),
      @"article" : @(UIAccessibilityTraitNone),
      @"banner" : @(UIAccessibilityTraitNone),
      @"button" : @(UIAccessibilityTraitButton),
      @"cell" : @(UIAccessibilityTraitNone),
      @"checkbox" : @(UIAccessibilityTraitNone),
      @"columnheader" : @(UIAccessibilityTraitNone),
      @"combobox" : @(UIAccessibilityTraitNone),
      @"complementary" : @(UIAccessibilityTraitNone),
      @"contentinfo" : @(UIAccessibilityTraitNone),
      @"definition" : @(UIAccessibilityTraitNone),
      @"dialog" : @(UIAccessibilityTraitNone),
      @"directory" : @(UIAccessibilityTraitNone),
      @"disabled" : @(UIAccessibilityTraitNotEnabled),
      @"document" : @(UIAccessibilityTraitNone),
      @"drawerlayout" : @(UIAccessibilityTraitNone),
      @"dropdownlist" : @(UIAccessibilityTraitNone),
      @"feed" : @(UIAccessibilityTraitNone),
      @"figure" : @(UIAccessibilityTraitNone),
      @"form" : @(UIAccessibilityTraitNone),
      @"frequentUpdates" : @(UIAccessibilityTraitUpdatesFrequently),
      @"grid" : @(UIAccessibilityTraitNone),
      @"group" : @(UIAccessibilityTraitNone),
      @"header" : @(UIAccessibilityTraitHeader),
      @"heading" : @(UIAccessibilityTraitHeader),
      @"horizontalscrollview" : @(UIAccessibilityTraitNone),
      @"iconmenu" : @(UIAccessibilityTraitNone),
      @"image" : @(UIAccessibilityTraitImage),
      @"imagebutton" : @(UIAccessibilityTraitImage | UIAccessibilityTraitButton),
      @"img" : @(UIAccessibilityTraitImage),
      @"key" : @(UIAccessibilityTraitKeyboardKey),
      @"keyboardkey" : @(UIAccessibilityTraitKeyboardKey),
      @"link" : @(UIAccessibilityTraitLink),
      @"list" : @(UIAccessibilityTraitNone),
      @"listitem" : @(UIAccessibilityTraitNone),
      @"log" : @(UIAccessibilityTraitNone),
      @"main" : @(UIAccessibilityTraitNone),
      @"marquee" : @(UIAccessibilityTraitNone),
      @"math" : @(UIAccessibilityTraitNone),
      @"menu" : @(UIAccessibilityTraitNone),
      @"menubar" : @(UIAccessibilityTraitNone),
      @"menuitem" : @(UIAccessibilityTraitNone),
      @"meter" : @(UIAccessibilityTraitNone),
      @"navigation" : @(UIAccessibilityTraitNone),
      @"none" : @(UIAccessibilityTraitNone),
      @"note" : @(UIAccessibilityTraitNone),
      @"option" : @(UIAccessibilityTraitNone),
      @"pager" : @(UIAccessibilityTraitNone),
      @"pageTurn" : @(UIAccessibilityTraitCausesPageTurn),
      @"plays" : @(UIAccessibilityTraitPlaysSound),
      @"presentation" : @(UIAccessibilityTraitNone),
      @"progressbar" : @(UIAccessibilityTraitUpdatesFrequently),
      @"radio" : @(UIAccessibilityTraitNone),
      @"radiogroup" : @(UIAccessibilityTraitNone),
      @"region" : @(UIAccessibilityTraitNone),
      @"row" : @(UIAccessibilityTraitNone),
      @"rowgroup" : @(UIAccessibilityTraitNone),
      @"rowheader" : @(UIAccessibilityTraitNone),
      @"scrollbar" : @(UIAccessibilityTraitNone),
      @"scrollview" : @(UIAccessibilityTraitNone),
      @"search" : @(UIAccessibilityTraitSearchField),
      @"searchbox" : @(UIAccessibilityTraitSearchField),
      @"selected" : @(UIAccessibilityTraitSelected),
      @"separator" : @(UIAccessibilityTraitNone),
      @"slider" : @(UIAccessibilityTraitNone),
      @"slidingdrawer" : @(UIAccessibilityTraitNone),
      @"spinbutton" : @(UIAccessibilityTraitNone),
      @"startsMedia" : @(UIAccessibilityTraitStartsMediaSession),
      @"status" : @(UIAccessibilityTraitNone),
      @"summary" : @(UIAccessibilityTraitSummaryElement),
      @"switch" : @(SwitchAccessibilityTrait),
      @"tab" : @(UIAccessibilityTraitNone),
      @"tabbar" : @(UIAccessibilityTraitTabBar),
      @"table" : @(UIAccessibilityTraitNone),
      @"tablist" : @(UIAccessibilityTraitNone),
      @"tabpanel" : @(UIAccessibilityTraitNone),
      @"term" : @(UIAccessibilityTraitNone),
      @"text" : @(UIAccessibilityTraitStaticText),
      @"timer" : @(UIAccessibilityTraitNone),
      @"togglebutton" : @(UIAccessibilityTraitButton),
      @"toolbar" : @(UIAccessibilityTraitNone),
      @"tooltip" : @(UIAccessibilityTraitNone),
      @"tree" : @(UIAccessibilityTraitNone),
      @"treegrid" : @(UIAccessibilityTraitNone),
      @"treeitem" : @(UIAccessibilityTraitNone),
      @"viewgroup" : @(UIAccessibilityTraitNone),
      @"webview" : @(UIAccessibilityTraitNone),
    }),
    UIAccessibilityTraitNone,
    unsignedLongLongValue)

+ (ABI50_0_0RCTTransformOrigin)ABI50_0_0RCTTransformOrigin:(id)json
{
  ABI50_0_0RCTTransformOrigin transformOrigin = {
      [ABI50_0_0RCTConvert ABI50_0_0YGValue:json[0]], [ABI50_0_0RCTConvert ABI50_0_0YGValue:json[1]], [ABI50_0_0RCTConvert CGFloat:json[2]]};
  return transformOrigin;
}

@end

@implementation ABI50_0_0RCTViewManager

@synthesize bridge = _bridge;

ABI50_0_0RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
  return ABI50_0_0RCTGetUIManagerQueue();
}

- (void)setBridge:(ABI50_0_0RCTBridge *)bridge
{
  ABI50_0_0RCTErrorNewArchitectureValidation(
      ABI50_0_0RCTNotAllowedInBridgeless, self, @"ABI50_0_0RCTViewManager must not be initialized for the new architecture");
  _bridge = bridge;
}

- (UIView *)view
{
  return [ABI50_0_0RCTView new];
}

- (ABI50_0_0RCTShadowView *)shadowView
{
  return [ABI50_0_0RCTShadowView new];
}

- (NSArray<NSString *> *)customBubblingEventTypes
{
  return @[

    // Generic events
    @"press",
    @"change",
    @"focus",
    @"blur",
    @"submitEditing",
    @"endEditing",
    @"keyPress",

    // Touch events
    @"touchStart",
    @"touchMove",
    @"touchCancel",
    @"touchEnd",
  ];
}

#pragma mark - View properties

// Accessibility related properties
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(accessible, ABI50_0_0ReactAccessibilityElement.isAccessibilityElement, BOOL)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(accessibilityActions, ABI50_0_0ReactAccessibilityElement.accessibilityActions, NSDictionaryArray)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(accessibilityLabel, ABI50_0_0ReactAccessibilityElement.accessibilityLabel, NSString)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(accessibilityHint, ABI50_0_0ReactAccessibilityElement.accessibilityHint, NSString)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(accessibilityLanguage, ABI50_0_0ReactAccessibilityElement.accessibilityLanguage, NSString)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(accessibilityValue, ABI50_0_0ReactAccessibilityElement.accessibilityValueInternal, NSDictionary)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(accessibilityViewIsModal, ABI50_0_0ReactAccessibilityElement.accessibilityViewIsModal, BOOL)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(accessibilityElementsHidden, ABI50_0_0ReactAccessibilityElement.accessibilityElementsHidden, BOOL)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(
    accessibilityIgnoresInvertColors,
    ABI50_0_0ReactAccessibilityElement.shouldAccessibilityIgnoresInvertColors,
    BOOL)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(onAccessibilityAction, ABI50_0_0ReactAccessibilityElement.onAccessibilityAction, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(onAccessibilityTap, ABI50_0_0ReactAccessibilityElement.onAccessibilityTap, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(onMagicTap, ABI50_0_0ReactAccessibilityElement.onMagicTap, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(onAccessibilityEscape, ABI50_0_0ReactAccessibilityElement.onAccessibilityEscape, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(testID, ABI50_0_0ReactAccessibilityElement.accessibilityIdentifier, NSString)

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(backgroundColor, UIColor)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(backfaceVisibility, layer.doubleSided, css_backface_visibility_t)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(opacity, alpha, CGFloat)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(shadowColor, layer.shadowColor, CGColor)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(shadowOffset, layer.shadowOffset, CGSize)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(shadowOpacity, layer.shadowOpacity, float)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(shadowRadius, layer.shadowRadius, CGFloat)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(needsOffscreenAlphaCompositing, layer.allowsGroupOpacity, BOOL)
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(overflow, ABI50_0_0YGOverflow, ABI50_0_0RCTView)
{
  if (json) {
    view.clipsToBounds = [ABI50_0_0RCTConvert ABI50_0_0YGOverflow:json] != ABI50_0_0YGOverflowVisible;
  } else {
    view.clipsToBounds = defaultView.clipsToBounds;
  }
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(shouldRasterizeIOS, BOOL, ABI50_0_0RCTView)
{
  view.layer.shouldRasterize = json ? [ABI50_0_0RCTConvert BOOL:json] : defaultView.layer.shouldRasterize;
  view.layer.rasterizationScale =
      view.layer.shouldRasterize ? [UIScreen mainScreen].scale : defaultView.layer.rasterizationScale;
}

ABI50_0_0RCT_REMAP_VIEW_PROPERTY(transform, ABI50_0_0ReactTransform, CATransform3D)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(transformOrigin, ABI50_0_0ReactTransformOrigin, ABI50_0_0RCTTransformOrigin)

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(accessibilityRole, UIAccessibilityTraits, ABI50_0_0RCTView)
{
  UIAccessibilityTraits accessibilityRoleTraits =
      json ? [ABI50_0_0RCTConvert UIAccessibilityTraits:json] : UIAccessibilityTraitNone;
  if (view.ABI50_0_0ReactAccessibilityElement.accessibilityRoleTraits != accessibilityRoleTraits) {
    view.accessibilityRoleTraits = accessibilityRoleTraits;
    view.ABI50_0_0ReactAccessibilityElement.accessibilityRole = json ? [ABI50_0_0RCTConvert NSString:json] : nil;
    [self updateAccessibilityTraitsForRole:view withDefaultView:defaultView];
  }
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(role, UIAccessibilityTraits, ABI50_0_0RCTView)
{
  UIAccessibilityTraits roleTraits = json ? [ABI50_0_0RCTConvert UIAccessibilityTraits:json] : UIAccessibilityTraitNone;
  if (view.ABI50_0_0ReactAccessibilityElement.roleTraits != roleTraits) {
    view.roleTraits = roleTraits;
    view.ABI50_0_0ReactAccessibilityElement.role = json ? [ABI50_0_0RCTConvert NSString:json] : nil;
    [self updateAccessibilityTraitsForRole:view withDefaultView:defaultView];
  }
}

- (void)updateAccessibilityTraitsForRole:(ABI50_0_0RCTView *)view withDefaultView:(ABI50_0_0RCTView *)defaultView
{
  const UIAccessibilityTraits AccessibilityRolesMask = UIAccessibilityTraitNone | UIAccessibilityTraitButton |
      UIAccessibilityTraitLink | UIAccessibilityTraitSearchField | UIAccessibilityTraitImage |
      UIAccessibilityTraitKeyboardKey | UIAccessibilityTraitStaticText | UIAccessibilityTraitAdjustable |
      UIAccessibilityTraitHeader | UIAccessibilityTraitSummaryElement | UIAccessibilityTraitTabBar |
      UIAccessibilityTraitUpdatesFrequently | SwitchAccessibilityTrait;

  // Clear any existing traits set for AccessibilityRole
  view.ABI50_0_0ReactAccessibilityElement.accessibilityTraits &= ~(AccessibilityRolesMask);

  view.ABI50_0_0ReactAccessibilityElement.accessibilityTraits |= view.ABI50_0_0ReactAccessibilityElement.role
      ? view.ABI50_0_0ReactAccessibilityElement.roleTraits
      : view.ABI50_0_0ReactAccessibilityElement.accessibilityRole ? view.ABI50_0_0ReactAccessibilityElement.accessibilityRoleTraits
                                                         : (defaultView.accessibilityTraits & AccessibilityRolesMask);
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(accessibilityState, NSDictionary, ABI50_0_0RCTView)
{
  NSDictionary<NSString *, id> *state = json ? [ABI50_0_0RCTConvert NSDictionary:json] : nil;
  NSMutableDictionary<NSString *, id> *newState = [NSMutableDictionary<NSString *, id> new];

  if (!state) {
    return;
  }

  const UIAccessibilityTraits AccessibilityStatesMask = UIAccessibilityTraitNotEnabled | UIAccessibilityTraitSelected;
  view.ABI50_0_0ReactAccessibilityElement.accessibilityTraits =
      view.ABI50_0_0ReactAccessibilityElement.accessibilityTraits & ~AccessibilityStatesMask;

  for (NSString *s in state) {
    id val = [state objectForKey:s];
    if (!val) {
      continue;
    }
    if ([s isEqualToString:@"selected"] && [val isKindOfClass:[NSNumber class]] && [val boolValue]) {
      view.ABI50_0_0ReactAccessibilityElement.accessibilityTraits |= UIAccessibilityTraitSelected;
    } else if ([s isEqualToString:@"disabled"] && [val isKindOfClass:[NSNumber class]] && [val boolValue]) {
      view.ABI50_0_0ReactAccessibilityElement.accessibilityTraits |= UIAccessibilityTraitNotEnabled;
    } else {
      newState[s] = val;
    }
  }
  if (newState.count > 0) {
    view.ABI50_0_0ReactAccessibilityElement.accessibilityState = newState;
    // Post a layout change notification to make sure VoiceOver get notified for the state
    // changes that don't happen upon users' click.
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
  } else {
    view.ABI50_0_0ReactAccessibilityElement.accessibilityState = nil;
  }
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(nativeID, NSString *, ABI50_0_0RCTView)
{
  view.nativeID = json ? [ABI50_0_0RCTConvert NSString:json] : defaultView.nativeID;
  [_bridge.uiManager setNativeID:view.nativeID forView:view];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(pointerEvents, ABI50_0_0RCTPointerEvents, ABI50_0_0RCTView)
{
  if ([view respondsToSelector:@selector(setPointerEvents:)]) {
    view.pointerEvents = json ? [ABI50_0_0RCTConvert ABI50_0_0RCTPointerEvents:json] : defaultView.pointerEvents;
    return;
  }

  if (!json) {
    view.userInteractionEnabled = defaultView.userInteractionEnabled;
    return;
  }

  switch ([ABI50_0_0RCTConvert ABI50_0_0RCTPointerEvents:json]) {
    case ABI50_0_0RCTPointerEventsUnspecified:
      // Pointer events "unspecified" acts as if a stylesheet had not specified,
      // which is different than "auto" in CSS (which cannot and will not be
      // supported in `ABI50_0_0React`. "auto" may override a parent's "none".
      // Unspecified values do not.
      // This wouldn't override a container view's `userInteractionEnabled = NO`
      view.userInteractionEnabled = YES;
    case ABI50_0_0RCTPointerEventsNone:
      view.userInteractionEnabled = NO;
      break;
    default:
      ABI50_0_0RCTLogInfo(@"UIView base class does not support pointerEvent value: %@", json);
  }
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(removeClippedSubviews, BOOL, ABI50_0_0RCTView)
{
  if ([view respondsToSelector:@selector(setRemoveClippedSubviews:)]) {
    view.removeClippedSubviews = json ? [ABI50_0_0RCTConvert BOOL:json] : defaultView.removeClippedSubviews;
  }
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(borderCurve, ABI50_0_0RCTBorderCurve, ABI50_0_0RCTView)
{
  switch ([ABI50_0_0RCTConvert ABI50_0_0RCTBorderCurve:json]) {
    case ABI50_0_0RCTBorderCurveContinuous:
      view.layer.cornerCurve = kCACornerCurveContinuous;
      break;
    case ABI50_0_0RCTBorderCurveCircular:
      view.layer.cornerCurve = kCACornerCurveCircular;
      break;
  }
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(borderRadius, CGFloat, ABI50_0_0RCTView)
{
  if ([view respondsToSelector:@selector(setBorderRadius:)]) {
    view.borderRadius = json ? [ABI50_0_0RCTConvert CGFloat:json] : defaultView.borderRadius;
  } else {
    view.layer.cornerRadius = json ? [ABI50_0_0RCTConvert CGFloat:json] : defaultView.layer.cornerRadius;
  }
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(borderColor, UIColor, ABI50_0_0RCTView)
{
  if ([view respondsToSelector:@selector(setBorderColor:)]) {
    view.borderColor = json ? [ABI50_0_0RCTConvert UIColor:json] : defaultView.borderColor;
  } else {
    view.layer.borderColor = json ? [ABI50_0_0RCTConvert CGColor:json] : defaultView.layer.borderColor;
  }
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(borderWidth, float, ABI50_0_0RCTView)
{
  if ([view respondsToSelector:@selector(setBorderWidth:)]) {
    view.borderWidth = json ? [ABI50_0_0RCTConvert CGFloat:json] : defaultView.borderWidth;
  } else {
    view.layer.borderWidth = json ? [ABI50_0_0RCTConvert CGFloat:json] : defaultView.layer.borderWidth;
  }
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(borderStyle, ABI50_0_0RCTBorderStyle, ABI50_0_0RCTView)
{
  if ([view respondsToSelector:@selector(setBorderStyle:)]) {
    view.borderStyle = json ? [ABI50_0_0RCTConvert ABI50_0_0RCTBorderStyle:json] : defaultView.borderStyle;
  }
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(hitSlop, UIEdgeInsets, ABI50_0_0RCTView)
{
  if ([view respondsToSelector:@selector(setHitTestEdgeInsets:)]) {
    if (json) {
      UIEdgeInsets hitSlopInsets = [ABI50_0_0RCTConvert UIEdgeInsets:json];
      view.hitTestEdgeInsets =
          UIEdgeInsetsMake(-hitSlopInsets.top, -hitSlopInsets.left, -hitSlopInsets.bottom, -hitSlopInsets.right);
    } else {
      view.hitTestEdgeInsets = defaultView.hitTestEdgeInsets;
    }
  }
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(collapsable, BOOL, ABI50_0_0RCTView)
{
  // Property is only to be used in the new renderer.
  // It is necessary to add it here, otherwise it gets
  // filtered by view configs.
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(experimental_layoutConformance, NSString *, ABI50_0_0RCTView)
{
  // Property is only to be used in the new renderer.
  // It is necessary to add it here, otherwise it gets
  // filtered by view configs.
}

#define ABI50_0_0RCT_VIEW_BORDER_PROPERTY(SIDE)                                                               \
  ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(border##SIDE##Width, float, ABI50_0_0RCTView)                                      \
  {                                                                                                  \
    if ([view respondsToSelector:@selector(setBorder##SIDE##Width:)]) {                              \
      view.border##SIDE##Width = json ? [ABI50_0_0RCTConvert CGFloat:json] : defaultView.border##SIDE##Width; \
    }                                                                                                \
  }                                                                                                  \
  ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(border##SIDE##Color, UIColor, ABI50_0_0RCTView)                                    \
  {                                                                                                  \
    if ([view respondsToSelector:@selector(setBorder##SIDE##Color:)]) {                              \
      view.border##SIDE##Color = json ? [ABI50_0_0RCTConvert UIColor:json] : defaultView.border##SIDE##Color; \
    }                                                                                                \
  }

ABI50_0_0RCT_VIEW_BORDER_PROPERTY(Top)
ABI50_0_0RCT_VIEW_BORDER_PROPERTY(Right)
ABI50_0_0RCT_VIEW_BORDER_PROPERTY(Bottom)
ABI50_0_0RCT_VIEW_BORDER_PROPERTY(Left)
ABI50_0_0RCT_VIEW_BORDER_PROPERTY(Start)
ABI50_0_0RCT_VIEW_BORDER_PROPERTY(End)
ABI50_0_0RCT_VIEW_BORDER_PROPERTY(Block)
ABI50_0_0RCT_VIEW_BORDER_PROPERTY(BlockEnd)
ABI50_0_0RCT_VIEW_BORDER_PROPERTY(BlockStart)

#define ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(SIDE)                                                          \
  ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(border##SIDE##Radius, CGFloat, ABI50_0_0RCTView)                                     \
  {                                                                                                    \
    if ([view respondsToSelector:@selector(setBorder##SIDE##Radius:)]) {                               \
      view.border##SIDE##Radius = json ? [ABI50_0_0RCTConvert CGFloat:json] : defaultView.border##SIDE##Radius; \
    }                                                                                                  \
  }

ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(TopLeft)
ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(TopRight)
ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(TopStart)
ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(TopEnd)
ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(BottomLeft)
ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(BottomRight)
ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(BottomStart)
ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(BottomEnd)
ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(EndEnd)
ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(EndStart)
ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(StartEnd)
ABI50_0_0RCT_VIEW_BORDER_RADIUS_PROPERTY(StartStart)

ABI50_0_0RCT_REMAP_VIEW_PROPERTY(display, ABI50_0_0ReactDisplay, ABI50_0_0YGDisplay)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(zIndex, ABI50_0_0ReactZIndex, NSInteger)

#pragma mark - ShadowView properties

ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(top, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(right, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(start, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(end, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(bottom, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(left, ABI50_0_0YGValue)

ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(width, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(height, ABI50_0_0YGValue)

ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(minWidth, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(maxWidth, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(minHeight, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(maxHeight, ABI50_0_0YGValue)

ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(borderTopWidth, float)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(borderRightWidth, float)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(borderBottomWidth, float)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(borderLeftWidth, float)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(borderStartWidth, float)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(borderEndWidth, float)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(borderWidth, float)

ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(marginTop, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(marginRight, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(marginBottom, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(marginLeft, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(marginStart, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(marginEnd, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(marginVertical, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(marginHorizontal, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(margin, ABI50_0_0YGValue)

ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(paddingTop, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(paddingRight, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(paddingBottom, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(paddingLeft, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(paddingStart, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(paddingEnd, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(paddingVertical, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(paddingHorizontal, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(padding, ABI50_0_0YGValue)

ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(flex, float)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(flexGrow, float)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(flexShrink, float)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(flexBasis, ABI50_0_0YGValue)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(flexDirection, ABI50_0_0YGFlexDirection)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(flexWrap, ABI50_0_0YGWrap)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(justifyContent, ABI50_0_0YGJustify)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(alignItems, ABI50_0_0YGAlign)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(alignSelf, ABI50_0_0YGAlign)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(alignContent, ABI50_0_0YGAlign)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(position, ABI50_0_0YGPositionType)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(aspectRatio, float)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(rowGap, float)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(columnGap, float)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(gap, float)

ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(overflow, ABI50_0_0YGOverflow)
ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(display, ABI50_0_0YGDisplay)

ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(onLayout, ABI50_0_0RCTDirectEventBlock)

ABI50_0_0RCT_EXPORT_SHADOW_PROPERTY(direction, ABI50_0_0YGDirection)

// The events below define the properties that are not used by native directly, but required in the view config for new
// renderer to function.
// They can be deleted after Static View Configs are rolled out.

// PanResponder handlers
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onMoveShouldSetResponder, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onMoveShouldSetResponderCapture, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onStartShouldSetResponder, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onStartShouldSetResponderCapture, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onResponderGrant, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onResponderReject, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onResponderStart, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onResponderEnd, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onResponderRelease, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onResponderMove, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onResponderTerminate, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onResponderTerminationRequest, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onShouldBlockNativeResponder, BOOL, ABI50_0_0RCTView) {}

// Touch events
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onTouchStart, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onTouchMove, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onTouchEnd, BOOL, ABI50_0_0RCTView) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(onTouchCancel, BOOL, ABI50_0_0RCTView) {}

// Experimental/WIP Pointer Events (not yet ready for use)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onClick, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPointerCancel, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPointerDown, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPointerMove, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPointerUp, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPointerEnter, ABI50_0_0RCTCapturingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPointerLeave, ABI50_0_0RCTCapturingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPointerOver, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPointerOut, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onGotPointerCapture, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onLostPointerCapture, ABI50_0_0RCTBubblingEventBlock)

@end
