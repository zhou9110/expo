#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ABI50_0_0RNGHTouchEventType.h"
#import "ABI50_0_0RNGestureHandlerState.h"

@interface ABI50_0_0RNGestureHandlerEventExtraData : NSObject

@property (readonly) NSDictionary *data;

- (instancetype)initWithData:(NSDictionary *)data;

+ (ABI50_0_0RNGestureHandlerEventExtraData *)forPosition:(CGPoint)position withAbsolutePosition:(CGPoint)absolutePosition;
+ (ABI50_0_0RNGestureHandlerEventExtraData *)forPosition:(CGPoint)position
                           withAbsolutePosition:(CGPoint)absolutePosition
                            withNumberOfTouches:(NSUInteger)numberOfTouches;
+ (ABI50_0_0RNGestureHandlerEventExtraData *)forPosition:(CGPoint)position
                           withAbsolutePosition:(CGPoint)absolutePosition
                            withNumberOfTouches:(NSUInteger)numberOfTouches
                                   withDuration:(NSUInteger)duration;
+ (ABI50_0_0RNGestureHandlerEventExtraData *)forPan:(CGPoint)position
                      withAbsolutePosition:(CGPoint)absolutePosition
                           withTranslation:(CGPoint)translation
                              withVelocity:(CGPoint)velocity
                       withNumberOfTouches:(NSUInteger)numberOfTouches;
+ (ABI50_0_0RNGestureHandlerEventExtraData *)forForce:(CGFloat)force
                                 forPosition:(CGPoint)position
                        withAbsolutePosition:(CGPoint)absolutePosition
                         withNumberOfTouches:(NSUInteger)numberOfTouches;
+ (ABI50_0_0RNGestureHandlerEventExtraData *)forPinch:(CGFloat)scale
                              withFocalPoint:(CGPoint)focalPoint
                                withVelocity:(CGFloat)velocity
                         withNumberOfTouches:(NSUInteger)numberOfTouches;
+ (ABI50_0_0RNGestureHandlerEventExtraData *)forRotation:(CGFloat)rotation
                                withAnchorPoint:(CGPoint)anchorPoint
                                   withVelocity:(CGFloat)velocity
                            withNumberOfTouches:(NSUInteger)numberOfTouches;
+ (ABI50_0_0RNGestureHandlerEventExtraData *)forEventType:(ABI50_0_0RNGHTouchEventType)eventType
                             withChangedPointers:(NSArray<NSDictionary *> *)changedPointers
                                 withAllPointers:(NSArray<NSDictionary *> *)allPointers
                             withNumberOfTouches:(NSUInteger)numberOfTouches;
+ (ABI50_0_0RNGestureHandlerEventExtraData *)forPointerInside:(BOOL)pointerInside;
@end

@interface ABI50_0_0RNGestureHandlerEvent : NSObject <ABI50_0_0RCTEvent>

- (instancetype)initWithABI50_0_0ReactTag:(NSNumber *)ABI50_0_0ReactTag
                      handlerTag:(NSNumber *)handlerTag
                           state:(ABI50_0_0RNGestureHandlerState)state
                       extraData:(ABI50_0_0RNGestureHandlerEventExtraData *)extraData
                   coalescingKey:(uint16_t)coalescingKey NS_DESIGNATED_INITIALIZER;

@end

@interface ABI50_0_0RNGestureHandlerStateChange : NSObject <ABI50_0_0RCTEvent>

- (instancetype)initWithABI50_0_0ReactTag:(NSNumber *)ABI50_0_0ReactTag
                      handlerTag:(NSNumber *)handlerTag
                           state:(ABI50_0_0RNGestureHandlerState)state
                       prevState:(ABI50_0_0RNGestureHandlerState)prevState
                       extraData:(ABI50_0_0RNGestureHandlerEventExtraData *)extraData NS_DESIGNATED_INITIALIZER;

@end
