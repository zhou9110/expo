#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcherProtocol.h>

@interface ABI50_0_0RNSHeaderHeightChangeEvent : NSObject <ABI50_0_0RCTEvent>

- (instancetype)initWithEventName:(NSString *)eventName ABI50_0_0ReactTag:(NSNumber *)ABI50_0_0ReactTag headerHeight:(double)headerHeight;

@end
