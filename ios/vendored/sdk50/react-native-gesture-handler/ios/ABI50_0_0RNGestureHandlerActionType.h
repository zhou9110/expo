#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ABI50_0_0RNGestureHandlerActionType) {
  ABI50_0_0RNGestureHandlerActionTypeReanimatedWorklet = 1, // Reanimated worklet
  ABI50_0_0RNGestureHandlerActionTypeNativeAnimatedEvent, // Animated.event with useNativeDriver: true
  ABI50_0_0RNGestureHandlerActionTypeJSFunctionOldAPI, // JS function or Animated.event with useNativeDriver: false using old
                                              // ABI50_0_0RNGH API
  ABI50_0_0RNGestureHandlerActionTypeJSFunctionNewAPI, // JS function or Animated.event with useNativeDriver: false using new
                                              // ABI50_0_0RNGH API
};
