#import <UIKit/UIKit.h>

#import "ABI50_0_0RNSSearchBar.h"

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponent.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricComponentsPlugins.h>
#import <react/renderer/components/rnscreens/ComponentDescriptors.h>
#import <react/renderer/components/rnscreens/EventEmitters.h>
#import <react/renderer/components/rnscreens/Props.h>
#import "ABI50_0_0RNSConvert.h"
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
namespace ABI50_0_0React = ABI50_0_0facebook::ABI50_0_0React;
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@implementation ABI50_0_0RNSSearchBar {
  __weak ABI50_0_0RCTBridge *_bridge;
  UISearchController *_controller;
  UIColor *_textColor;
}

@synthesize controller = _controller;

- (instancetype)initWithBridge:(ABI50_0_0RCTBridge *)bridge
{
  if (self = [super init]) {
    _bridge = bridge;
    [self initCommonProps];
  }
  return self;
}

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
- (instancetype)init
{
  if (self = [super init]) {
    static const auto defaultProps = std::make_shared<const ABI50_0_0React::ABI50_0_0RNSSearchBarProps>();
    _props = defaultProps;
    [self initCommonProps];
  }
  return self;
}
#endif

- (void)initCommonProps
{
  _controller = [[UISearchController alloc] initWithSearchResultsController:nil];
  _controller.searchBar.delegate = self;
  _hideWhenScrolling = YES;
  _placement = ABI50_0_0RNSSearchBarPlacementStacked;
}

- (void)emitOnFocusEvent
{
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  if (_eventEmitter != nullptr) {
    std::dynamic_pointer_cast<const ABI50_0_0React::ABI50_0_0RNSSearchBarEventEmitter>(_eventEmitter)
        ->onFocus(ABI50_0_0React::ABI50_0_0RNSSearchBarEventEmitter::OnFocus{});
  }
#else
  if (self.onFocus) {
    self.onFocus(@{});
  }
#endif
}

- (void)emitOnBlurEvent
{
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  if (_eventEmitter != nullptr) {
    std::dynamic_pointer_cast<const ABI50_0_0React::ABI50_0_0RNSSearchBarEventEmitter>(_eventEmitter)
        ->onBlur(ABI50_0_0React::ABI50_0_0RNSSearchBarEventEmitter::OnBlur{});
  }
#else
  if (self.onBlur) {
    self.onBlur(@{});
  }
#endif
}

- (void)emitOnSearchButtonPressEventWithText:(NSString *)text
{
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  if (_eventEmitter != nullptr) {
    std::dynamic_pointer_cast<const ABI50_0_0React::ABI50_0_0RNSSearchBarEventEmitter>(_eventEmitter)
        ->onSearchButtonPress(
            ABI50_0_0React::ABI50_0_0RNSSearchBarEventEmitter::OnSearchButtonPress{.text = ABI50_0_0RCTStringFromNSString(text)});
  }
#else
  if (self.onSearchButtonPress) {
    self.onSearchButtonPress(@{
      @"text" : text,
    });
  }
#endif
}

- (void)emitOnCancelButtonPressEvent
{
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  if (_eventEmitter != nullptr) {
    std::dynamic_pointer_cast<const ABI50_0_0React::ABI50_0_0RNSSearchBarEventEmitter>(_eventEmitter)
        ->onCancelButtonPress(ABI50_0_0React::ABI50_0_0RNSSearchBarEventEmitter::OnCancelButtonPress{});
  }
#else
  if (self.onCancelButtonPress) {
    self.onCancelButtonPress(@{});
  }
#endif
}

- (void)emitOnChangeTextEventWithText:(NSString *)text
{
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  if (_eventEmitter != nullptr) {
    std::dynamic_pointer_cast<const ABI50_0_0React::ABI50_0_0RNSSearchBarEventEmitter>(_eventEmitter)
        ->onChangeText(ABI50_0_0React::ABI50_0_0RNSSearchBarEventEmitter::OnChangeText{.text = ABI50_0_0RCTStringFromNSString(text)});
  }
#else
  if (self.onChangeText) {
    self.onChangeText(@{
      @"text" : text,
    });
  }
#endif
}

- (void)setObscureBackground:(BOOL)obscureBackground
{
  if (@available(iOS 9.1, *)) {
    [_controller setObscuresBackgroundDuringPresentation:obscureBackground];
  }
}

- (void)setHideNavigationBar:(BOOL)hideNavigationBar
{
  [_controller setHidesNavigationBarDuringPresentation:hideNavigationBar];
}

- (void)setHideWhenScrolling:(BOOL)hideWhenScrolling
{
  _hideWhenScrolling = hideWhenScrolling;
}

- (void)setAutoCapitalize:(UITextAutocapitalizationType)autoCapitalize
{
  [_controller.searchBar setAutocapitalizationType:autoCapitalize];
}

- (void)setPlaceholder:(NSString *)placeholder
{
  [_controller.searchBar setPlaceholder:placeholder];
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && defined(__IPHONE_13_0) && \
    __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0 && !TARGET_OS_TV
  if (@available(iOS 13.0, *)) {
    [_controller.searchBar.searchTextField setBackgroundColor:barTintColor];
  }
#endif
}

- (void)setTintColor:(UIColor *)tintColor
{
  [_controller.searchBar setTintColor:tintColor];
}

- (void)setTextColor:(UIColor *)textColor
{
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && defined(__IPHONE_13_0) && \
    __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0 && !TARGET_OS_TV
  _textColor = textColor;
  if (@available(iOS 13.0, *)) {
    [_controller.searchBar.searchTextField setTextColor:_textColor];
  }
#endif
}

- (void)setCancelButtonText:(NSString *)text
{
  [_controller.searchBar setValue:text forKey:@"cancelButtonText"];
}

- (void)hideCancelButton
{
#if !TARGET_OS_TV
  if (@available(iOS 13, *)) {
    // On iOS 13+ UISearchController automatically shows/hides cancel button
    // https://developer.apple.com/documentation/uikit/uisearchcontroller/3152926-automaticallyshowscancelbutton?language=objc
  } else {
    [_controller.searchBar setShowsCancelButton:NO animated:YES];
  }
#endif
}

- (void)showCancelButton
{
#if !TARGET_OS_TV
  if (@available(iOS 13, *)) {
    // On iOS 13+ UISearchController automatically shows/hides cancel button
    // https://developer.apple.com/documentation/uikit/uisearchcontroller/3152926-automaticallyshowscancelbutton?language=objc
  } else {
    [_controller.searchBar setShowsCancelButton:YES animated:YES];
  }
#endif
}

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && defined(__IPHONE_16_0) && \
    __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_16_0 && !TARGET_OS_TV
- (UINavigationItemSearchBarPlacement)placementAsUINavigationItemSearchBarPlacement API_AVAILABLE(ios(16.0))
    API_UNAVAILABLE(tvos, watchos)
{
  switch (_placement) {
    case ABI50_0_0RNSSearchBarPlacementStacked:
      return UINavigationItemSearchBarPlacementStacked;
    case ABI50_0_0RNSSearchBarPlacementAutomatic:
      return UINavigationItemSearchBarPlacementAutomatic;
    case ABI50_0_0RNSSearchBarPlacementInline:
      return UINavigationItemSearchBarPlacementInline;
  }
}
#endif // Check for iOS >= 16 && !TARGET_OS_TV

#pragma mark delegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && defined(__IPHONE_13_0) && \
    __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0 && !TARGET_OS_TV
  if (@available(iOS 13.0, *)) {
    // for some reason, the color does not change when set at the beginning,
    // so we apply it again here
    if (_textColor != nil) {
      [_controller.searchBar.searchTextField setTextColor:_textColor];
    }
  }
#endif

  [self showCancelButton];
  [self becomeFirstResponder];
  [self emitOnFocusEvent];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
  [self emitOnBlurEvent];
  [self hideCancelButton];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  [self emitOnChangeTextEventWithText:_controller.searchBar.text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [self emitOnSearchButtonPressEventWithText:_controller.searchBar.text];
}

#if !TARGET_OS_TV
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  _controller.searchBar.text = @"";
  [self resignFirstResponder];
  [self hideCancelButton];

  [self emitOnCancelButtonPressEvent];
  [self emitOnChangeTextEventWithText:_controller.searchBar.text];
}
#endif // !TARGET_OS_TV

- (void)blur
{
  [_controller.searchBar resignFirstResponder];
}

- (void)focus
{
  [_controller.searchBar becomeFirstResponder];
}

- (void)clearText
{
  [_controller.searchBar setText:@""];
}

- (void)toggleCancelButton:(BOOL)flag
{
#if !TARGET_OS_TV
  [_controller.searchBar setShowsCancelButton:flag animated:YES];
#endif
}

- (void)setText:(NSString *)text
{
  [_controller.searchBar setText:text];
}

#pragma mark-- Fabric specific

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
- (void)updateProps:(ABI50_0_0React::Props::Shared const &)props oldProps:(ABI50_0_0React::Props::Shared const &)oldProps
{
  const auto &oldScreenProps = *std::static_pointer_cast<const ABI50_0_0React::ABI50_0_0RNSSearchBarProps>(_props);
  const auto &newScreenProps = *std::static_pointer_cast<const ABI50_0_0React::ABI50_0_0RNSSearchBarProps>(props);

  [self setHideWhenScrolling:newScreenProps.hideWhenScrolling];

  if (oldScreenProps.cancelButtonText != newScreenProps.cancelButtonText) {
    [self setCancelButtonText:ABI50_0_0RCTNSStringFromStringNilIfEmpty(newScreenProps.cancelButtonText)];
  }

  if (oldScreenProps.obscureBackground != newScreenProps.obscureBackground) {
    [self setObscureBackground:newScreenProps.obscureBackground];
  }

  if (oldScreenProps.hideNavigationBar != newScreenProps.hideNavigationBar) {
    [self setHideNavigationBar:newScreenProps.hideNavigationBar];
  }

  if (oldScreenProps.placeholder != newScreenProps.placeholder) {
    [self setPlaceholder:ABI50_0_0RCTNSStringFromStringNilIfEmpty(newScreenProps.placeholder)];
  }

  if (oldScreenProps.autoCapitalize != newScreenProps.autoCapitalize) {
    [self setAutoCapitalize:[ABI50_0_0RNSConvert UITextAutocapitalizationTypeFromCppEquivalent:newScreenProps.autoCapitalize]];
  }

  if (oldScreenProps.tintColor != newScreenProps.tintColor) {
    [self setTintColor:ABI50_0_0RCTUIColorFromSharedColor(newScreenProps.tintColor)];
  }

  if (oldScreenProps.barTintColor != newScreenProps.barTintColor) {
    [self setBarTintColor:ABI50_0_0RCTUIColorFromSharedColor(newScreenProps.barTintColor)];
  }

  if (oldScreenProps.textColor != newScreenProps.textColor) {
    [self setTextColor:ABI50_0_0RCTUIColorFromSharedColor(newScreenProps.textColor)];
  }

  if (oldScreenProps.placement != newScreenProps.placement) {
    self.placement = [ABI50_0_0RNSConvert ABI50_0_0RNSScreenSearchBarPlacementFromCppEquivalent:newScreenProps.placement];
  }

  [super updateProps:props oldProps:oldProps];
}

+ (ABI50_0_0React::ComponentDescriptorProvider)componentDescriptorProvider
{
  return ABI50_0_0React::concreteComponentDescriptorProvider<ABI50_0_0React::ABI50_0_0RNSSearchBarComponentDescriptor>();
}

- (void)handleCommand:(const NSString *)commandName args:(const NSArray *)args
{
  ABI50_0_0RCTRNSSearchBarHandleCommand(self, commandName, args);
}

#else
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@end

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RNSSearchBarCls(void)
{
  return ABI50_0_0RNSSearchBar.class;
}
#endif

@implementation ABI50_0_0RNSSearchBarManager

ABI50_0_0RCT_EXPORT_MODULE()

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#else
- (UIView *)view
{
  return [[ABI50_0_0RNSSearchBar alloc] initWithBridge:self.bridge];
}
#endif

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(obscureBackground, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(hideNavigationBar, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(hideWhenScrolling, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(autoCapitalize, UITextAutocapitalizationType)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(placeholder, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(barTintColor, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(tintColor, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(textColor, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(cancelButtonText, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(placement, ABI50_0_0RNSSearchBarPlacement)

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onChangeText, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onCancelButtonPress, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onSearchButtonPress, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onFocus, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onBlur, ABI50_0_0RCTBubblingEventBlock)

#ifndef ABI50_0_0RCT_NEW_ARCH_ENABLED

ABI50_0_0RCT_EXPORT_METHOD(focus : (NSNumber *_Nonnull)ABI50_0_0ReactTag)
{
  [self.bridge.uiManager addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary *viewRegistry) {
    ABI50_0_0RNSSearchBar *searchBar = viewRegistry[ABI50_0_0ReactTag];
    [searchBar focus];
  }];
}

ABI50_0_0RCT_EXPORT_METHOD(blur : (NSNumber *_Nonnull)ABI50_0_0ReactTag)
{
  [self.bridge.uiManager addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary *viewRegistry) {
    ABI50_0_0RNSSearchBar *searchBar = viewRegistry[ABI50_0_0ReactTag];
    [searchBar blur];
  }];
}

ABI50_0_0RCT_EXPORT_METHOD(clearText : (NSNumber *_Nonnull)ABI50_0_0ReactTag)
{
  [self.bridge.uiManager addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary *viewRegistry) {
    ABI50_0_0RNSSearchBar *searchBar = viewRegistry[ABI50_0_0ReactTag];
    [searchBar clearText];
  }];
}

ABI50_0_0RCT_EXPORT_METHOD(toggleCancelButton : (NSNumber *_Nonnull)ABI50_0_0ReactTag flag : (BOOL)flag)
{
  [self.bridge.uiManager addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary *viewRegistry) {
    ABI50_0_0RNSSearchBar *searchBar = viewRegistry[ABI50_0_0ReactTag];
    [searchBar toggleCancelButton:flag];
  }];
}

ABI50_0_0RCT_EXPORT_METHOD(setText : (NSNumber *_Nonnull)ABI50_0_0ReactTag text : (NSString *)text)
{
  [self.bridge.uiManager addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary *viewRegistry) {
    ABI50_0_0RNSSearchBar *searchBar = viewRegistry[ABI50_0_0ReactTag];
    [searchBar setText:text];
  }];
}

#endif /* !ABI50_0_0RCT_NEW_ARCH_ENABLED */

@end

@implementation ABI50_0_0RCTConvert (ABI50_0_0RNSScreen)

ABI50_0_0RCT_ENUM_CONVERTER(
    ABI50_0_0RNSSearchBarPlacement,
    (@{
      @"automatic" : @(ABI50_0_0RNSSearchBarPlacementAutomatic),
      @"inline" : @(ABI50_0_0RNSSearchBarPlacementInline),
      @"stacked" : @(ABI50_0_0RNSSearchBarPlacementStacked),
    }),
    ABI50_0_0RNSSearchBarPlacementStacked,
    integerValue)

@end
