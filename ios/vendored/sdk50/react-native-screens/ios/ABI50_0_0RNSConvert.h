#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <react/renderer/components/rnscreens/Props.h>
#import "ABI50_0_0RNSEnums.h"

namespace ABI50_0_0React = ABI50_0_0facebook::ABI50_0_0React;

@interface ABI50_0_0RNSConvert : NSObject

+ (ABI50_0_0RNSScreenStackPresentation)ABI50_0_0RNSScreenStackPresentationFromCppEquivalent:
    (ABI50_0_0React::ABI50_0_0RNSScreenStackPresentation)stackPresentation;

+ (ABI50_0_0RNSScreenStackAnimation)ABI50_0_0RNSScreenStackAnimationFromCppEquivalent:(ABI50_0_0React::ABI50_0_0RNSScreenStackAnimation)stackAnimation;

+ (ABI50_0_0RNSScreenStackHeaderSubviewType)ABI50_0_0RNSScreenStackHeaderSubviewTypeFromCppEquivalent:
    (ABI50_0_0React::ABI50_0_0RNSScreenStackHeaderSubviewType)subviewType;

+ (ABI50_0_0RNSScreenReplaceAnimation)ABI50_0_0RNSScreenReplaceAnimationFromCppEquivalent:
    (ABI50_0_0React::ABI50_0_0RNSScreenReplaceAnimation)replaceAnimation;

+ (ABI50_0_0RNSScreenSwipeDirection)ABI50_0_0RNSScreenSwipeDirectionFromCppEquivalent:(ABI50_0_0React::ABI50_0_0RNSScreenSwipeDirection)swipeDirection;

+ (ABI50_0_0RNSScreenDetentType)ABI50_0_0RNSScreenDetentTypeFromAllowedDetents:(ABI50_0_0React::ABI50_0_0RNSScreenSheetAllowedDetents)allowedDetents;

+ (ABI50_0_0RNSScreenDetentType)ABI50_0_0RNSScreenDetentTypeFromLargestUndimmedDetent:(ABI50_0_0React::ABI50_0_0RNSScreenSheetLargestUndimmedDetent)detent;

+ (NSDictionary *)gestureResponseDistanceDictFromCppStruct:
    (const ABI50_0_0React::ABI50_0_0RNSScreenGestureResponseDistanceStruct &)gestureResponseDistance;

+ (UITextAutocapitalizationType)UITextAutocapitalizationTypeFromCppEquivalent:
    (ABI50_0_0React::ABI50_0_0RNSSearchBarAutoCapitalize)autoCapitalize;

+ (ABI50_0_0RNSSearchBarPlacement)ABI50_0_0RNSScreenSearchBarPlacementFromCppEquivalent:(ABI50_0_0React::ABI50_0_0RNSSearchBarPlacement)placement;

@end

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
