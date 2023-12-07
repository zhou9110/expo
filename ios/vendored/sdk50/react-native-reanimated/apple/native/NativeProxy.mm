#import <ABI50_0_0RNReanimated/LayoutAnimationsManager.h>
#import <ABI50_0_0RNReanimated/NativeMethods.h>
#import <ABI50_0_0RNReanimated/NativeProxy.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAAnimationsManager.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAIOSUIScheduler.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAJSIUtils.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAKeyboardEventObserver.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAMessageThread.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAModule.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REANodesManager.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REASwizzledUIManager.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0RNGestureHandlerStateManager.h>
#import <ABI50_0_0RNReanimated/ReanimatedRuntime.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0ReanimatedSensorContainer.h>

#ifndef NDEBUG
#import <ABI50_0_0RNReanimated/ABI50_0_0REAScreensHelper.h>
#endif

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>
#import <ABI50_0_0React/ABI50_0_0RCTScheduler.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfacePresenter.h>
#import <react/renderer/core/ShadowNode.h>
#import <react/renderer/uimanager/primitives.h>
#endif

#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>

#if TARGET_IPHONE_SIMULATOR
#import <dlfcn.h>
#endif

#import <ABI50_0_0RNReanimated/ABI50_0_0READisplayLink.h>

@interface ABI50_0_0RCTBridge (JSIRuntime)
- (void *)runtime;
@end

@interface ABI50_0_0RCTUIManager (DispatchCommand)
- (void)dispatchViewManagerCommand:(nonnull NSNumber *)ABI50_0_0ReactTag
                         commandID:(id /*(NSString or NSNumber) */)commandID
                       commandArgs:(NSArray<id> *)commandArgs;
@end

namespace ABI50_0_0reanimated {

using namespace ABI50_0_0facebook;
using namespace ABI50_0_0React;

static CGFloat SimAnimationDragCoefficient(void)
{
  static float (*UIAnimationDragCoefficient)(void) = NULL;
#if TARGET_IPHONE_SIMULATOR
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    UIAnimationDragCoefficient = (float (*)(void))dlsym(RTLD_DEFAULT, "UIAnimationDragCoefficient");
  });
#endif
  return UIAnimationDragCoefficient ? UIAnimationDragCoefficient() : 1.f;
}

static CFTimeInterval calculateTimestampWithSlowAnimations(CFTimeInterval currentTimestamp)
{
#if TARGET_IPHONE_SIMULATOR
  static CFTimeInterval dragCoefChangedTimestamp = CACurrentMediaTime();
  static CGFloat previousDragCoef = SimAnimationDragCoefficient();

  const CGFloat dragCoef = SimAnimationDragCoefficient();
  if (previousDragCoef != dragCoef) {
    previousDragCoef = dragCoef;
    dragCoefChangedTimestamp = CACurrentMediaTime();
  }

  const bool areSlowAnimationsEnabled = dragCoef != 1.f;
  if (areSlowAnimationsEnabled) {
    return (dragCoefChangedTimestamp + (currentTimestamp - dragCoefChangedTimestamp) / dragCoef);
  } else {
    return currentTimestamp;
  }
#else
  return currentTimestamp;
#endif
}

static NSSet *convertProps(jsi::Runtime &rt, const jsi::Value &props)
{
  NSMutableSet *propsSet = [[NSMutableSet alloc] init];
  jsi::Array propsNames = props.asObject(rt).asArray(rt);
  for (int i = 0; i < propsNames.size(rt); i++) {
    NSString *propName = @(propsNames.getValueAtIndex(rt, i).asString(rt).utf8(rt).c_str());
    [propsSet addObject:propName];
  }
  return propsSet;
}

std::shared_ptr<NativeReanimatedModule> createReanimatedModule(
    ABI50_0_0RCTBridge *bridge,
    const std::shared_ptr<CallInvoker> &jsInvoker)
{
  ABI50_0_0REAModule *reaModule = [bridge moduleForClass:[ABI50_0_0REAModule class]];

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  // nothing
#else
  ABI50_0_0RCTUIManager *uiManager = reaModule.nodesManager.uiManager;
  auto updatePropsFunction = [reaModule](jsi::Runtime &rt, const jsi::Value &operations) -> void {
    auto array = operations.asObject(rt).asArray(rt);
    size_t length = array.size(rt);
    for (size_t i = 0; i < length; ++i) {
      auto item = array.getValueAtIndex(rt, i).asObject(rt);
      int viewTag = item.getProperty(rt, "tag").asNumber();
      const jsi::Value &viewName = item.getProperty(rt, "name");
      const jsi::Object &props = item.getProperty(rt, "updates").asObject(rt);

      NSString *nsViewName = [NSString stringWithCString:viewName.asString(rt).utf8(rt).c_str()
                                                encoding:[NSString defaultCStringEncoding]];

      NSDictionary *propsDict = convertJSIObjectToNSDictionary(rt, props);
      [reaModule.nodesManager updateProps:propsDict ofViewWithTag:[NSNumber numberWithInt:viewTag] withName:nsViewName];
    }
  };

  auto measureFunction = [uiManager](int viewTag) -> std::vector<std::pair<std::string, double>> {
    return measure(viewTag, uiManager);
  };

  auto scrollToFunction = [uiManager](int viewTag, double x, double y, bool animated) {
    scrollTo(viewTag, uiManager, x, y, animated);
  };

  auto dispatchCommandFunction =
      [uiManager](
          jsi::Runtime &rt, const int tag, const jsi::Value &commandNameValue, const jsi::Value &argsValue) -> void {
    NSNumber *viewTag = [NSNumber numberWithInt:tag];
    NSString *commandID = [NSString stringWithCString:commandNameValue.asString(rt).utf8(rt).c_str()
                                             encoding:[NSString defaultCStringEncoding]];
    NSArray *commandArgs = convertJSIArrayToNSArray(rt, argsValue.asObject(rt).asArray(rt));
    ABI50_0_0RCTExecuteOnUIManagerQueue(^{
      [uiManager dispatchViewManagerCommand:viewTag commandID:commandID commandArgs:commandArgs];
    });
  };

#endif

  id<ABI50_0_0RNGestureHandlerStateManager> gestureHandlerStateManager = nil;
  auto setGestureStateFunction = [gestureHandlerStateManager, bridge](int handlerTag, int newState) mutable {
    if (gestureHandlerStateManager == nil) {
      gestureHandlerStateManager = [bridge moduleForName:@"ABI50_0_0RNGestureHandlerModule"];
    }

    setGestureState(gestureHandlerStateManager, handlerTag, newState);
  };

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  // nothing
#else
  auto obtainPropFunction = [reaModule](
                                jsi::Runtime &rt, const int viewTag, const jsi::String &propName) -> jsi::Value {
    NSString *propNameConverted = [NSString stringWithFormat:@"%s", propName.utf8(rt).c_str()];
    std::string resultStr = std::string([[reaModule.nodesManager obtainProp:[NSNumber numberWithInt:viewTag]
                                                                   propName:propNameConverted] UTF8String]);
    jsi::Value val = jsi::String::createFromUtf8(rt, resultStr);
    return val;
  };
#endif

  auto jsQueue = std::make_shared<ABI50_0_0REAMessageThread>([NSRunLoop currentRunLoop], ^(NSError *error) {
    throw error;
  });

  jsi::Runtime &rnRuntime = *reinterpret_cast<ABI50_0_0facebook::jsi::Runtime *>(reaModule.bridge.runtime);

  std::shared_ptr<UIScheduler> uiScheduler = std::make_shared<ABI50_0_0REAIOSUIScheduler>();

  auto nodesManager = reaModule.nodesManager;

  auto maybeFlushUIUpdatesQueueFunction = [nodesManager]() { [nodesManager maybeFlushUIUpdatesQueue]; };

  auto requestRender = [nodesManager](std::function<void(double)> onRender, jsi::Runtime &rt) {
    [nodesManager postOnAnimation:^(ABI50_0_0READisplayLink *displayLink) {
#if !TARGET_OS_OSX
      auto targetTimestamp = displayLink.targetTimestamp;
#else
      // TODO macOS targetTimestamp isn't available on macOS
      auto targetTimestamp = displayLink.timestamp + displayLink.duration;
#endif
      double frameTimestamp = calculateTimestampWithSlowAnimations(targetTimestamp) * 1000;
      onRender(frameTimestamp);
    }];
  };

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  auto synchronouslyUpdateUIPropsFunction = [nodesManager](jsi::Runtime &rt, Tag tag, const jsi::Object &props) {
    NSNumber *viewTag = @(tag);
    NSDictionary *uiProps = convertJSIObjectToNSDictionary(rt, props);
    [nodesManager synchronouslyUpdateViewOnUIThread:viewTag props:uiProps];
  };

  auto progressLayoutAnimation = [=](jsi::Runtime &rt, int tag, const jsi::Object &newStyle, bool isSharedTransition) {
    // noop
  };

  auto endLayoutAnimation = [=](int tag, bool removeView) {
    // noop
  };

#else
  // Layout Animations start
  ABI50_0_0REAAnimationsManager *animationsManager = reaModule.animationsManager;
  __weak ABI50_0_0REAAnimationsManager *weakAnimationsManager = animationsManager;

  auto progressLayoutAnimation = [=](jsi::Runtime &rt, int tag, const jsi::Object &newStyle, bool isSharedTransition) {
    NSDictionary *propsDict = convertJSIObjectToNSDictionary(rt, newStyle);
    [weakAnimationsManager progressLayoutAnimationWithStyle:propsDict
                                                     forTag:@(tag)
                                         isSharedTransition:isSharedTransition];
  };

  auto endLayoutAnimation = [=](int tag, bool removeView) {
    [weakAnimationsManager endLayoutAnimationForTag:@(tag) removeView:removeView];
  };

  auto configurePropsFunction = [reaModule](
                                    jsi::Runtime &rt, const jsi::Value &uiProps, const jsi::Value &nativeProps) {
    NSSet *uiPropsSet = convertProps(rt, uiProps);
    NSSet *nativePropsSet = convertProps(rt, nativeProps);
    [reaModule.nodesManager configureUiProps:uiPropsSet andNativeProps:nativePropsSet];
  };

  // Layout Animations end
#endif

  auto getAnimationTimestamp = []() { return calculateTimestampWithSlowAnimations(CACurrentMediaTime()) * 1000; };

  // sensors
  ABI50_0_0ReanimatedSensorContainer *reanimatedSensorContainer = [[ABI50_0_0ReanimatedSensorContainer alloc] init];
  auto registerSensorFunction =
      [=](int sensorType, int interval, int iosReferenceFrame, std::function<void(double[], int)> setter) -> int {
    return [reanimatedSensorContainer registerSensor:(ABI50_0_0ReanimatedSensorType)sensorType
                                            interval:interval
                                   iosReferenceFrame:iosReferenceFrame
                                              setter:^(double *data, int orientationDegrees) {
                                                setter(data, orientationDegrees);
                                              }];
  };

  auto unregisterSensorFunction = [=](int sensorId) { [reanimatedSensorContainer unregisterSensor:sensorId]; };
  // end sensors

  // keyboard events

  ABI50_0_0REAKeyboardEventObserver *keyboardObserver = [[ABI50_0_0REAKeyboardEventObserver alloc] init];
  auto subscribeForKeyboardEventsFunction =
      [=](std::function<void(int keyboardState, int height)> keyboardEventDataUpdater, bool isStatusBarTranslucent) {
        // ignore isStatusBarTranslucent - it's Android only
        return [keyboardObserver subscribeForKeyboardEvents:^(int keyboardState, int height) {
          keyboardEventDataUpdater(keyboardState, height);
        }];
      };

  auto unsubscribeFromKeyboardEventsFunction = [=](int listenerId) {
    [keyboardObserver unsubscribeFromKeyboardEvents:listenerId];
  };
  // end keyboard events

  PlatformDepMethodsHolder platformDepMethodsHolder = {
      requestRender,
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
      synchronouslyUpdateUIPropsFunction,
#else
      updatePropsFunction,
      scrollToFunction,
      dispatchCommandFunction,
      measureFunction,
      configurePropsFunction,
      obtainPropFunction,
#endif
      getAnimationTimestamp,
      progressLayoutAnimation,
      endLayoutAnimation,
      registerSensorFunction,
      unregisterSensorFunction,
      setGestureStateFunction,
      subscribeForKeyboardEventsFunction,
      unsubscribeFromKeyboardEventsFunction,
      maybeFlushUIUpdatesQueueFunction,
  };

  auto nativeReanimatedModule =
      std::make_shared<NativeReanimatedModule>(rnRuntime, jsInvoker, jsQueue, uiScheduler, platformDepMethodsHolder);

  [reaModule.nodesManager registerEventHandler:^(id<ABI50_0_0RCTEvent> event) {
    // handles ABI50_0_0RCTEvents from ABI50_0_0RNGestureHandler
    std::string eventName = [event.eventName UTF8String];
    int emitterABI50_0_0ReactTag = [event.viewTag intValue];
    id eventData = [event arguments][2];
    jsi::Runtime &uiRuntime = nativeReanimatedModule->getUIRuntime();
    jsi::Value payload = convertObjCObjectToJSIValue(uiRuntime, eventData);
    double currentTime = CACurrentMediaTime() * 1000;
    nativeReanimatedModule->handleEvent(eventName, emitterABI50_0_0ReactTag, payload, currentTime);
  }];

  std::weak_ptr<NativeReanimatedModule> weakNativeReanimatedModule = nativeReanimatedModule; // to avoid retain cycle
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
  [reaModule.nodesManager registerPerformOperations:^() {
    if (auto nativeReanimatedModule = weakNativeReanimatedModule.lock()) {
      nativeReanimatedModule->performOperations();
    }
  }];
#else
  // Layout Animation callbacks setup
  [animationsManager
      setAnimationStartingBlock:^(NSNumber *_Nonnull tag, LayoutAnimationType type, NSDictionary *_Nonnull values) {
        if (auto nativeReanimatedModule = weakNativeReanimatedModule.lock()) {
          jsi::Runtime &rt = nativeReanimatedModule->getUIRuntime();
          jsi::Object yogaValues(rt);
          for (NSString *key in values.allKeys) {
            NSObject *value = values[key];
            if ([values[key] isKindOfClass:[NSArray class]]) {
              NSArray *transformArray = (NSArray *)value;
              jsi::Array matrix(rt, 9);
              for (int i = 0; i < 9; i++) {
                matrix.setValueAtIndex(rt, i, [(NSNumber *)transformArray[i] doubleValue]);
              }
              yogaValues.setProperty(rt, [key UTF8String], matrix);
            } else {
              yogaValues.setProperty(rt, [key UTF8String], [(NSNumber *)value doubleValue]);
            }
          }
          nativeReanimatedModule->layoutAnimationsManager().startLayoutAnimation(rt, [tag intValue], type, yogaValues);
        }
      }];

  [animationsManager setHasAnimationBlock:^(NSNumber *_Nonnull tag, LayoutAnimationType type) {
    if (auto nativeReanimatedModule = weakNativeReanimatedModule.lock()) {
      bool hasLayoutAnimation =
          nativeReanimatedModule->layoutAnimationsManager().hasLayoutAnimation([tag intValue], type);
      return hasLayoutAnimation ? YES : NO;
    }
    return NO;
  }];

  [animationsManager setShouldAnimateExitingBlock:^(NSNumber *_Nonnull tag, BOOL shouldAnimate) {
    if (auto nativeReanimatedModule = weakNativeReanimatedModule.lock()) {
      bool shouldAnimateExiting =
          nativeReanimatedModule->layoutAnimationsManager().shouldAnimateExiting([tag intValue], shouldAnimate);
      return shouldAnimateExiting ? YES : NO;
    }
    return NO;
  }];

  [animationsManager setAnimationRemovingBlock:^(NSNumber *_Nonnull tag) {
    if (auto nativeReanimatedModule = weakNativeReanimatedModule.lock()) {
      nativeReanimatedModule->layoutAnimationsManager().clearLayoutAnimationConfig([tag intValue]);
    }
  }];

  [animationsManager setCancelAnimationBlock:^(NSNumber *_Nonnull tag) {
    if (auto nativeReanimatedModule = weakNativeReanimatedModule.lock()) {
      jsi::Runtime &rt = nativeReanimatedModule->getUIRuntime();
      nativeReanimatedModule->layoutAnimationsManager().cancelLayoutAnimation(rt, [tag intValue]);
    }
  }];

  [animationsManager setFindPrecedingViewTagForTransitionBlock:^NSNumber *_Nullable(NSNumber *_Nonnull tag) {
    if (auto nativeReanimatedModule = weakNativeReanimatedModule.lock()) {
      int resultTag =
          nativeReanimatedModule->layoutAnimationsManager().findPrecedingViewTagForTransition([tag intValue]);
      return resultTag == -1 ? nil : @(resultTag);
    }
    return nil;
  }];
#ifndef NDEBUG
  [animationsManager setCheckDuplicateSharedTagBlock:^(ABI50_0_0REAUIView *view, NSNumber *_Nonnull viewTag) {
    if (auto nativeReanimatedModule = weakNativeReanimatedModule.lock()) {
      ABI50_0_0REAUIView *screen = [ABI50_0_0REAScreensHelper getScreenForView:(ABI50_0_0REAUIView *)view];
      auto screenTag = [screen.ABI50_0_0ReactTag intValue];
      // Here we check if there are duplicate tags (we don't use return bool value currently)
      nativeReanimatedModule->layoutAnimationsManager().checkDuplicateSharedTag([viewTag intValue], screenTag);
    }
  }];
#endif // NDEBUG

#endif

  return nativeReanimatedModule;
}

} // namespace reanimated
