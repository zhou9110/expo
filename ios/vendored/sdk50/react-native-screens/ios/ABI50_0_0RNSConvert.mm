#import "ABI50_0_0RNSConvert.h"

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
@implementation ABI50_0_0RNSConvert

+ (ABI50_0_0RNSScreenStackPresentation)ABI50_0_0RNSScreenStackPresentationFromCppEquivalent:
    (ABI50_0_0React::ABI50_0_0RNSScreenStackPresentation)stackPresentation
{
  switch (stackPresentation) {
    case ABI50_0_0React::ABI50_0_0RNSScreenStackPresentation::Push:
      return ABI50_0_0RNSScreenStackPresentationPush;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackPresentation::Modal:
      return ABI50_0_0RNSScreenStackPresentationModal;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackPresentation::FullScreenModal:
      return ABI50_0_0RNSScreenStackPresentationFullScreenModal;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackPresentation::FormSheet:
      return ABI50_0_0RNSScreenStackPresentationFormSheet;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackPresentation::ContainedModal:
      return ABI50_0_0RNSScreenStackPresentationContainedModal;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackPresentation::TransparentModal:
      return ABI50_0_0RNSScreenStackPresentationTransparentModal;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackPresentation::ContainedTransparentModal:
      return ABI50_0_0RNSScreenStackPresentationContainedTransparentModal;
  }
}

+ (ABI50_0_0RNSScreenStackAnimation)ABI50_0_0RNSScreenStackAnimationFromCppEquivalent:(ABI50_0_0React::ABI50_0_0RNSScreenStackAnimation)stackAnimation
{
  switch (stackAnimation) {
    // these three are intentionally grouped
    case ABI50_0_0React::ABI50_0_0RNSScreenStackAnimation::Slide_from_right:
    case ABI50_0_0React::ABI50_0_0RNSScreenStackAnimation::Slide_from_left:
    case ABI50_0_0React::ABI50_0_0RNSScreenStackAnimation::Default:
      return ABI50_0_0RNSScreenStackAnimationDefault;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackAnimation::Flip:
      return ABI50_0_0RNSScreenStackAnimationFlip;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackAnimation::Simple_push:
      return ABI50_0_0RNSScreenStackAnimationSimplePush;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackAnimation::None:
      return ABI50_0_0RNSScreenStackAnimationNone;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackAnimation::Fade:
      return ABI50_0_0RNSScreenStackAnimationFade;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackAnimation::Slide_from_bottom:
      return ABI50_0_0RNSScreenStackAnimationSlideFromBottom;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackAnimation::Fade_from_bottom:
      return ABI50_0_0RNSScreenStackAnimationFadeFromBottom;
  }
}

+ (ABI50_0_0RNSScreenStackHeaderSubviewType)ABI50_0_0RNSScreenStackHeaderSubviewTypeFromCppEquivalent:
    (ABI50_0_0React::ABI50_0_0RNSScreenStackHeaderSubviewType)subviewType
{
  switch (subviewType) {
    case ABI50_0_0React::ABI50_0_0RNSScreenStackHeaderSubviewType::Left:
      return ABI50_0_0RNSScreenStackHeaderSubviewTypeLeft;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackHeaderSubviewType::Right:
      return ABI50_0_0RNSScreenStackHeaderSubviewTypeRight;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackHeaderSubviewType::Title:
      return ABI50_0_0RNSScreenStackHeaderSubviewTypeTitle;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackHeaderSubviewType::Center:
      return ABI50_0_0RNSScreenStackHeaderSubviewTypeCenter;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackHeaderSubviewType::SearchBar:
      return ABI50_0_0RNSScreenStackHeaderSubviewTypeSearchBar;
    case ABI50_0_0React::ABI50_0_0RNSScreenStackHeaderSubviewType::Back:
      return ABI50_0_0RNSScreenStackHeaderSubviewTypeBackButton;
  }
}

+ (ABI50_0_0RNSScreenReplaceAnimation)ABI50_0_0RNSScreenReplaceAnimationFromCppEquivalent:
    (ABI50_0_0React::ABI50_0_0RNSScreenReplaceAnimation)replaceAnimation
{
  switch (replaceAnimation) {
    case ABI50_0_0React::ABI50_0_0RNSScreenReplaceAnimation::Pop:
      return ABI50_0_0RNSScreenReplaceAnimationPop;
    case ABI50_0_0React::ABI50_0_0RNSScreenReplaceAnimation::Push:
      return ABI50_0_0RNSScreenReplaceAnimationPush;
  }
}

+ (ABI50_0_0RNSScreenSwipeDirection)ABI50_0_0RNSScreenSwipeDirectionFromCppEquivalent:(ABI50_0_0React::ABI50_0_0RNSScreenSwipeDirection)swipeDirection
{
  switch (swipeDirection) {
    case ABI50_0_0React::ABI50_0_0RNSScreenSwipeDirection::Horizontal:
      return ABI50_0_0RNSScreenSwipeDirectionHorizontal;
    case ABI50_0_0React::ABI50_0_0RNSScreenSwipeDirection::Vertical:
      return ABI50_0_0RNSScreenSwipeDirectionVertical;
  }
}

+ (ABI50_0_0RNSScreenDetentType)ABI50_0_0RNSScreenDetentTypeFromAllowedDetents:(ABI50_0_0React::ABI50_0_0RNSScreenSheetAllowedDetents)allowedDetents
{
  switch (allowedDetents) {
    case ABI50_0_0React::ABI50_0_0RNSScreenSheetAllowedDetents::All:
      return ABI50_0_0RNSScreenDetentTypeAll;
    case ABI50_0_0React::ABI50_0_0RNSScreenSheetAllowedDetents::Large:
      return ABI50_0_0RNSScreenDetentTypeLarge;
    case ABI50_0_0React::ABI50_0_0RNSScreenSheetAllowedDetents::Medium:
      return ABI50_0_0RNSScreenDetentTypeMedium;
  }
}

+ (ABI50_0_0RNSScreenDetentType)ABI50_0_0RNSScreenDetentTypeFromLargestUndimmedDetent:(ABI50_0_0React::ABI50_0_0RNSScreenSheetLargestUndimmedDetent)detent
{
  switch (detent) {
    case ABI50_0_0React::ABI50_0_0RNSScreenSheetLargestUndimmedDetent::All:
      return ABI50_0_0RNSScreenDetentTypeAll;
    case ABI50_0_0React::ABI50_0_0RNSScreenSheetLargestUndimmedDetent::Large:
      return ABI50_0_0RNSScreenDetentTypeLarge;
    case ABI50_0_0React::ABI50_0_0RNSScreenSheetLargestUndimmedDetent::Medium:
      return ABI50_0_0RNSScreenDetentTypeMedium;
  }
}

+ (NSDictionary *)gestureResponseDistanceDictFromCppStruct:
    (const ABI50_0_0React::ABI50_0_0RNSScreenGestureResponseDistanceStruct &)gestureResponseDistance
{
  return @{
    @"start" : @(gestureResponseDistance.start),
    @"end" : @(gestureResponseDistance.end),
    @"top" : @(gestureResponseDistance.top),
    @"bottom" : @(gestureResponseDistance.bottom),
  };
}

+ (UITextAutocapitalizationType)UITextAutocapitalizationTypeFromCppEquivalent:
    (ABI50_0_0React::ABI50_0_0RNSSearchBarAutoCapitalize)autoCapitalize
{
  switch (autoCapitalize) {
    case ABI50_0_0React::ABI50_0_0RNSSearchBarAutoCapitalize::Words:
      return UITextAutocapitalizationTypeWords;
    case ABI50_0_0React::ABI50_0_0RNSSearchBarAutoCapitalize::Sentences:
      return UITextAutocapitalizationTypeSentences;
    case ABI50_0_0React::ABI50_0_0RNSSearchBarAutoCapitalize::Characters:
      return UITextAutocapitalizationTypeAllCharacters;
    case ABI50_0_0React::ABI50_0_0RNSSearchBarAutoCapitalize::None:
      return UITextAutocapitalizationTypeNone;
  }
}

+ (ABI50_0_0RNSSearchBarPlacement)ABI50_0_0RNSScreenSearchBarPlacementFromCppEquivalent:(ABI50_0_0React::ABI50_0_0RNSSearchBarPlacement)placement
{
  switch (placement) {
    case ABI50_0_0React::ABI50_0_0RNSSearchBarPlacement::Stacked:
      return ABI50_0_0RNSSearchBarPlacementStacked;
    case ABI50_0_0React::ABI50_0_0RNSSearchBarPlacement::Automatic:
      return ABI50_0_0RNSSearchBarPlacementAutomatic;
    case ABI50_0_0React::ABI50_0_0RNSSearchBarPlacement::Inline:
      return ABI50_0_0RNSSearchBarPlacementInline;
  }
}

@end

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
