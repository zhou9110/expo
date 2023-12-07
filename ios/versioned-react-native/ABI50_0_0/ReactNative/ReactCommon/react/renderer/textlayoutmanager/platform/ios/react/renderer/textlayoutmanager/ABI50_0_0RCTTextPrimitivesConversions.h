/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#include <ABI50_0_0React/renderer/textlayoutmanager/ABI50_0_0RCTFontProperties.h>
#include <ABI50_0_0React/renderer/textlayoutmanager/ABI50_0_0RCTFontUtils.h>

inline static NSTextAlignment ABI50_0_0RCTNSTextAlignmentFromTextAlignment(ABI50_0_0facebook::ABI50_0_0React::TextAlignment textAlignment)
{
  switch (textAlignment) {
    case ABI50_0_0facebook::ABI50_0_0React::TextAlignment::Natural:
      return NSTextAlignmentNatural;
    case ABI50_0_0facebook::ABI50_0_0React::TextAlignment::Left:
      return NSTextAlignmentLeft;
    case ABI50_0_0facebook::ABI50_0_0React::TextAlignment::Right:
      return NSTextAlignmentRight;
    case ABI50_0_0facebook::ABI50_0_0React::TextAlignment::Center:
      return NSTextAlignmentCenter;
    case ABI50_0_0facebook::ABI50_0_0React::TextAlignment::Justified:
      return NSTextAlignmentJustified;
  }
}

inline static NSWritingDirection ABI50_0_0RCTNSWritingDirectionFromWritingDirection(
    ABI50_0_0facebook::ABI50_0_0React::WritingDirection writingDirection)
{
  switch (writingDirection) {
    case ABI50_0_0facebook::ABI50_0_0React::WritingDirection::Natural:
      return NSWritingDirectionNatural;
    case ABI50_0_0facebook::ABI50_0_0React::WritingDirection::LeftToRight:
      return NSWritingDirectionLeftToRight;
    case ABI50_0_0facebook::ABI50_0_0React::WritingDirection::RightToLeft:
      return NSWritingDirectionRightToLeft;
  }
}

inline static NSLineBreakStrategy ABI50_0_0RCTNSLineBreakStrategyFromLineBreakStrategy(
    ABI50_0_0facebook::ABI50_0_0React::LineBreakStrategy lineBreakStrategy)
{
  switch (lineBreakStrategy) {
    case ABI50_0_0facebook::ABI50_0_0React::LineBreakStrategy::None:
      return NSLineBreakStrategyNone;
    case ABI50_0_0facebook::ABI50_0_0React::LineBreakStrategy::PushOut:
      return NSLineBreakStrategyPushOut;
    case ABI50_0_0facebook::ABI50_0_0React::LineBreakStrategy::HangulWordPriority:
      if (@available(iOS 14.0, *)) {
        return NSLineBreakStrategyHangulWordPriority;
      } else {
        return NSLineBreakStrategyNone;
      }
    case ABI50_0_0facebook::ABI50_0_0React::LineBreakStrategy::Standard:
      if (@available(iOS 14.0, *)) {
        return NSLineBreakStrategyStandard;
      } else {
        return NSLineBreakStrategyNone;
      }
  }
}

inline static ABI50_0_0RCTFontStyle ABI50_0_0RCTFontStyleFromFontStyle(ABI50_0_0facebook::ABI50_0_0React::FontStyle fontStyle)
{
  switch (fontStyle) {
    case ABI50_0_0facebook::ABI50_0_0React::FontStyle::Normal:
      return ABI50_0_0RCTFontStyleNormal;
    case ABI50_0_0facebook::ABI50_0_0React::FontStyle::Italic:
      return ABI50_0_0RCTFontStyleItalic;
    case ABI50_0_0facebook::ABI50_0_0React::FontStyle::Oblique:
      return ABI50_0_0RCTFontStyleOblique;
  }
}

inline static ABI50_0_0RCTFontVariant ABI50_0_0RCTFontVariantFromFontVariant(ABI50_0_0facebook::ABI50_0_0React::FontVariant fontVariant)
{
  return (ABI50_0_0RCTFontVariant)fontVariant;
}

inline static NSUnderlineStyle ABI50_0_0RCTNSUnderlineStyleFromTextDecorationStyle(
    ABI50_0_0facebook::ABI50_0_0React::TextDecorationStyle textDecorationStyle)
{
  switch (textDecorationStyle) {
    case ABI50_0_0facebook::ABI50_0_0React::TextDecorationStyle::Solid:
      return NSUnderlineStyleSingle;
    case ABI50_0_0facebook::ABI50_0_0React::TextDecorationStyle::Double:
      return NSUnderlineStyleDouble;
    case ABI50_0_0facebook::ABI50_0_0React::TextDecorationStyle::Dashed:
      return NSUnderlinePatternDash | NSUnderlineStyleSingle;
    case ABI50_0_0facebook::ABI50_0_0React::TextDecorationStyle::Dotted:
      return NSUnderlinePatternDot | NSUnderlineStyleSingle;
  }
}

inline static UIColor *ABI50_0_0RCTUIColorFromSharedColor(const ABI50_0_0facebook::ABI50_0_0React::SharedColor &sharedColor)
{
  if (!sharedColor) {
    return nil;
  }

  if (*ABI50_0_0facebook::ABI50_0_0React::clearColor() == *sharedColor) {
    return [UIColor clearColor];
  }

  if (*ABI50_0_0facebook::ABI50_0_0React::blackColor() == *sharedColor) {
    return [UIColor blackColor];
  }

  if (*ABI50_0_0facebook::ABI50_0_0React::whiteColor() == *sharedColor) {
    return [UIColor whiteColor];
  }

  auto components = ABI50_0_0facebook::ABI50_0_0React::colorComponentsFromColor(sharedColor);
  return [UIColor colorWithRed:components.red green:components.green blue:components.blue alpha:components.alpha];
}
