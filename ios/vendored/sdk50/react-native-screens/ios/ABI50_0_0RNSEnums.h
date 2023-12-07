typedef NS_ENUM(NSInteger, ABI50_0_0RNSScreenStackPresentation) {
  ABI50_0_0RNSScreenStackPresentationPush,
  ABI50_0_0RNSScreenStackPresentationModal,
  ABI50_0_0RNSScreenStackPresentationTransparentModal,
  ABI50_0_0RNSScreenStackPresentationContainedModal,
  ABI50_0_0RNSScreenStackPresentationContainedTransparentModal,
  ABI50_0_0RNSScreenStackPresentationFullScreenModal,
  ABI50_0_0RNSScreenStackPresentationFormSheet
};

typedef NS_ENUM(NSInteger, ABI50_0_0RNSScreenStackAnimation) {
  ABI50_0_0RNSScreenStackAnimationDefault,
  ABI50_0_0RNSScreenStackAnimationNone,
  ABI50_0_0RNSScreenStackAnimationFade,
  ABI50_0_0RNSScreenStackAnimationFadeFromBottom,
  ABI50_0_0RNSScreenStackAnimationFlip,
  ABI50_0_0RNSScreenStackAnimationSlideFromBottom,
  ABI50_0_0RNSScreenStackAnimationSimplePush,
};

typedef NS_ENUM(NSInteger, ABI50_0_0RNSScreenReplaceAnimation) {
  ABI50_0_0RNSScreenReplaceAnimationPop,
  ABI50_0_0RNSScreenReplaceAnimationPush,
};

typedef NS_ENUM(NSInteger, ABI50_0_0RNSScreenSwipeDirection) {
  ABI50_0_0RNSScreenSwipeDirectionHorizontal,
  ABI50_0_0RNSScreenSwipeDirectionVertical,
};

typedef NS_ENUM(NSInteger, ABI50_0_0RNSActivityState) {
  ABI50_0_0RNSActivityStateInactive = 0,
  ABI50_0_0RNSActivityStateTransitioningOrBelowTop = 1,
  ABI50_0_0RNSActivityStateOnTop = 2
};

typedef NS_ENUM(NSInteger, ABI50_0_0RNSStatusBarStyle) {
  ABI50_0_0RNSStatusBarStyleAuto,
  ABI50_0_0RNSStatusBarStyleInverted,
  ABI50_0_0RNSStatusBarStyleLight,
  ABI50_0_0RNSStatusBarStyleDark,
};

typedef NS_ENUM(NSInteger, ABI50_0_0RNSWindowTrait) {
  ABI50_0_0RNSWindowTraitStyle,
  ABI50_0_0RNSWindowTraitAnimation,
  ABI50_0_0RNSWindowTraitHidden,
  ABI50_0_0RNSWindowTraitOrientation,
  ABI50_0_0RNSWindowTraitHomeIndicatorHidden,
};

typedef NS_ENUM(NSInteger, ABI50_0_0RNSScreenStackHeaderSubviewType) {
  ABI50_0_0RNSScreenStackHeaderSubviewTypeBackButton,
  ABI50_0_0RNSScreenStackHeaderSubviewTypeLeft,
  ABI50_0_0RNSScreenStackHeaderSubviewTypeRight,
  ABI50_0_0RNSScreenStackHeaderSubviewTypeTitle,
  ABI50_0_0RNSScreenStackHeaderSubviewTypeCenter,
  ABI50_0_0RNSScreenStackHeaderSubviewTypeSearchBar,
};

typedef NS_ENUM(NSInteger, ABI50_0_0RNSScreenDetentType) {
  ABI50_0_0RNSScreenDetentTypeMedium,
  ABI50_0_0RNSScreenDetentTypeLarge,
  ABI50_0_0RNSScreenDetentTypeAll,
};

typedef NS_ENUM(NSInteger, ABI50_0_0RNSSearchBarPlacement) {
  ABI50_0_0RNSSearchBarPlacementAutomatic,
  ABI50_0_0RNSSearchBarPlacementInline,
  ABI50_0_0RNSSearchBarPlacementStacked,
};
