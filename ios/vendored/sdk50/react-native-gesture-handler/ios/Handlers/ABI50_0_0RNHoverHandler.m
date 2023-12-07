//
//  ABI50_0_0RNHoverHandler.m
//  ABI50_0_0RNGestureHandler
//
//  Created by Jakub Piasecki on 31/03/2023.
//

#import "ABI50_0_0RNHoverHandler.h"

#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

#define CHECK_TARGET(__VERSION__)                                                \
  defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && defined(__IPHONE_##__VERSION__) && \
      __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_##__VERSION__ && !TARGET_OS_TV

typedef NS_ENUM(NSInteger, ABI50_0_0RNGestureHandlerHoverEffect) {
  ABI50_0_0RNGestureHandlerHoverEffectNone = 0,
  ABI50_0_0RNGestureHandlerHoverEffectLift,
  ABI50_0_0RNGestureHandlerHoverEffectHightlight,
};

#if CHECK_TARGET(13_4)

API_AVAILABLE(ios(13.4))
@interface ABI50_0_0RNBetterHoverGestureRecognizer : UIHoverGestureRecognizer <UIPointerInteractionDelegate>

- (id)initWithGestureHandler:(ABI50_0_0RNGestureHandler *)gestureHandler;

@property (nonatomic) ABI50_0_0RNGestureHandlerHoverEffect hoverEffect;

@end

@implementation ABI50_0_0RNBetterHoverGestureRecognizer {
  __weak ABI50_0_0RNGestureHandler *_gestureHandler;
}

- (id)initWithGestureHandler:(ABI50_0_0RNGestureHandler *)gestureHandler
{
  if ((self = [super initWithTarget:gestureHandler action:@selector(handleGesture:)])) {
    _gestureHandler = gestureHandler;
    _hoverEffect = ABI50_0_0RNGestureHandlerHoverEffectNone;
  }
  return self;
}

- (void)triggerAction
{
  [_gestureHandler handleGesture:self];
}

- (void)cancel
{
  self.enabled = NO;
}

- (UIPointerStyle *)pointerInteraction:(UIPointerInteraction *)interaction styleForRegion:(UIPointerRegion *)region
{
  if (interaction.view != nil && _hoverEffect != ABI50_0_0RNGestureHandlerHoverEffectNone) {
    UITargetedPreview *preview = [[UITargetedPreview alloc] initWithView:interaction.view];
    UIPointerEffect *effect = nil;

    if (_hoverEffect == ABI50_0_0RNGestureHandlerHoverEffectLift) {
      effect = [UIPointerLiftEffect effectWithPreview:preview];
    } else if (_hoverEffect == ABI50_0_0RNGestureHandlerHoverEffectHightlight) {
      effect = [UIPointerHoverEffect effectWithPreview:preview];
    }

    return [UIPointerStyle styleWithEffect:effect shape:nil];
  }

  return nil;
}

@end

#endif

@implementation ABI50_0_0RNHoverGestureHandler {
#if CHECK_TARGET(13_4)
  UIPointerInteraction *_pointerInteraction;
#endif
}

- (instancetype)initWithTag:(NSNumber *)tag
{
#if TARGET_OS_TV
  ABI50_0_0RCTLogWarn(@"Hover gesture handler is not supported on tvOS");
#endif

  if ((self = [super initWithTag:tag])) {
#if CHECK_TARGET(13_4)
    if (@available(iOS 13.4, *)) {
      _recognizer = [[ABI50_0_0RNBetterHoverGestureRecognizer alloc] initWithGestureHandler:self];
      _pointerInteraction =
          [[UIPointerInteraction alloc] initWithDelegate:(id<UIPointerInteractionDelegate>)_recognizer];
    }
#endif
  }
  return self;
}

- (void)bindToView:(UIView *)view
{
#if CHECK_TARGET(13_4)
  if (@available(iOS 13.4, *)) {
    [super bindToView:view];
    [view addInteraction:_pointerInteraction];
  }
#endif
}

- (void)unbindFromView
{
#if CHECK_TARGET(13_4)
  if (@available(iOS 13.4, *)) {
    [super unbindFromView];
    [self.recognizer.view removeInteraction:_pointerInteraction];
  }
#endif
}

- (void)resetConfig
{
  [super resetConfig];

#if CHECK_TARGET(13_4)
  if (@available(iOS 13.4, *)) {
    ABI50_0_0RNBetterHoverGestureRecognizer *recognizer = (ABI50_0_0RNBetterHoverGestureRecognizer *)_recognizer;
    recognizer.hoverEffect = ABI50_0_0RNGestureHandlerHoverEffectNone;
  }
#endif
}

- (void)configure:(NSDictionary *)config
{
  [super configure:config];

#if CHECK_TARGET(13_4)
  if (@available(iOS 13.4, *)) {
    ABI50_0_0RNBetterHoverGestureRecognizer *recognizer = (ABI50_0_0RNBetterHoverGestureRecognizer *)_recognizer;
    APPLY_INT_PROP(hoverEffect);
  }
#endif
}

- (ABI50_0_0RNGestureHandlerEventExtraData *)eventExtraData:(UIGestureRecognizer *)recognizer
{
  return [ABI50_0_0RNGestureHandlerEventExtraData forPosition:[recognizer locationInView:recognizer.view]
                                withAbsolutePosition:[recognizer locationInView:recognizer.view.window]];
}

@end
