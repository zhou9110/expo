#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED

#import "ABI50_0_0RNGestureHandlerButtonComponentView.h"

#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricComponentsPlugins.h>

#import <react/renderer/components/rngesturehandler_codegen/ComponentDescriptors.h>
#import <react/renderer/components/rngesturehandler_codegen/EventEmitters.h>
#import <react/renderer/components/rngesturehandler_codegen/Props.h>
#import <react/renderer/components/rngesturehandler_codegen/ABI50_0_0RCTComponentViewHelpers.h>

#import "ABI50_0_0RNGestureHandlerButton.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

@interface ABI50_0_0RNGestureHandlerButtonComponentView () <ABI50_0_0RCTRNGestureHandlerButtonViewProtocol>
@end

@implementation ABI50_0_0RNGestureHandlerButtonComponentView {
  ABI50_0_0RNGestureHandlerButton *_buttonView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ABI50_0_0RNGestureHandlerButtonProps>();
    _props = defaultProps;
    _buttonView = [[ABI50_0_0RNGestureHandlerButton alloc] initWithFrame:self.bounds];

    self.contentView = _buttonView;
  }

  return self;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ABI50_0_0RNGestureHandlerButtonComponentDescriptor>();
}

- (void)updateProps:(const Props::Shared &)props oldProps:(const Props::Shared &)oldProps
{
  const auto &newProps = *std::static_pointer_cast<const ABI50_0_0RNGestureHandlerButtonProps>(props);

  _buttonView.userEnabled = newProps.enabled;
#if !TARGET_OS_TV
  _buttonView.exclusiveTouch = newProps.exclusive;
#endif
  _buttonView.hitTestEdgeInsets = UIEdgeInsetsMake(
      -newProps.hitSlop.top, -newProps.hitSlop.left, -newProps.hitSlop.bottom, -newProps.hitSlop.right);

  [super updateProps:props oldProps:oldProps];
}
@end

Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RNGestureHandlerButtonCls(void)
{
  return ABI50_0_0RNGestureHandlerButtonComponentView.class;
}

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
