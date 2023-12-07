#ifndef ABI50_0_0RCT_NEW_ARCH_ENABLED

#import <Foundation/Foundation.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0RCTEventDispatcher (Reanimated)

- (void)reanimated_sendEvent:(id<ABI50_0_0RCTEvent>)event;

@end

NS_ASSUME_NONNULL_END

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
