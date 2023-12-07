#ifndef ABI50_0_0RCT_NEW_ARCH_ENABLED

#import <ABI50_0_0RNReanimated/ABI50_0_0RCTEventDispatcher+Reanimated.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>
#import <objc/message.h>

@implementation ABI50_0_0RCTEventDispatcher (Reanimated)

- (void)reanimated_sendEvent:(id<ABI50_0_0RCTEvent>)event
{
  // Pass the event to Reanimated
  static __weak ABI50_0_0RCTBridge *bridge;
  static __weak ABI50_0_0REAModule *reaModule;
  if (bridge != self.bridge) {
    bridge = self.bridge;
    reaModule = nil;
  }
  if (reaModule == nil) {
    reaModule = [bridge moduleForName:@"ReanimatedModule"];
  }
  [reaModule eventDispatcherWillDispatchEvent:event];

  // Pass the event to ABI50_0_0React Native by calling the original method
  [self reanimated_sendEvent:event];
}

+ (void)load
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, @selector(sendEvent:));
    Method swizzledMethod = class_getInstanceMethod(class, @selector(reanimated_sendEvent:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
  });
}

@end

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
