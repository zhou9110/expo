#import <Foundation/Foundation.h>

#ifndef RNTextProperties_h
#define RNTextProperties_h

typedef NS_ENUM(NSInteger, ABI50_0_0RNSVGAlignmentBaseline) {
  ABI50_0_0RNSVGAlignmentBaselineBaseline,
  ABI50_0_0RNSVGAlignmentBaselineTextBottom,
  ABI50_0_0RNSVGAlignmentBaselineAlphabetic,
  ABI50_0_0RNSVGAlignmentBaselineIdeographic,
  ABI50_0_0RNSVGAlignmentBaselineMiddle,
  ABI50_0_0RNSVGAlignmentBaselineCentral,
  ABI50_0_0RNSVGAlignmentBaselineMathematical,
  ABI50_0_0RNSVGAlignmentBaselineTextTop,
  ABI50_0_0RNSVGAlignmentBaselineBottom,
  ABI50_0_0RNSVGAlignmentBaselineCenter,
  ABI50_0_0RNSVGAlignmentBaselineTop,
  /*
   SVG implementations may support the following aliases in order to support legacy content:

   text-before-edge = text-top
   text-after-edge = text-bottom
   */
  ABI50_0_0RNSVGAlignmentBaselineTextBeforeEdge,
  ABI50_0_0RNSVGAlignmentBaselineTextAfterEdge,
  // SVG 1.1
  ABI50_0_0RNSVGAlignmentBaselineBeforeEdge,
  ABI50_0_0RNSVGAlignmentBaselineAfterEdge,
  ABI50_0_0RNSVGAlignmentBaselineHanging,
  ABI50_0_0RNSVGAlignmentBaselineDEFAULT = ABI50_0_0RNSVGAlignmentBaselineBaseline
};

static NSString *const ABI50_0_0RNSVGAlignmentBaselineStrings[] = {
    @"baseline",        @"text-bottom", @"alphabetic", @"ideographic", @"middle",  @"central",
    @"mathematical",    @"text-top",    @"bottom",     @"center",      @"top",     @"text-before-edge",
    @"text-after-edge", @"before-edge", @"after-edge", @"hanging",     @"central", @"mathematical",
    @"text-top",        @"bottom",      @"center",     @"top",         nil};

NSString *ABI50_0_0RNSVGAlignmentBaselineToString(enum ABI50_0_0RNSVGAlignmentBaseline fw);

enum ABI50_0_0RNSVGAlignmentBaseline ABI50_0_0RNSVGAlignmentBaselineFromString(NSString *s);

typedef NS_ENUM(NSInteger, ABI50_0_0RNSVGFontStyle) {
  ABI50_0_0RNSVGFontStyleNormal,
  ABI50_0_0RNSVGFontStyleItalic,
  ABI50_0_0RNSVGFontStyleOblique,
  ABI50_0_0RNSVGFontStyleDEFAULT = ABI50_0_0RNSVGFontStyleNormal,
};

static NSString *const ABI50_0_0RNSVGFontStyleStrings[] = {@"normal", @"italic", @"oblique", nil};

NSString *ABI50_0_0RNSVGFontStyleToString(enum ABI50_0_0RNSVGFontStyle fw);

enum ABI50_0_0RNSVGFontStyle ABI50_0_0RNSVGFontStyleFromString(NSString *s);

typedef NS_ENUM(NSInteger, ABI50_0_0RNSVGFontVariantLigatures) {
  ABI50_0_0RNSVGFontVariantLigaturesNormal,
  ABI50_0_0RNSVGFontVariantLigaturesNone,
  ABI50_0_0RNSVGFontVariantLigaturesDEFAULT = ABI50_0_0RNSVGFontVariantLigaturesNormal,
};

static NSString *const ABI50_0_0RNSVGFontVariantLigaturesStrings[] = {@"normal", @"none", nil};

NSString *ABI50_0_0RNSVGFontVariantLigaturesToString(enum ABI50_0_0RNSVGFontVariantLigatures fw);

enum ABI50_0_0RNSVGFontVariantLigatures ABI50_0_0RNSVGFontVariantLigaturesFromString(NSString *s);

typedef NS_ENUM(NSInteger, ABI50_0_0RNSVGFontWeight) {
  // Absolute
  ABI50_0_0RNSVGFontWeightNormal,
  ABI50_0_0RNSVGFontWeightBold,
  ABI50_0_0RNSVGFontWeight100,
  ABI50_0_0RNSVGFontWeight200,
  ABI50_0_0RNSVGFontWeight300,
  ABI50_0_0RNSVGFontWeight400,
  ABI50_0_0RNSVGFontWeight500,
  ABI50_0_0RNSVGFontWeight600,
  ABI50_0_0RNSVGFontWeight700,
  ABI50_0_0RNSVGFontWeight800,
  ABI50_0_0RNSVGFontWeight900,
  // Relative
  ABI50_0_0RNSVGFontWeightBolder,
  ABI50_0_0RNSVGFontWeightLighter,
  ABI50_0_0RNSVGFontWeightDEFAULT = ABI50_0_0RNSVGFontWeightNormal,
};

static NSString *const ABI50_0_0RNSVGFontWeightStrings[] = {
    @"normal",
    @"bold",
    @"100",
    @"200",
    @"300",
    @"400",
    @"500",
    @"600",
    @"700",
    @"800",
    @"900",
    @"bolder",
    @"lighter",
    nil};

static int const ABI50_0_0RNSVGAbsoluteFontWeights[] = {400, 700, 100, 200, 300, 400, 500, 600, 700, 800, 900};

static ABI50_0_0RNSVGFontWeight const ABI50_0_0RNSVGFontWeights[] = {
    ABI50_0_0RNSVGFontWeight100,
    ABI50_0_0RNSVGFontWeight100,
    ABI50_0_0RNSVGFontWeight200,
    ABI50_0_0RNSVGFontWeight300,
    ABI50_0_0RNSVGFontWeightNormal,
    ABI50_0_0RNSVGFontWeight500,
    ABI50_0_0RNSVGFontWeight600,
    ABI50_0_0RNSVGFontWeightBold,
    ABI50_0_0RNSVGFontWeight800,
    ABI50_0_0RNSVGFontWeight900,
    ABI50_0_0RNSVGFontWeight900};

NSString *ABI50_0_0RNSVGFontWeightToString(enum ABI50_0_0RNSVGFontWeight fw);

NSInteger ABI50_0_0RNSVGFontWeightFromString(NSString *s);

typedef NS_ENUM(NSInteger, ABI50_0_0RNSVGTextAnchor) {
  ABI50_0_0RNSVGTextAnchorStart,
  ABI50_0_0RNSVGTextAnchorMiddle,
  ABI50_0_0RNSVGTextAnchorEnd,
  ABI50_0_0RNSVGTextAnchorDEFAULT = ABI50_0_0RNSVGTextAnchorStart,
};

static NSString *const ABI50_0_0RNSVGTextAnchorStrings[] = {@"start", @"middle", @"end", nil};

NSString *ABI50_0_0RNSVGTextAnchorToString(enum ABI50_0_0RNSVGTextAnchor fw);

enum ABI50_0_0RNSVGTextAnchor ABI50_0_0RNSVGTextAnchorFromString(NSString *s);

typedef NS_ENUM(NSInteger, ABI50_0_0RNSVGTextDecoration) {
  ABI50_0_0RNSVGTextDecorationNone,
  ABI50_0_0RNSVGTextDecorationUnderline,
  ABI50_0_0RNSVGTextDecorationOverline,
  ABI50_0_0RNSVGTextDecorationLineThrough,
  ABI50_0_0RNSVGTextDecorationBlink,
  ABI50_0_0RNSVGTextDecorationDEFAULT = ABI50_0_0RNSVGTextDecorationNone,
};

static NSString *const ABI50_0_0RNSVGTextDecorationStrings[] =
    {@"None", @"Underline", @"Overline", @"LineThrough", @"Blink", nil};

NSString *ABI50_0_0RNSVGTextDecorationToString(enum ABI50_0_0RNSVGTextDecoration fw);

enum ABI50_0_0RNSVGTextDecoration ABI50_0_0RNSVGTextDecorationFromString(NSString *s);

typedef NS_ENUM(NSInteger, ABI50_0_0RNSVGTextLengthAdjust) {
  ABI50_0_0RNSVGTextLengthAdjustSpacing,
  ABI50_0_0RNSVGTextLengthAdjustSpacingAndGlyphs,
  ABI50_0_0RNSVGTextLengthAdjustDEFAULT = ABI50_0_0RNSVGTextLengthAdjustSpacing,
};

static NSString *const ABI50_0_0RNSVGTextLengthAdjustStrings[] = {@"spacing", @"spacingAndGlyphs", nil};

NSString *ABI50_0_0RNSVGTextLengthAdjustToString(enum ABI50_0_0RNSVGTextLengthAdjust fw);

enum ABI50_0_0RNSVGTextLengthAdjust ABI50_0_0RNSVGTextLengthAdjustFromString(NSString *s);

typedef NS_ENUM(NSInteger, ABI50_0_0RNSVGTextPathMethod) {
  ABI50_0_0RNSVGTextPathMethodAlign,
  ABI50_0_0RNSVGTextPathMethodStretch,
  ABI50_0_0RNSVGTextPathMethodDEFAULT = ABI50_0_0RNSVGTextPathMethodAlign,
};

static NSString *const ABI50_0_0RNSVGTextPathMethodStrings[] = {@"align", @"stretch", nil};

NSString *ABI50_0_0RNSVGTextPathMethodToString(enum ABI50_0_0RNSVGTextPathMethod fw);

enum ABI50_0_0RNSVGTextPathMethod ABI50_0_0RNSVGTextPathMethodFromString(NSString *s);

typedef NS_ENUM(NSInteger, ABI50_0_0RNSVGTextPathMidLine) {
  ABI50_0_0RNSVGTextPathMidLineSharp,
  ABI50_0_0RNSVGTextPathMidLineSmooth,
  ABI50_0_0RNSVGTextPathMidLineDEFAULT = ABI50_0_0RNSVGTextPathMidLineSharp,
};

static NSString *const ABI50_0_0RNSVGTextPathMidLineStrings[] = {@"sharp", @"smooth", nil};

NSString *ABI50_0_0RNSVGTextPathMidLineToString(enum ABI50_0_0RNSVGTextPathMidLine fw);

enum ABI50_0_0RNSVGTextPathMidLine ABI50_0_0RNSVGTextPathMidLineFromString(NSString *s);

typedef NS_ENUM(NSInteger, ABI50_0_0RNSVGTextPathSide) {
  ABI50_0_0RNSVGTextPathSideLeft,
  ABI50_0_0RNSVGTextPathSideRight,
  ABI50_0_0RNSVGTextPathSideDEFAULT = ABI50_0_0RNSVGTextPathSideLeft,
};

static NSString *const ABI50_0_0RNSVGTextPathSideStrings[] = {@"left", @"right", nil};

NSString *ABI50_0_0RNSVGTextPathSideToString(enum ABI50_0_0RNSVGTextPathSide fw);

enum ABI50_0_0RNSVGTextPathSide ABI50_0_0RNSVGTextPathSideFromString(NSString *s);

typedef NS_ENUM(NSInteger, ABI50_0_0RNSVGTextPathSpacing) {
  ABI50_0_0RNSVGTextPathSpacingAutoSpacing,
  ABI50_0_0RNSVGTextPathSpacingExact,
  ABI50_0_0RNSVGTextPathSpacingDEFAULT = ABI50_0_0RNSVGTextPathSpacingAutoSpacing,
};

static NSString *const ABI50_0_0RNSVGTextPathSpacingStrings[] = {@"auto", @"exact", nil};

NSString *ABI50_0_0RNSVGTextPathSpacingToString(enum ABI50_0_0RNSVGTextPathSpacing fw);

enum ABI50_0_0RNSVGTextPathSpacing ABI50_0_0RNSVGTextPathSpacingFromString(NSString *s);

#endif
