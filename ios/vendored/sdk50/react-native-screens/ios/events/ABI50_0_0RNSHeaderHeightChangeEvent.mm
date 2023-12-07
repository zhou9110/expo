#import "ABI50_0_0RNSHeaderHeightChangeEvent.h"
#import <ABI50_0_0React/ABI50_0_0RCTAssert.h>

@implementation ABI50_0_0RNSHeaderHeightChangeEvent {
  double _headerHeight;
}

@synthesize viewTag = _viewTag;
@synthesize eventName = _eventName;

- (instancetype)initWithEventName:(NSString *)eventName ABI50_0_0ReactTag:(NSNumber *)ABI50_0_0ReactTag headerHeight:(double)headerHeight
{
  ABI50_0_0RCTAssertParam(ABI50_0_0ReactTag);

  if ((self = [super init])) {
    _eventName = [eventName copy];
    _viewTag = ABI50_0_0ReactTag;
    _headerHeight = headerHeight;
  }
  return self;
}

ABI50_0_0RCT_NOT_IMPLEMENTED(-(instancetype)init)

- (NSDictionary *)body
{
  NSDictionary *body = @{
    @"headerHeight" : @(_headerHeight),
  };

  return body;
}

- (BOOL)canCoalesce
{
  return YES;
}

- (uint16_t)coalescingKey
{
  return _headerHeight;
}

- (id<ABI50_0_0RCTEvent>)coalesceWithEvent:(id<ABI50_0_0RCTEvent>)newEvent
{
  return newEvent;
}

+ (NSString *)moduleDotMethod
{
  return @"ABI50_0_0RCTEventEmitter.receiveEvent";
}

- (NSArray *)arguments
{
  return @[ self.viewTag, ABI50_0_0RCTNormalizeInputEventName(self.eventName), [self body] ];
}

@end
